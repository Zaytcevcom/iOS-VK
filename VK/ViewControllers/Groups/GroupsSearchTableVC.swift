//
//  GroupsSearchTableViewController.swift
//  VK
//
//  Created by Konstantin Zaytcev on 18.12.2021.
//

import UIKit

private let reuseIdentifier = "groupCell"

class GroupsSearchTableVC: UITableViewController {

    var groups = [GroupModel]()
    
    private let networkService = NetworkService()
    
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(
            UINib(nibName: "GroupCell", bundle: nil),
            forCellReuseIdentifier: reuseIdentifier
        )
        
        /*self.tableView
            .addGestureRecognizer(
                UITapGestureRecognizer(
                    target: self,
                    action: #selector(hideKeyboard)
                )
            )*/
    }
    
    @objc func hideKeyboard() {
        self.searchBar?.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? GroupCell
        else {
            return UITableViewCell()
        }

        let currentItem = groups[indexPath.row]
        
        cell.configure(name: currentItem.name, photo100: currentItem.photo100)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        performSegue(withIdentifier: "addGroup", sender: nil)
    }

}

extension GroupsSearchTableVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (!searchText.isEmpty) {
            networkService.methodGroupsSearch(query: searchText) { [weak self] result in
                switch result {
                case .success(let items):
                    self?.groups = items
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
