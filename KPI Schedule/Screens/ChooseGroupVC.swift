//
//  ChooseGroupVC.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import UIKit

struct ChooseGroupStrategySet {
    
    static let null: ChooseGroupeStrategy = { (_,_) in return }
    
    static let initiallySetGroup: ChooseGroupeStrategy = { (group, viewController) in
        Preferences.selectedGroup = group
        viewController.dismiss(animated: true, completion: nil)
    }
    
    static func changeGroup(withCompletion completion: (() -> Void)?) -> ChooseGroupeStrategy {
        return { (group, viewController) in
            Preferences.selectedGroup = group
            Preferences.cachedGroupTimetable = nil
            NotificationCenter.default.post(Notification.groupChanged)
            viewController.dismiss(animated: true, completion: nil)
            completion?()
        }
    }
    
    static func addGroupToFavourites(withCompletion completion: (() -> Void)?) -> ChooseGroupeStrategy {
        return { (group, viewController) in
            Preferences.favouriteGroups += [group]
            viewController.dismiss(animated: true, completion: nil)
            completion?()
        }
    }
    
}

typealias ChooseGroupeStrategy = ((GroupInfo, UIViewController) -> Void)?

final class ChooseGroupVC: UIViewController {

    @IBOutlet var progressView: UIVisualEffectView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var strategy: ChooseGroupeStrategy = ChooseGroupStrategySet.null
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

    private func showProgressView() {
        progressView.isHidden = true
        view.addSubview(progressView)
        view.bringSubviewToFront(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        UIView.animate(withDuration: 0.3) {
            self.progressView.isHidden = false
        }
    }
    
    private func hideProgressView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.progressView.isHidden = true
        }, completion: { (_) in
            self.progressView.removeFromSuperview()
        })
    }
    
    @IBAction func done() {
        if let selectedGroup = selectedGroup {
            showProgressView()
            _ = API.validateSchedule(forGroupWithId: selectedGroup.id).done { [weak self] (isValid) in
                self?.hideProgressView()
                if let strongSelf = self, isValid {
                    self?.strategy?(selectedGroup, strongSelf)
                } else {
                    let alert = UIAlertController(title: "No schedule available".localized, message: "Sorry, there is no schedule available for this group now".localized, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Choose other".localized, style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
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
