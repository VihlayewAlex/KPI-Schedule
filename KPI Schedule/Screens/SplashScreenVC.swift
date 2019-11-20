//
//  SplashScreenVC.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import UIKit

final class SplashScreenVC: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    
    var groups = [GroupInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: Notification.route.name, object: nil, queue: nil) { [weak self] (_) in
            self?.presentedViewController?.dismiss(animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard Preferences.selectedGroup == nil else {
            route()
            return
        }
        
        loadGroups()
    }
    
    func loadGroups() {
        API.getAllGroups(packedBy: 100, callbackQueue: DispatchQueue.main) { [weak self] (handler) in
            switch handler {
            case .failure(let error):
                let alert = UIAlertController(title: "Error".localized, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retry".localized, style: .default, handler: { (_) in
                    self?.loadGroups()
                }))
                self?.present(alert, animated: true, completion: nil)
            case .success(let packet):
                self?.progressView.setProgress(Float(packet.currentOffset) / Float(packet.totalCount), animated: true)
                self?.groups += packet.nextPacket
                if packet.isLast {
                    print("🚀 Loaded groups. Proceeding to application")
                    self?.route()
                }
            }
        }
    }
    
    func route() {
        if Preferences.selectedGroup != nil {
            performSegue(withIdentifier: "schedule", sender: nil)
        } else {
            performSegue(withIdentifier: "chooseGroup", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseGroup" {
            (segue.destination as? ChooseGroupVC)?.groups = groups
            (segue.destination as? ChooseGroupVC)?.strategy = ChooseGroupStrategySet.initiallySetGroup
        }
    }

}
