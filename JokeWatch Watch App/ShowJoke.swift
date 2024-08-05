//
//  ShowJoke.swift
//  JokeWatch Watch App
//
//  Created by Ahmad Remote on 8/5/24.
//

import SwiftUI

struct ShowJoke: View {
    @EnvironmentObject private var loadedJokes : LoadedJokes
    var body: some View {
        VStack {
            Text(loadedJokes.jokes.first?.setup ?? "No loaded jokes!")
            Text(loadedJokes.jokes.first?.punchline ?? "No loaded jokes!")
        }.onAppear() {
            Task
            {
                await loadedJokes.fetchJokesByCategory()
            }
        }
        
    }
}

#Preview {
    ShowJoke()
}
