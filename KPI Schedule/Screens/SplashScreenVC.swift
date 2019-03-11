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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard UserPreferences.selectedGroup == nil else {
            route()
            return
        }
        
        API.getAllGroups(packedBy: 100, callbackQueue: DispatchQueue.main) { [weak self] (handler) in
            switch handler {
            case .failure(let error):
                print("🔥", error.localizedDescription)
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
        if UserPreferences.selectedGroup != nil {
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
