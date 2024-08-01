//
//  JokeWidget.swift
//  JokeWidget
//
//  Created by Ahmad Remote on 8/1/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    var jokeFetcher : JokeFetcher = JokeFetcher()
    var jokeCategory : String = "general"
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let jokes = await jokeFetcher.fetchJokesByCategory(jokeCategory)
        if let firstJoke = jokes.first
        {
            entries.first?.configuration.setup = firstJoke.setup
            entries.first?.configuration.punchline = firstJoke.punchline
        }
        
        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct JokeWidgetEntryView : View {
    var entry: Provider.Entry
    var body: some View {
        
            VStack(alignment: .leading, content: {
                Text("A joke to lighten up your day!")
                    .padding([.bottom])
                    .bold()
                Label((entry.configuration.setup ?? ""), systemImage: "questionmark.app.fill")
                Label((entry.configuration.punchline ?? ""), systemImage: "rectangle.3.group.bubble.fill")
            })
    }
}

struct JokeWidget: Widget {
    let kind: String = "JokeWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            JokeWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var joke: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.setup = "What's so funny?"
        intent.punchline = "A joke!"
        return intent
    }

}

#Preview(as: .systemSmall) {
    JokeWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .joke)
   
}
