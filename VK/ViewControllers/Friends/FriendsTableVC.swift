//
//  FriendsTableViewController.swift
//  VK
//
//  Created by Konstantin Zaytcev on 18.12.2021.
//

import UIKit

private let reuseIdentifier = "userCell"

class FriendsTableVC: UITableViewController {
    
    struct Section {
        var title: String
        var users: [UserModel]
    }
    
    var users = [UserModel]()
    var sections = [Section]()

    public func setPhotos(id: Int) -> [PhotoModel]
    {
        var arr = [PhotoModel]()
        
        for i in (1...50) {
            
            let num = Int.random(in: 1...5)
            
            arr.append(
                PhotoModel(
                    id: i,
                    image: UIImage(named: "monkey0\(num).png") ?? UIImage(),
                    description: nil,
                    countLikes: Int.random(in: 50..<250),
                    isLiked: Int.random(in: 0...3) == 1
                )
            )
        }
        
        return arr
    }
    
    public func setData()
    {
        users.append(UserModel(
            id: 1,
            firstName: "Константин",
            lastName: "Зайцев",
            image: UIImage(named: "monkey01.png"),
            photos: setPhotos(id: 1)
        ))
        
        users.append(UserModel(
            id: 2,
            firstName: "Антон",
            lastName: "Зиновьев",
            image: UIImage(named: "monkey02.png"),
            photos: setPhotos(id: 2)
        ))
        
        users.append(UserModel(
            id: 3,
            firstName: "Павел",
            lastName: "Николаев",
            image: UIImage(named: "monkey03.png"),
            photos: setPhotos(id: 3)
        ))
        
        users.append(UserModel(
            id: 4,
            firstName: "Никита",
            lastName: "Чиров",
            image: UIImage(named: "monkey04.png"),
            photos: setPhotos(id: 4)
        ))
        
        users.append(UserModel(
            id: 5,
            firstName: "Николай",
            lastName: "Кузнецов",
            image: UIImage(named: "monkey05.png"),
            photos: setPhotos(id: 5)
        ))
        
        users.append(UserModel(
            id: 6,
            firstName: "Дарья",
            lastName: "Гридина",
            image: UIImage(named: "monkey01.png"),
            photos: setPhotos(id: 1)
        ))
        
        users.append(UserModel(
            id: 7,
            firstName: "Милан",
            lastName: "Родд",
            image: UIImage(named: "monkey02.png"),
            photos: setPhotos(id: 2)
        ))
        
        users.append(UserModel(
            id: 8,
            firstName: "Сергей",
            lastName: "Давыдов",
            image: UIImage(named: "monkey03.png"),
            photos: setPhotos(id: 3)
        ))
        
        users.append(UserModel(
            id: 9,
            firstName: "Алина",
            lastName: "Чирова",
            image: UIImage(named: "monkey04.png"),
            photos: setPhotos(id: 4)
        ))
        
        tableView.reloadData()
    }
    
    public func setSections()
    {
        let usersFiltered = users.sorted {
            item1, item2 in item1.lastName.lowercased() < item2.lastName.lowercased()
        }
        
        let sectionsNames = self.firstLetters()
        
        for sectionName in sectionsNames {
            
            var section = Section(title: sectionName, users: [])
            
            for user in usersFiltered {
                if (user.lastName.starts(with: sectionName)) {
                    section.users.append(user)
                }
            }
            
            sections.append(section)
        }
    }
    
    public func firstLetters() -> [String] {
        
        var result = [String]()
        
        let usersFiltered = users.sorted {
            item1, item2 in item1.lastName.lowercased() < item2.lastName.lowercased()
        }
        
        for user in usersFiltered {
            
            let char = String(user.lastName.prefix(1))
            
            if !result.contains(char) {
                result.append(char)
            }
        }
        
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(
            UINib(nibName: "UserCell", bundle: nil),
            forCellReuseIdentifier: reuseIdentifier
        )
        
        setData()
        
        setSections()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].users.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        self.firstLetters()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? UserCell
        else {
            return UITableViewCell()
        }

        let currentItem = sections[indexPath.section].users[indexPath.row]
        
        cell.configure(
            firstName: currentItem.firstName,
            lastName: currentItem.lastName,
            image: currentItem.image
        )

        return cell
    }
    
    override func prepare( for segue: UIStoryboardSegue, sender: Any? ) {
        
        guard
            segue.identifier == "showPhoto",
            let indexPath = tableView.indexPathForSelectedRow
        else {
            return
        }
        
        guard
            let destination = segue.destination as? FriendsCollectionVC
        else {
            return
        }
        
        destination.userModel = sections[indexPath.section].users[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        performSegue(withIdentifier: "showPhoto", sender: nil)
    }
}

extension FriendsTableVC: UIGestureRecognizerDelegate
{
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }
}
