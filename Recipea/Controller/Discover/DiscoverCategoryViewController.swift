//
//  DiscoverCategoryViewController.swift
//  Recipea
//
//  Created by James  Farrell on 22/03/2021.
//  Copyright © 2021 James  Farrell. All rights reserved.
//

import UIKit

class DiscoverCategoryViewController: UITableViewController {
    var category: String?
    var recipeList: [RecipeDetails] = []
    var recipeManager = RecipeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeManager.delegate = self
        recipeManager.getMealByCategory(with: category!)
        
        tableView.register(UINib(nibName: K.CellIdentifiers.recipeCell, bundle: nil), forCellReuseIdentifier: K.CellIdentifiers.recipeCell)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        cell.recipeLabel.text = recipeList[indexPath.row].strMeal
        cell.imageView?.image = #imageLiteral(resourceName: "Burger")
        
        return cell
    }
}

extension DiscoverCategoryViewController: RecipeManagerDelegate {
    func didUpdateWithData<T>(_ data: T) {
        DispatchQueue.main.async {
            print(data)
            let recipeListObj = data as! RecipeListModel
            self.recipeList = recipeListObj.meals
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print("Failed with error: \(error)")
    }
}
