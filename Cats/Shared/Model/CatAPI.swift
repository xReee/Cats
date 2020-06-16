//
//  CatAPI.swift
//  Cats
//
//  Created by Renata Faria on 15/06/20.
//  Copyright © 2020 renatafaria. All rights reserved.
//

import Foundation
import Combine

class CatAPI {
    
    private static let configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 40
        return configuration
    }()
    private static let basePath = "https://api.imgur.com/3/gallery/search/?q=cats"
    private static let session = URLSession(configuration: configuration)
    private init() {}
    
    static func loadCat(onComplete:  @escaping (Result<[Cat], APIError>)->Void) {
        let url = NSURL(string: CatAPI.basePath)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("Client-ID f0cb2082880e323", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        var cats = [Cat]()
        
        CatAPI.session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if error != nil {
                onComplete(.failure(.taskError))
            }
            guard let response = response as? HTTPURLResponse else {
                onComplete(.failure(.badResponse))
                return
            }
            if response.statusCode != 200 {
                onComplete(.failure(.invalidStatusCode(response.statusCode)))
                return
            }
            guard let data = data else {
                onComplete(.failure(.noData))
                return
            }
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject],
                    let items = jsonResult["data"] as? Array<[String: AnyObject]> {
                    for cat in items {
                        if let imageArr = cat["images"] as? Array<[String: AnyObject]> {
                            for catImage in imageArr {
                                if let imgURL = catImage["link"] as? String {
                                    let id = catImage["id"] as? String
                                    let title = catImage["title"] as? String
                                    let description = catImage["description"] as? String
                                    let link = cat["link"] as? String
                                    let newCat = Cat(id: id, title: title, description: description, imgURL: imgURL, originURL: link)
                                    cats.append(newCat)
                                    break
                                }
                            }
                        }
                    }
                    onComplete(.success(cats))
                }
            } catch {
                onComplete(.failure(.invalidJSON))
            }
        }.resume()
    }
}

