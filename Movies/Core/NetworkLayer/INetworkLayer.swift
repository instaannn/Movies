//
//  INetworkLayer.swift
//  Movies
//
//  Created by Анна Сычева on 03.09.2020.
//  Copyright © 2020 Анна Сычева. All rights reserved.
//

//MARK: - INetworkLayer

protocol INetworkLayer {
    func downloadJson(complition: @escaping (Results) -> Void)
    func requestTrailer(for id: Int, complition: @escaping (Trailers) -> Void)
    func requestDetails(for id: Int, complition: @escaping (MovieDetail) -> Void) 
}
