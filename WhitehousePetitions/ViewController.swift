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
        
        configureTabBar()
        configureNavBar()
        configureTableView()
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    // MARK: - TabBar and NavBar methods
    
    func configureTabBar() {
        tabBarController?.delegate = self
    }
    
    func configureNavBar() {
        title = "Petitions"
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchPetition))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshPetitions))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showAlert))
        navigationItem.rightBarButtonItems = [refreshButton, searchButton]
    }
    
    @objc func refreshPetitions() {
        isSearching = false
        filteredPetitions.removeAll()
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    // MARK: - Fetch and parse Data
    
    @objc func fetchJSON() {
        DispatchQueue.main.async {
            let urlString: String
            
            if self.navigationController?.tabBarItem.tag == 0 {
                urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
            } else {
                urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
            }
            
            
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self.parse(json: data)
                    return
                }
                
                self.showError(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.")
            }
        }
    }
    
    func parse(json: Data) {
        DispatchQueue.main.async {
            let decoder = JSONDecoder()
            
            if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
                self.petitions = jsonPetitions.results
                self.tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
            } else {
                self.showError(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.")
            }
        }
    }
    
    @objc func showAlert() {
        let ac = UIAlertController(title: "Credits", message: "The data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    
    // MARK: - Search Methods
    
    @objc func searchPetition() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Search petition", message: nil, preferredStyle: .alert)
            ac.addTextField()
            
            let submitAction = UIAlertAction(title: "Search", style: .default) {
                [weak self, weak ac] _ in
                guard let searchString = ac?.textFields?[0].text else { return }
                self?.updateSearchResults(searchString)
            }
                    
            ac.addAction(submitAction)
            self.present(ac, animated: true)
        }
    }
    
    func updateSearchResults(_ searchString : String) {
        if searchString.isEmpty {
            filteredPetitions.removeAll()
            isSearching = false
            DispatchQueue.main.async { self.tableView.reloadData() }
            return
        }
        
        isSearching = true
        filteredPetitions = petitions.filter({ $0.title.lowercased().contains(searchString.lowercased()) || $0.body.lowercased().contains(searchString.lowercased()) })
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    // MARK: - TableView datasource and delegate methods
    
    func configureTableView() {
        tableView.register(PetitionCell.self, forCellReuseIdentifier: PetitionCell.reuseID)
        tableView.rowHeight = 118
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let activeArray = isSearching ? filteredPetitions : petitions
        return activeArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PetitionCell.reuseID) as! PetitionCell
                
        let activeArray = isSearching ? filteredPetitions : petitions
        let petition = activeArray[indexPath.row]
        cell.set(petition: petition)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITabBarControllerDelegate

extension ViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        isSearching = false
        filteredPetitions.removeAll()
        tableView.reloadData()
    }
}
