//
//  FriendsTableViewController.swift
//  VK
//
//  Created by Konstantin Zaytcev on 18.12.2021.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "userCell"

class FriendsTableVC: UITableViewController {
    
    struct Section {
        var title: String
        var users: [RealmFriendModel]
    }
    
    var sections = [Section]()
    
    private var friends: Results<RealmFriendModel>?
    private var friendsToken: NotificationToken?
    
    private let networkService = NetworkService()
    
    public var userId: Int = SomeSingleton.instance.userId
    
    @IBOutlet weak var searchBar: UISearchBar!
        
    
    // MARK: - Table view settings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(
            UINib(nibName: "UserCell", bundle: nil),
            forCellReuseIdentifier: reuseIdentifier
        )
        
        // Загрузка данных из сети в Realm
        loadDataFromNetwork(userId: userId)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Отслеживание изменений данных в Realm
        observeData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        friendsToken?.invalidate()
    }
    
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
        let firstLetters = self.firstLetters()
        return firstLetters.count >= 5 ? firstLetters : []
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
            photo100: currentItem.photo100
        )

        return cell
    }
    
    override func prepare( for segue: UIStoryboardSegue, sender: Any? ) {
        
        guard
            segue.identifier == "showPhoto",
            let destination = segue.destination as? FriendsCollectionVC,
            let indexPath = tableView.indexPathForSelectedRow
        else {
            return
        }
        
        destination.userId = sections[indexPath.section].users[indexPath.row].id
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        performSegue(withIdentifier: "showPhoto", sender: nil)
    }
    
    
    // MARK: - Массив первых букв фамилий
    private func firstLetters() -> [String] {
        
        var result = [String]()
        
        if (friends == nil) {
            return result
        }
        
        let usersFiltered = friends!.sorted {
            item1, item2 in item1.lastName.lowercased() < item2.lastName.lowercased()
        }
        
        for user in usersFiltered {
            
            let char = String(user.lastName.prefix(1))
            
            if (!char.isEmpty && !result.contains(char)) {
                result.append(char)
            }
        }
        
        return result
    }
    
    
    // MARK: - Загрузка данных из Realm по идентификатору пользователя
    
    private func loadDataFromRealm(userId: Int, search: String = "")
    {
        let search = search.trimmingCharacters(in: [" "])
        
        if (search.isEmpty) {
            friends = try? RealmService.load(typeOf: RealmFriendModel.self)
                .where({
                    $0.userId == userId
                })
                .sorted(byKeyPath: "lastName", ascending: true)
        } else {
            friends = try? RealmService.load(typeOf: RealmFriendModel.self)
                .where({
                    $0.userId == userId
                })
                .where({
                    $0.firstName.contains(search, options: .caseInsensitive) ||
                    $0.lastName.contains(search, options: .caseInsensitive)
                })
                .sorted(byKeyPath: "lastName", ascending: true)
        }
        
        sections = []
        
        let sectionsNames = self.firstLetters()
        
        for sectionName in sectionsNames {
            
            var section = Section(title: sectionName, users: [])
            
            for user in friends! {
                
                if (user.lastName.starts(with: sectionName)) {
                    section.users.append(user)
                }
            }
            
            sections.append(section)
        }
        
        tableView.reloadData()
    }
    
    
    // MARK: - Загрузка данных из сети в Realm по идентификатору пользователя
    
    private func loadDataFromNetwork(userId: Int)
    {
        networkService.methodFriendsGet(userId: userId) { [weak self] result in
            switch result {
            case .success(let users):
                
                let realmUsers = users.map {
                    RealmFriendModel(userId: self!.userId, user: $0)
                }
                
                // Удаление старых значений из realm
                let oldFriends = try? RealmService.load(typeOf: RealmFriendModel.self)
                    .where({
                        $0.userId == userId
                    })
                
                if (!(oldFriends?.isEmpty ?? true)) {
                    try? RealmService.delete(object: oldFriends!)
                }
                
                // Сохранение данных в realm
                try? RealmService.save(items: realmUsers)
                
                // Загрузка данных из Realm
                self?.loadDataFromRealm(userId: userId);
                
                // Отслеживание изменений данных в Realm
                self?.observeData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    // MARK: - Отслеживание изменений данных в Realm
    private func observeData()
    {
        friendsToken = friends?.observe{ [weak self] friendsChanges in
            
            switch friendsChanges {
                
            case .initial(_):
                self?.tableView.reloadData()
            
            case let .update(_, deletions: deletions, insertions: insertions, modifications: modifications):
                
                self?.tableView.reloadData()
                
            case .error(let error):
                print(error)
            }
        }
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

extension FriendsTableVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Загрузка данных из Realm
        loadDataFromRealm(userId: userId, search: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
