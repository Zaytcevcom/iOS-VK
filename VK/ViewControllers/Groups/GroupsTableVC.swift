//
//  GroupsTableViewController.swift
//  VK
//
//  Created by Konstantin Zaytcev on 18.12.2021.
//

import UIKit
import RealmSwift
import FirebaseDatabase

private let reuseIdentifier = "groupCell"

class GroupsTableVC: UITableViewController {

    private var groups: Results<RealmGroupModel>?
    private var groupsToken: NotificationToken?
    
    private let networkService = NetworkService()
    private let reference = Database.database().reference()
    
    public var userId: Int = SomeSingleton.instance.userId
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func addGroup(segue: UIStoryboardSegue)
    {
        guard
            segue.identifier == "addGroup",
            let searchGroups = segue.source as? GroupsSearchTableVC,
            let groupIndexPath = searchGroups.tableView.indexPathForSelectedRow
        else {
            return
        }
        
        let groupInfo = searchGroups.groups[groupIndexPath.row]
        
        let addGroup = RealmGroupModel()
        addGroup.id = groupInfo.id
        addGroup.userId = userId
        addGroup.name = groupInfo.name
        addGroup.photo50 = groupInfo.photo50 ?? ""
        addGroup.photo100 = groupInfo.photo100
        addGroup.photo200 = groupInfo.photo200 ?? ""
        
        try? RealmService.save(items: [addGroup])
        
        // Отправка данных о добавлении сообщетсва пользователем в Firebase
        sendStatsToFirebase(groupId: groupInfo.id)
    }
    
    
    // MARK: - Table view settings
    
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
        
        // Загрузка данных из сети в Realm
        loadDataFromNetwork(userId: userId)
    }
    
    @objc func hideKeyboard() {
        self.searchBar?.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Отслеживание изменений данных в Realm
        observeData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        groupsToken?.invalidate()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? GroupCell
        else {
            return UITableViewCell()
        }

        let currentItem = groups![indexPath.row]
        
        cell.configure(name: currentItem.name, photo100: currentItem.photo100)

        return cell
        
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if
            editingStyle == .delete,
            let realm = try? Realm(),
            let realmGroup = groups?[indexPath.row]
        {
            try? realm.write({
                realm.delete(realmGroup)
            })
        }
    }
    
    
    // MARK: - Загрузка данных из Realm по идентификатору пользователя
    
    private func loadDataFromRealm(userId: Int, search: String = "")
    {
        let search = search.trimmingCharacters(in: [" "])
        
        if (search.isEmpty) {
            groups = try? RealmService.load(typeOf: RealmGroupModel.self)
                .where({
                    $0.userId == userId
                })
        } else {
            groups = try? RealmService.load(typeOf: RealmGroupModel.self)
                .where({
                    $0.userId == userId
                })
                .where({
                        $0.name.contains(search, options: .caseInsensitive)
                    })
        }
        
        tableView.reloadData()
    }
    
    
    // MARK: - Загрузка данных из сети в Realm по идентификатору пользователя
    
    private func loadDataFromNetwork(userId: Int)
    {
        networkService.methodGroupsGet(userId: userId) { [weak self] result in
            switch result {
            case .success(let groups):

                let realmGroups = groups.map {
                    RealmGroupModel(userId: userId, group: $0)
                }

                // Удаление старых значений из realm
                let oldGroups = try? RealmService.load(typeOf: RealmGroupModel.self)
                    .where({
                        $0.userId == userId
                    })

                if (!(oldGroups?.isEmpty ?? true)) {
                    try? RealmService.delete(object: oldGroups!)
                }

                // Сохранение данных в realm
                try? RealmService.save(items: realmGroups)

                // Загрузка данных из Realm
                self?.loadDataFromRealm(userId: userId)
                
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
        groupsToken = groups?.observe{ [weak self] groupsChanges in
            
            switch groupsChanges {
                
            case .initial(_):
                self?.tableView.reloadData()
            
            case let .update(_, deletions: deletions, insertions: insertions, modifications: modifications):
                
                let deleteRowsIndexes = deletions.map({ IndexPath(row: $0, section: 0) })
                let insertRowsIndexes = insertions.map({ IndexPath(row: $0, section: 0) })
                let modificationRowsIndexes = modifications.map({ IndexPath(row: $0, section: 0) })

                self?.tableView.beginUpdates()
                self?.tableView.deleteRows(at: deleteRowsIndexes, with: .automatic)
                self?.tableView.insertRows(at: insertRowsIndexes, with: .automatic)
                self?.tableView.reloadRows(at: modificationRowsIndexes, with: .automatic)
                self?.tableView.endUpdates()
                
            case .error(let error):
                print(error)
            }
        }
    }
    
    
    // MARK: - Отправка данных о добавлении сообщетсва пользователем в Firebase
    private func sendStatsToFirebase(groupId: Int)
    {
        let fbUser = FirebaseGroupsStatsModel(groupId: groupId, time: Int(NSDate().timeIntervalSince1970))
        
        reference
            .child("groups")
            .child(String(userId))
            .child(String(groupId))
            .setValue(fbUser.toAnyObject())
    }
}

extension GroupsTableVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Загрузка данных из Realm
        loadDataFromRealm(userId: userId, search: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
