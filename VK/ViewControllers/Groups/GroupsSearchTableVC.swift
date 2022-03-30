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
        
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(
            UINib(nibName: "GroupCell", bundle: nil),
            forCellReuseIdentifier: reuseIdentifier
        )
        
        self.setData()
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
