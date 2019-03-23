//
//  SettingsVC.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/11/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var progressView: UIVisualEffectView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
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
    
    private func chooseGroup() {
        showProgressView()
        var groups = [GroupInfo]()
        API.getAllGroups(packedBy: 100, callbackQueue: DispatchQueue.main) { [weak self] (handler) in
            switch handler {
            case .failure(let error):
                print("🔥", error.localizedDescription)
                self?.hideProgressView()
            case .success(let packet):
                groups += packet.nextPacket
                if packet.isLast {
                    self?.hideProgressView()
                    if let chooseGroupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chooseGroupVC") as? ChooseGroupVC {
                        chooseGroupVC.groups = groups
                        chooseGroupVC.strategy = ChooseGroupStrategySet.changeGroup(withCompletion: {
                            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                        })
                        self?.present(chooseGroupVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    private func addFavouriteGroup() {
        showProgressView()
        var groups = [GroupInfo]()
        API.getAllGroups(packedBy: 100, callbackQueue: DispatchQueue.main) { [weak self] (handler) in
            switch handler {
            case .failure(let error):
                print("🔥", error.localizedDescription)
                self?.hideProgressView()
            case .success(let packet):
                groups += packet.nextPacket
                if packet.isLast {
                    self?.hideProgressView()
                    if let chooseGroupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chooseGroupVC") as? ChooseGroupVC {
                        chooseGroupVC.groups = groups
                        chooseGroupVC.strategy = ChooseGroupStrategySet.addGroupToFavourites(withCompletion: {
                            self?.tableView.reloadSections(IndexSet(arrayLiteral: 1), with: .automatic)
                        })
                        self?.present(chooseGroupVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }

}

extension SettingsVC: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return Preferences.favouriteGroups.count + 1
        default:
            preconditionFailure("Unhandled section")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "myGroupCell", for: indexPath)
            cell.textLabel?.text = Preferences.selectedGroup?.name
            return cell
        case 1:
            if indexPath.row < Preferences.favouriteGroups.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteGroupCell", for: indexPath)
                cell.textLabel?.text = Preferences.favouriteGroups[indexPath.row].name
                return cell
            } else {
                return tableView.dequeueReusableCell(withIdentifier: "addFavouriteCell", for: indexPath)
            }
        default:
            preconditionFailure("Unhandled section")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (section == 0) ? 0.0 : 44.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return { () -> UIView in
            let containerView = UIView()
            let label = UILabel()
            label.text = (section == 0) ? "My group".localized : "Favourite groups".localized
            label.font = UIFont.systemFont(ofSize: 20.0, weight: .heavy)
            label.textColor = UIColor.lightGray
            label.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(label)
            containerView.leftAnchor.constraint(equalTo: label.leftAnchor, constant: -16.0).isActive = true
            containerView.topAnchor.constraint(equalTo: label.topAnchor).isActive = true
            containerView.bottomAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
            containerView.rightAnchor.constraint(equalTo: label.rightAnchor).isActive = true
            return containerView
        }()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        case 1:
            return { () -> UIView in
                let containerView = UIView()
                let label = UILabel()
                label.text = "A list of groups for fast access and cached schedule data".localized
                label.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
                label.numberOfLines = 2
                label.textColor = UIColor.lightGray
                label.translatesAutoresizingMaskIntoConstraints = false
                containerView.addSubview(label)
                containerView.leftAnchor.constraint(equalTo: label.leftAnchor, constant: -16.0).isActive = true
                containerView.topAnchor.constraint(equalTo: label.topAnchor).isActive = true
                containerView.bottomAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
                containerView.rightAnchor.constraint(equalTo: label.rightAnchor, constant: 16.0).isActive = true
                return containerView
            }()
        default:
            preconditionFailure("Unhandled section")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            chooseGroup()
        case 1:
            if indexPath.row == Preferences.favouriteGroups.count {
                addFavouriteGroup()
            }
        default:
            preconditionFailure("Unhandled section")
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        guard indexPath.section == 1 && indexPath.row != Preferences.favouriteGroups.count else {
            return .none
        }
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let groupToDelete = Preferences.favouriteGroups[indexPath.row]
        Preferences.favouriteGroups = Preferences.favouriteGroups.filter({ $0 != groupToDelete })
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

}

