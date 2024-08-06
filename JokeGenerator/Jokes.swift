//
//  Jokes.swift
//  JokeGenerator
//
//  Created by Ahmad Bushnaq on 7/26/24.
//

import Foundation

let defaultJokeCategory = "dad"
public class LoadedJokes : ObservableObject {
    private var jokeFetcher : JokeFetcher = JokeFetcher()
    
    @Published var jokeCategory : String = defaultJokeCategory
    
    // default categories will get overwritten by result from API call
    @Published var jokeCategories : [String] = ["general","knock-knock","programming","dad"]
    
    @Published var jokes : [Joke] = [Joke]()
        
    public var jokeCount : [String] = ["5", "10", "15", "20", "25"]
    @Published var numberOfJokes : String = "5"
    public var selectedCategory : String?
    {
        get
        {
            if jokeCategory.isEmpty
            {
                return nil
            }
            return jokeCategory
        }
        set
        {
            if let newValue
            {
                jokeCategory = newValue
            }
        }
    }
    
    func fetchRandomJokes() async
    {
        DispatchQueue.main.async
        { [self] in
            Task
            {
                jokes = await jokeFetcher.fetchRandomJokes(numberOfJokes)
            }
        }
    }
    
    func fetchJokesByCategory() async
    {
        DispatchQueue.main.async
        { [self] in
            Task
            {
                jokes = await self.jokeFetcher.fetchJokesByCategory(jokeCategory)
            }
        }
    }
    
    func fetchJokeCategories() async
    {
        DispatchQueue.main.async
        {
            Task
            {
                self.jokeCategories = await self.jokeFetcher.fetchJokeCategories()
            }
        }
    }
    
}


struct Joke : Codable, Hashable
{
    var type : String
    var setup : String
    var punchline : String
    var id : Int
}

public class JokeFetcher
{
    
    let jokesByCategoryEndPoint = "https://official-joke-api.appspot.com/jokes/%@/ten"
    let jokeCategoriesEndPoint = "https://official-joke-api.appspot.com/types"
    let randomJokesEndPoint = "https://official-joke-api.appspot.com/jokes/random/%@"

    func fetchJokesFromEndPoint(_ endPoint : String) async -> [Joke]
    {
        if let url = URL(string: endPoint)
        {
            do
            {
                let (data, _) = try await URLSession.shared.data(from: url)
                return try JSONDecoder().decode([Joke].self, from: data)
                
            } catch
            {
                print(error)
                return [Joke]()
            }
        }
        return [Joke]()
    }
    
    func fetchRandomJokes(_ number: String) async -> [Joke]
    {
        await fetchJokesFromEndPoint(String(format: randomJokesEndPoint, number))
    }
    
    func fetchJokesByCategory(_ category: String) async -> [Joke]
    {
        await fetchJokesFromEndPoint(String(format: jokesByCategoryEndPoint, category))
    }
    
    func fetchJokeCategories() async -> [String]
    {
        if let url = URL(string: jokeCategoriesEndPoint)
        {
            do
            {
                let (data, _) = try await URLSession.shared.data(from: url)
                return try JSONDecoder().decode([String].self, from: data)
                
            } catch
            {
                print(error)
                return [String]()
            }
        }
        return [String]()
    }
    
}

