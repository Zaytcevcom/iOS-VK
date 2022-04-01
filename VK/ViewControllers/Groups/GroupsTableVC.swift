//
//  GroupsTableViewController.swift
//  VK
//
//  Created by Konstantin Zaytcev on 18.12.2021.
//

import UIKit

private let reuseIdentifier = "groupCell"

class GroupsTableVC: UITableViewController {

    var groups = [GroupModel]()
    var groupsFiltered = [GroupModel]()

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func addGroup(segue: UIStoryboardSegue)
    {
        guard
            segue.identifier == "addGroup",
            let searchGroups = segue.source as? GroupsSearchTableVC,
            let groupIndexPath = searchGroups.tableView.indexPathForSelectedRow,
            !self.groups.contains(where: {$0.id == searchGroups.groups[groupIndexPath.row].id})
        else {
            return
        }
        
        groups.append(searchGroups.groups[groupIndexPath.row])
        groupsFiltered = groups;
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(
            UINib(nibName: "GroupCell", bundle: nil),
            forCellReuseIdentifier: reuseIdentifier
        )
        
        self.tableView
            .addGestureRecognizer(
                UITapGestureRecognizer(
                    target: self,
                    action: #selector(hideKeyboard)
                )
            )
        
        groupsFiltered = groups
    }

    @objc func hideKeyboard() {
        self.searchBar?.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsFiltered.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? GroupCell
        else {
            return UITableViewCell()
        }

        let currentItem = groupsFiltered[indexPath.row]
        
        cell.configure(
            name: currentItem.name,
            image: currentItem.image
        )

        return cell
        
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            groups.remove(at: indexPath.row)
            groupsFiltered = groups;
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }   
    }
}

extension GroupsTableVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        groupsFiltered = searchText.isEmpty ? groups : groups.filter { (item: GroupModel) -> Bool in
            return item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
