//
//  ViewController.swift
//  WhitehousePetitions
//
//  Created by Giovanna Pezzini on 12/01/21.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        navigationController?.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 0)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "Title goes here"
        cell.detailTextLabel?.text = "Description"
        return cell
    }
}

