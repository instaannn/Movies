//
//  MovieDetailModel.swift
//  Movies
//
//  Created by Анна Сычева on 30.08.2020.
//  Copyright © 2020 Анна Сычева. All rights reserved.
//

struct MovieDetail: Decodable {
    let id: Int
    let originalLanguage: String
    let title: String
    let overview: String
    let voteAverage: Double
    let releaseDate: String
    let posterPath: String
    let runtime: Int
    let genres: [Genres]
    
    enum CodingKeys: String, CodingKey {
        case id
        case originalLanguage = "original_language"
        case title
        case overview
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case runtime
        case genres
    }
}

struct Genres: Decodable {
    let id: Int
    let name: String
}
