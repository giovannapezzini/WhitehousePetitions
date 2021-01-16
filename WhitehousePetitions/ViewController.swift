//
//  ViewController.swift
//  WhitehousePetitions
//
//  Created by Giovanna Pezzini on 12/01/21.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var isSearching: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let urlString: String
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchPetition))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshPetitions))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showAlert))

        navigationItem.rightBarButtonItems = [refreshButton, searchButton]
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        showError(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.")
    }
    
    @objc func refreshPetitions() {
    
    }
    
    @objc func searchPetition() {
        let ac = UIAlertController(title: "Search petition", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Search", style: .default) {
            [weak self, weak ac] _ in
            guard let searchString = ac?.textFields?[0].text else { return }
            self?.updateSearchResults(searchString)
        }
                
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func updateSearchResults(_ searchString : String) {
        if searchString.isEmpty {
            filteredPetitions.removeAll()
            isSearching = false
            tableView.reloadData()
            return
        }
        
        isSearching = true
        filteredPetitions = petitions.filter({ $0.title.lowercased().contains(searchString.lowercased()) })
        print(filteredPetitions)
        tableView.reloadData()
    }
    
    @objc func showAlert() {
        let ac = UIAlertController(title: "Credits", message: "The data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let activeArray = isSearching ? filteredPetitions : petitions
        return activeArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        cell.accessoryType = .disclosureIndicator
        
        let activeArray = isSearching ? filteredPetitions : petitions
        cell.textLabel?.text = activeArray[indexPath.row].title
        cell.detailTextLabel?.text = activeArray[indexPath.row].body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        isSearching = false
        filteredPetitions.removeAll()
        tableView.reloadData()
    }
}
