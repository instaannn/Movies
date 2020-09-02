//
//  MoviesModel.swift
//  Movies
//
//  Created by Анна Сычева on 26.08.2020.
//  Copyright © 2020 Анна Сычева. All rights reserved.
//

struct Results: Decodable {
    var results: [Movies]?
}

struct Movies: Decodable {
    var original_language: String?
    var title: String?
    var vote_average: Double?
    var release_date: String?
    var vote_count: Int?
    var poster_path: String?
    var id: Int?
}
