//
//  TeachersVC.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/8/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import UIKit

class TeachersVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
   
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private var teachers = [Teacher]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        loadTeachers()
        setupNotificationObservers()
    }
    
    private func loadTeachers() {
        if let groupId = UserPreferences.selectedGroup?.id {
            API.getTeachers(forGroupWithId: groupId).done({ [weak self] (teachers) in
                self?.teachers = teachers
            }).catch({ (error) in
                print(error.localizedDescription)
            })
        }
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(forName: Notification.groupChanged.name, object: nil, queue: nil, using: { [weak self] (notification) in
            self?.loadTeachers()
        })
    }
    
}

extension TeachersVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teachers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = teachers[indexPath.row].fullName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
