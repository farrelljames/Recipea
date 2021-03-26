//
//  DiscoverRecipeViewController.swift
//  Recipea
//
//  Created by James  Farrell on 22/03/2021.
//  Copyright © 2021 James  Farrell. All rights reserved.
//

import UIKit

class DiscoverRecipeViewController: UIViewController {
    var recipeID: String?
    var recipe: [RecipeData] = []
    var recipeManager = RecipeManager()
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeInstructions: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeManager.delegate = self
        recipeManager.getMealById(with: recipeID!)
    }
}

extension DiscoverRecipeViewController: RecipeManagerDelegate {
    func didUpdateWithData<T>(_ data: T) {
        DispatchQueue.main.async {
            let recipeObj = data as! RecipeModel
            self.recipe = recipeObj.meals
            self.recipeName.text = recipeObj.meals[0].strMeal
            self.recipeInstructions.text = recipeObj.meals[0].strInstructions
        }
    }
    
    func didFailWithError(error: Error) {
        print("Failed with: \(error)")
    }
}
