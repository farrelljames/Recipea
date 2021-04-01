//
//  Category.swift
//  Recipea
//
//  Created by James  Farrell on 22/03/2021.
//  Copyright © 2021 James  Farrell. All rights reserved.
//

import Foundation

struct CategoriesModel: Codable {
    let categories: [Category]
}

struct Category: Codable {
    let strCategory: String
    let strCategoryThumb: String
    let strCategoryDescription: String
}
