//
//  MoviesModel.swift
//  Movies
//
//  Created by Анна Сычева on 26.08.2020.
//  Copyright © 2020 Анна Сычева. All rights reserved.
//

//MARK: - Results

struct Results: Decodable {
    let results: [Movies]
}

//MARK: - Movies

struct Movies: Decodable {
    let originalLanguage: String
    let title: String
    let voteAverage: Double
    let releaseDate: String
    let voteCount: Int
    let posterPath: String
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case originalLanguage = "original_language"
        case title
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case voteCount = "vote_count"
        case posterPath = "poster_path"
        case id
    }
    
}
