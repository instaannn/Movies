//
//  MovieDetailModel.swift
//  Movies
//
//  Created by Анна Сычева on 30.08.2020.
//  Copyright © 2020 Анна Сычева. All rights reserved.
//

struct MovieDetail: Decodable {
    var id: Int?
    var original_language: String?
    var title: String?
    var overview: String?
    var vote_average: Double?
    var release_date: String?
    var poster_path: String?
    var runtime: Int?
    var genres: [Genres]?
}

struct Genres: Decodable {
    var id: Int?
    var name: String?
}
