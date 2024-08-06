//
//  CategorySelector.swift
//  JokeWatch Watch App
//
//  Created by Ahmad Remote on 8/5/24.
//

import SwiftUI

struct CategorySelector: View {
    @EnvironmentObject private var loadedJokes : LoadedJokes
    var body: some View {
        List(loadedJokes.jokeCategories, id: \.self, selection: $loadedJokes.selectedCategory) { jokeType in
                    Text(jokeType)
                .foregroundStyle(jokeType == loadedJokes.jokeCategory ? .blue : .white)
                }
    }
}

#Preview {
    CategorySelector()
}
