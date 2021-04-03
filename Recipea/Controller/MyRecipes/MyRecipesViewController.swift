//
//  MyRecipesViewController.swift
//  Recipea
//
//  Created by James  Farrell on 22/03/2021.
//  Copyright © 2021 James  Farrell. All rights reserved.
//

import UIKit

class MyRecipesViewController: UITableViewController {
    var databaseManager = DatabaseManager()
    var categoryList: [CategoryDb] = []
    var selectedCategory: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryList = databaseManager.loadCategories()!
    }
}

// MARK: - Table view data source

extension MyRecipesViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRecipeCategoryCell", for: indexPath)
        cell.textLabel?.text = categoryList[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categoryList[indexPath.row].name
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: K.SegueId.myRecipeRecipeByCategory, sender: self)
    }
}

// MARK: - Navigation

extension MyRecipesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SegueId.myRecipeRecipeByCategory {
            if let vc = segue.destination as? MyRecipesCategoryViewController {
                vc.category = selectedCategory
            }
        }
    }
}
