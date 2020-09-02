//
//  TrailerVideoModel.swift
//  Movies
//
//  Created by Анна Сычева on 02.09.2020.
//  Copyright © 2020 Анна Сычева. All rights reserved.
//

struct Trailers: Decodable {
    var results: [Video]?
}

struct Video: Decodable {
    var key: String?
}
