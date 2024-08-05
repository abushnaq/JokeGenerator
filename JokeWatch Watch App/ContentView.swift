//
//  ContentView.swift
//  JokeWatch Watch App
//
//  Created by Ahmad Remote on 8/1/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var loadedJokes : LoadedJokes = LoadedJokes()
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: CategorySelector()) {
                    Text(loadedJokes.jokeCategory ?? "Pick category")
                }
                
                NavigationLink(destination: ShowJoke()) {
                    Text("Tell me a joke")
                }
                
            }
            .padding()
            .onAppear {
                Task {
                    await loadedJokes.fetchJokeCategories()
                }
        }
        }.environmentObject(loadedJokes)
    }
}

#Preview {
    ContentView()
}
