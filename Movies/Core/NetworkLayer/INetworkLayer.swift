//
//  INetworkLayer.swift
//  Movies
//
//  Created by Анна Сычева on 03.09.2020.
//  Copyright © 2020 Анна Сычева. All rights reserved.
//

//MARK: - INetworkLayer

protocol INetworkLayer {
    func fetchResult(complition: @escaping (Result<Results, Error>) -> Void)
    func fetchTrailer(for id: Int, complition: @escaping(Result<Trailers, Error>) -> Void)
    func fetchDetails(for id: Int, complition: @escaping(Result<MovieDetail, Error>) -> Void)
}
