//
//  SettingsVC.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/11/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import UIKit

class SettingsVC: UITableViewController {

    @IBOutlet weak var groupLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        groupLabel.text = UserPreferences.selectedGroup?.name ?? "Undefined"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                chooseGroup()
            default:
                break
            }
        default:
            break
        }
    }
    
    private func chooseGroup() {
        var groups = [GroupInfo]()
        API.getAllGroups(packedBy: 100, callbackQueue: DispatchQueue.main) { [weak self] (handler) in
            switch handler {
            case .failure(let error):
                print("🔥", error.localizedDescription)
            case .success(let packet):
                //                        self?.progressView.setProgress(Float(packet.currentOffset) / Float(packet.totalCount), animated: true)
                groups += packet.nextPacket
                if packet.isLast {
                    if let chooseGroupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chooseGroupVC") as? ChooseGroupVC {
                        chooseGroupVC.groups = groups
                        chooseGroupVC.strategy = ChooseGroupStrategySet.changeGroup(withCompletion: {
                            self?.groupLabel.text = UserPreferences.selectedGroup?.name ?? "Undefined"
                        })
                        self?.present(chooseGroupVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }

}
