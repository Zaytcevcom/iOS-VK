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
    var groupsFiltered = [GroupModel]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    public func setData()
    {
        groups.append(GroupModel(
            id: 1,
            name: "MDK",
            image: UIImage(named: "monkey01.png")
        ))
        
        groups.append(GroupModel(
            id: 2,
            name: "Лентач",
            image: UIImage(named: "monkey02.png")
        ))
        
        groups.append(GroupModel(
            id: 3,
            name: "iFeed",
            image: UIImage(named: "monkey03.png")
        ))
        
        groups.append(GroupModel(
            id: 4,
            name: "SMMщики",
            image: UIImage(named: "monkey04.png")
        ))
        
        groupsFiltered = groups;
        
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(
            UINib(nibName: "GroupCell", bundle: nil),
            forCellReuseIdentifier: reuseIdentifier
        )
        
        self.setData()
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        performSegue(withIdentifier: "addGroup", sender: nil)
    }

}

extension GroupsSearchTableVC: UISearchBarDelegate {
    
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
