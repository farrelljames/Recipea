//
//  MyRecipesRecipeViewController.swift
//  Recipea
//
//  Created by James  Farrell on 22/03/2021.
//  Copyright © 2021 James  Farrell. All rights reserved.
//

import UIKit

class MyRecipesRecipeViewController: UIViewController {
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeIngredientsLabel: UILabel!
    @IBOutlet weak var recipeInstructionsLabel: UILabel!
    
    var recipeId: Int32?
    var recipeObj: CompleteRecipe?
    var category: String?
    var databaseManager = DatabaseManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        recipeObj = databaseManager.loadRecipe(from: category!, with: recipeId!)
        updateUI()
    }
}

//MARK: - Update UI Methods

extension MyRecipesRecipeViewController {
    func updateUI() {
        recipeNameLabel.text = recipeObj?.recipe.name
        recipeInstructionsLabel.text = recipeObj?.recipe.instructions
        
        for (m, i) in zip(recipeObj!.measures, recipeObj!.Ingredients) {
            recipeIngredientsLabel.text = recipeIngredientsLabel.text! + "- \(m.measure!): \(i.name!)\n"
        }
    }
}

//MARK: - Bar button items

extension MyRecipesRecipeViewController {
    @IBAction func removeButtonPressed(_ sender: Any) {
        databaseManager.deleteRecipe(from: category!, recipe: recipeObj!)
        navigationController?.popToRootViewController(animated: true)
    }
}
