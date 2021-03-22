//
//  RecipeManager.swift
//  Recipea
//
//  Created by James  Farrell on 22/03/2021.
//  Copyright © 2021 James  Farrell. All rights reserved.
//

import Foundation

protocol RecipeManagerDelegate {
    func didUpdateCategories(_ categories: Categories)
}

struct RecipeManager {
    let baseUrl = "https://www.themealdb.com/api/json/v1/1/"
    var delegate: RecipeManagerDelegate?
    
    func buildUrl(relativeUrl: String) -> URL {
        return URL(string: baseUrl + relativeUrl)!
    }
    
    func getMealCategories() {
        let url = buildUrl(relativeUrl: "categories.php")
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...209).contains(httpResponse.statusCode) else {
                return
            }
            
            if let safeData = data {
                if let jsonData = self.parseJSON(safeData) {
                    self.delegate?.didUpdateCategories(jsonData)
                }
            }
        }
        task.resume()
    }
    
//    func getMealById() {
//
//    }
//
//    func getMealByCategory() {
//
//    }
    
    func parseJSON(_ data: Data) -> Categories? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Categories.self, from: data)
            return Categories(categories: decodedData.categories)
        } catch {
//            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
