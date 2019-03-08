//
//  ChooseGroupVC.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import UIKit

final class ChooseGroupVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var groups = [GroupInfo]() {
        didSet {
            filteredGroups = groups
        }
    }
    private var filteredGroups = [GroupInfo]()
    private var selectedGroup: GroupInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func done() {
        if let selectedGroup = selectedGroup {
            UserPreferences.selectedGroup = selectedGroup
            dismiss(animated: true, completion: nil)
        }
    }
    
}

extension ChooseGroupVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let strongSelf = self else { return }
            guard !searchText.isEmpty else {
                DispatchQueue.main.async {
                    strongSelf.filteredGroups = strongSelf.groups
                    strongSelf.tableView.reloadData()
                }
                return
            }
            let filteredGroups = strongSelf.groups.filter({ (group) -> Bool in
                return group.name.lowercased().contains(searchText.lowercased())
            })
            DispatchQueue.main.async {
                strongSelf.filteredGroups = filteredGroups
                strongSelf.tableView.reloadData()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

extension ChooseGroupVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let group = filteredGroups[indexPath.row]
        cell.textLabel?.text = group.name
        cell.accessoryType = (group == selectedGroup ? .checkmark : .none)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let selectedGroup = selectedGroup, let previousSelectedRowIndex = filteredGroups.firstIndex(of: selectedGroup) {
            self.selectedGroup = nil
            tableView.reloadRows(at: [IndexPath(row: previousSelectedRowIndex, section: 0)], with: .automatic)
        }
        selectedGroup = filteredGroups[indexPath.row]
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}
