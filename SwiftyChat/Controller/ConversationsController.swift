//
//  ConversationController.swift
//  SwiftyChat
//
//  Created by John McCants on 12/20/21.
//

import Foundation
import UIKit
import Firebase

private let reuseIdentifier = "ConversationCell"
class ConversationsController: UIViewController {
    
    // MARK: -Properties
    
    private let tableView = UITableView()
    
    
    // MARK: -Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        authenticateUser()
            }
    
    // MARK: -Helpers
    
    func configureTableView() {
        tableView.backgroundColor = .white
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        tableView.frame = view.frame
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))
        
        configureNavigationBar()
        configureTableView()

        
    }
    
    @objc func showProfile() {
        print("123")
        logout()
    }
    
    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .systemPurple
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        appearance.backgroundColor = .systemPurple
        navigationItem.title = "Messages"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
      
    }
    
    func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            print("DEBUG: User is not logged in. Present login screen here.")
            presentLoginScreen()
        } else {
            print("DEBUG: User is logged in. Configure controller...")
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            presentLoginScreen()
        } catch  {
            print("DEBUG: Error signing out...")
        }
    }
    
    func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
}

extension ConversationsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = "Test Cell"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    
}
