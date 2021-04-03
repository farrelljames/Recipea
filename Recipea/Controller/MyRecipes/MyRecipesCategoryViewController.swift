//
//  MyRecipesCategoryViewController.swift
//  Recipea
//
//  Created by James  Farrell on 22/03/2021.
//  Copyright © 2021 James  Farrell. All rights reserved.
//

import UIKit

class MyRecipesCategoryViewController: UITableViewController {
    var category: String?
    var recipeList: [RecipeDb] = []
    var selectedRecipeId: Int32?
    var databaseManager = DatabaseManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeList = databaseManager.loadRecipes(from: category!)!
        tableView.register(UINib(nibName: K.CellIdentifiers.recipeCell, bundle: nil), forCellReuseIdentifier: K.CellIdentifiers.recipeCell)
    }
}

// MARK: - Table view data source

extension MyRecipesCategoryViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifiers.recipeCell, for: indexPath) as! RecipeCell
        
        cell.recipeLabel.text = recipeList[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipeId = recipeList[indexPath.row].recipeId
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: K.SegueId.myRecipeRecipe, sender: self)
    }
}

// MARK: - Navigation

extension MyRecipesCategoryViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SegueId.myRecipeRecipe {
            if let vc = segue.destination as? MyRecipesRecipeViewController {
                vc.recipeId = selectedRecipeId
                vc.category = category
            }
        }
    }
}
