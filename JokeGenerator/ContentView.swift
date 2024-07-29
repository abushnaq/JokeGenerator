//
//  ContentView.swift
//  JokeGenerator
//
//  Created by Ahmad Bushnaq on 7/26/24.
//

import SwiftUI

public var jokeCount : [String] = ["5", "10", "15", "20", "25"]

struct ContentView: View {
    @State var jokeTypes : [String] = ["general","knock-knock","programming","dad"]

    @State var numberOfJokes : String = "5"
    @State var jokeCategory : String = "dad"
    @State var jokes : [Joke] = [Joke]()
    var jokeFetcher : JokeFetcher = JokeFetcher()
    var body: some View {
        VStack {
            GroupBox(label: Label("Jokes by category", systemImage: "arrow.down.circle.fill")) {
                    LabeledContent("Joke category") {
                        Picker(selection: $jokeCategory, label: Text("Joke categories")) {
                            
                            ForEach(jokeTypes, id: \.self) {
                                Text("\($0)").tag(jokeTypes.firstIndex(of: $0))
                                }
                        }
                    }
                Button("Make me categorically laugh") {
                    Task
                    {
                        jokes = await jokeFetcher.fetchJokesByCategory(jokeCategory)
                    }
                }
            }
            
            GroupBox(label: Label("Random jokes", systemImage: "arrow.down.circle.fill")) {
                    LabeledContent("How many jokes shall we get?") {
                        Picker(selection: $numberOfJokes, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                            
                            ForEach(jokeCount, id: \.self) {
                                Text("\($0)").tag($0)
                                }
                            
                        }
                    }
                Button("Make me randomly laugh") {
                    Task
                    {
                        jokes = await jokeFetcher.fetchRandomJokes(numberOfJokes)
                    }
                }
            }
            
            List {
                ForEach(jokes, id: \.self) { joke in
                    VStack(alignment: .leading, content: {
                        Label(joke.setup, systemImage: "questionmark.app.fill")
                        Label(joke.punchline, systemImage: "rectangle.3.group.bubble.fill")
                            .padding(.top)
                    })
                }
            }
        }.onAppear {
            Task {
                jokeTypes = await jokeFetcher.fetchJokeCategories()
                if let firstType = jokeTypes.first
                {
                    jokeCategory = firstType
                }
            }
        }
        .padding()
        
    }
}

#Preview {
    ContentView()
}
