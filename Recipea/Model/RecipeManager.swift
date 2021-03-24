//
//  RecipeManager.swift
//  Recipea
//
//  Created by James  Farrell on 22/03/2021.
//  Copyright © 2021 James  Farrell. All rights reserved.
//

import Foundation

protocol RecipeManagerDelegate {
    func didUpdateWithData<T>(_ data: T)
    func didFailWithError(error: Error)
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
                if let parsedData: CategoriesModel = self.parseJSON(safeData.self) {
                    self.delegate?.didUpdateWithData(parsedData)
                }
            }
        }
        task.resume()
    }
    
    func getMealById(id: Int) {
        let url = buildUrl(relativeUrl: "lookup.php?i=\(id)")
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...209).contains(httpResponse.statusCode) else {
                return
            }

            if let data = data {
                if let safeData: RecipeModel = self.parseJSON(data.self) {
                    self.delegate?.didUpdateWithData(safeData)
                }
            }
        }
        task.resume()
    }

    func getMealByCategory(with category: String) {
        let url = buildUrl(relativeUrl: "filter.php?c=\(category)")
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...209).contains(httpResponse.statusCode) else {
                return
            }

            if let data = data {
                if let safeData: RecipeListModel = self.parseJSON(data.self) {
                    self.delegate?.didUpdateWithData(safeData)
                }
            }
        }
        task.resume()
    }
    
    func parseJSON<T: Decodable>(_ data: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
