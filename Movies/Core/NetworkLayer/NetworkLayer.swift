//
//  NetworkLayer.swift
//  Movies
//
//  Created by Анна Сычева on 03.09.2020.
//  Copyright © 2020 Анна Сычева. All rights reserved.
//

import Foundation

//MARK: - NetworkLayer

final class NetworkLayer: INetworkLayer {
    
    func downloadJson(complition: @escaping (Results) -> Void) {
        let urlString = Url.url
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { ( data, _, error ) in
            guard let data = data else { return }
            guard error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(Results.self, from: data)
                complition(results)
            } catch {
                print("Json Error")
            }
        } .resume()
    }
    
    func requestTrailer(for id: Int, complition: @escaping (Trailers) -> Void) {
        guard let url = URL(string: "\(Url.urlDetail)\(id)/videos?api_key=\(Url.token)") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error)  in
            if let data = data,
                (response as? HTTPURLResponse)?.statusCode == 200,
                error == nil {
                
                do {
                    let trailers = try JSONDecoder().decode(Trailers.self, from: data)
                    complition(trailers)
                } catch {
                    print("Json Error")
                }
            } else {
                print("Network error")
            }
        }
        dataTask.resume()
    }
    
    func requestDetails(for id: Int, complition: @escaping (MovieDetail) -> Void) {
        guard let url = URL(string: "\(Url.urlDetail)\(id)?api_key=\(Url.token)") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error)  in
            if let data = data,
                (response as? HTTPURLResponse)?.statusCode == 200,
                error == nil {
                
                do {
                    let movieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
                    complition(movieDetail)
                } catch {
                    print("Json Error")
                }
                
            } else {
                print("Network error")
            }
        }
        dataTask.resume()
    }
    
}

