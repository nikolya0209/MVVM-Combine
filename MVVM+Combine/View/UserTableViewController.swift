//
//  ViewController.swift
//  MVVM+Combine
//
//  Created by MacBookPro on 01.02.2022.
//
import Combine
import UIKit

class UserTableViewController: UITableViewController {

    var users: [User] = []
    
    var viewModel: UsersViewModel!
    private let apiManager = ApiManager()
    private var subscriber: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        fetchUsers()
        observeViewModel()
    }
    
    private func setupViewModel() {
        viewModel = UsersViewModel(apiManager: apiManager, endPoint: .userFetch)
    }
    
    private func fetchUsers() {
        viewModel.fetchUser()
    }
    
    private func observeViewModel() {
        subscriber = viewModel.userSubject.sink { (resultCompletion) in
            switch resultCompletion {
            case .failure(let error):
                print(error.localizedDescription)
            default: break
            }
        } receiveValue: { (users) in
            DispatchQueue.main.async {
                self.users = users
                self.tableView.reloadData()
            }
        }
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.item]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        return cell
    }
}




