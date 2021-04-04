//
//  ShoppingListViewController.swift
//  Recipea
//
//  Created by James  Farrell on 22/03/2021.
//  Copyright © 2021 James  Farrell. All rights reserved.
//

import UIKit

class ShoppingListViewController: UITableViewController {
    var recipes: ShoppingListModel?
    var databaseManager = DatabaseManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipes = databaseManager.loadShoppingList()
    }
}

// MARK: - Table view data source

extension ShoppingListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes!.shoppingListStrings.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifiers.shoppingListCell, for: indexPath)
        
        cell.textLabel?.text = recipes?.shoppingListStrings[indexPath.row]
        cell.accessoryType = recipes!.measures[indexPath.row].checked ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        
        if cell?.accessoryType == .checkmark {
            databaseManager.updateShoppingListCheckedStatus(measure: recipes!.measures[indexPath.row], ingredient: recipes!.ingredients[indexPath.row])
            cell?.accessoryType = .none
        } else {
            databaseManager.updateShoppingListCheckedStatus(measure: recipes!.measures[indexPath.row], ingredient: recipes!.ingredients[indexPath.row])
            cell?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            databaseManager.deleteShoppingItem(ingredient: recipes!.ingredients[indexPath.row], measure: recipes!.measures[indexPath.row])
            recipes?.removeItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } 
    }
}
