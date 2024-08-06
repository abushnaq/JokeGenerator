//
//  ContentView.swift
//  JokeGenerator
//
//  Created by Ahmad Bushnaq on 7/26/24.
//

import SwiftUI


struct ContentView: View {
    @StateObject var loadedJokes = LoadedJokes()
    var body: some View {
        VStack {
            GroupBox(label: Label("Jokes by category", systemImage: "arrow.down.circle.fill")) {
                    LabeledContent("Joke category") {
                        Picker(selection: $loadedJokes.jokeCategory, label: Text("Joke categories")) {
                            
                            ForEach($loadedJokes.jokeCategories, id: \.self) {
                                Text("\($0.wrappedValue)").tag(loadedJokes.jokeCategories.firstIndex(of: $0.wrappedValue))
                                }
                        }
                    }
                Button("Make me categorically laugh") {
                    Task
                    {
                        await loadedJokes.fetchJokesByCategory()
                    }
                }
            }
            
            GroupBox(label: Label("Random jokes", systemImage: "arrow.down.circle.fill")) {
                    LabeledContent("How many jokes shall we get?") {
                        Picker(selection: $loadedJokes.numberOfJokes, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                            
                            ForEach($loadedJokes.jokeCount, id: \.self) {
                                Text("\($0.wrappedValue)").tag($0.wrappedValue)
                                }
                            
                        }
                    }
                Button("Make me randomly laugh") {
                    Task
                    {
                        await loadedJokes.fetchRandomJokes()
                    }
                }
            }
            
            List {
                ForEach(loadedJokes.jokes, id: \.self) { joke in
                    VStack(alignment: .leading, content: {
                        Label(joke.setup, systemImage: "questionmark.app.fill")
                        Label(joke.punchline, systemImage: "rectangle.3.group.bubble.fill")
                            .padding(.top)
                    })
                }
            }
        }.onAppear {
            Task {
                await loadedJokes.fetchJokeCategories()
                
//                jokeTypes = await jokeFetcher.fetchJokeCategories()
//                if let firstType = jokeTypes.first
//                {
//                    jokeCategory = firstType
//                }
            }
        }
        .padding()
        
    }
}

#Preview {
    ContentView()
}
