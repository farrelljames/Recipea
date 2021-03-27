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
    var recipe: RecipeModelData?
    var recipeManager = RecipeManager()

    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeIngredients: UILabel!
    @IBOutlet weak var recipeInstructions: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeManager.delegate = self
        recipeManager.getMealById(with: recipeID!)
    }
}

//MARK: - Update UI View Methods

extension DiscoverRecipeViewController {
    func updateIngredientsLabel() {
        let sortedIngredients = recipe!.ingridients.sorted(by: <)
        let sortedMeasurements = recipe!.measures.sorted(by: <)
        
        for i in sortedIngredients {
            recipeIngredients.text = recipeIngredients.text! + "- \(sortedMeasurements[i.key - 1].value): \(i.value)\n"
        }
    }
}

extension DiscoverRecipeViewController: RecipeManagerDelegate {
    func didUpdateWithData<T>(_ data: T) {
        DispatchQueue.main.async {
            let recipeObj = data as! RecipeModelData
            self.recipe = recipeObj
            self.recipeName.text = recipeObj.name
            self.recipeInstructions.text = recipeObj.instructions
            self.updateIngredientsLabel()
        }
    }
    
    func didFailWithError(error: Error) {
        print("Failed with: \(error)")
    }
}
