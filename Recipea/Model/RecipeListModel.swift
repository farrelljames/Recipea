//
//  RecipeListView.swift
//  Recipea
//
//  Created by James  Farrell on 22/03/2021.
//  Copyright © 2021 James  Farrell. All rights reserved.
//

import Foundation

struct RecipeListModel: Codable {
    let meals: [RecipeDetails]
}

struct RecipeDetails: Codable{
    let strMeal: String
    let idMeal: String
}
