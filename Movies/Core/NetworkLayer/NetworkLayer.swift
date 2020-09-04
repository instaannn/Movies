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
    
}

