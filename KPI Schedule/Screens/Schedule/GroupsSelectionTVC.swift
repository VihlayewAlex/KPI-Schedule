//
//  GroupsSelectionTVC.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/21/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import UIKit

protocol GroupsSelectionTVCDelegate: class {
    
    func didSelect(group: GroupInfo)
    
}

class GroupsSelectionTVC: UITableViewController {

    var groups = [GroupInfo]()
    var currentlySelectedGroup: GroupInfo?

    weak var delegate: GroupsSelectionTVCDelegate?
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let group = groups[indexPath.row]
        cell.textLabel?.text = group.name
        cell.textLabel?.textColor = (currentlySelectedGroup == group) ? UIColor.accent : UIColor.black
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelect(group: groups[indexPath.row])
        dismiss(animated: true, completion: nil)
    }

}
