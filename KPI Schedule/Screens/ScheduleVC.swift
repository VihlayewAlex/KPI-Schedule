//
//  ScheduleVC.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import UIKit
import Pageboy
import PromiseKit

final class ScheduleVC: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var scheduleContainerView: UIView!
    @IBOutlet var screenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    
    var schedulePageVC = SchedulePagerVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePageVC()
        loadSchedule()
    }
    
    private func configurePageVC() {
        addChild(schedulePageVC)
        schedulePageVC.view.translatesAutoresizingMaskIntoConstraints = false
        scheduleContainerView.addSubview(schedulePageVC.view)
        scheduleContainerView.topAnchor.constraint(equalTo: schedulePageVC.view.topAnchor).isActive = true
        scheduleContainerView.leftAnchor.constraint(equalTo: schedulePageVC.view.leftAnchor).isActive = true
        scheduleContainerView.rightAnchor.constraint(equalTo: schedulePageVC.view.rightAnchor).isActive = true
        scheduleContainerView.bottomAnchor.constraint(equalTo: schedulePageVC.view.bottomAnchor).isActive = true
        schedulePageVC.didMove(toParent: self)
    }
    
    private func loadSchedule() {
        if let groupId = UserPreferences.selectedGroup?.id {
            when(fulfilled: API.getSchedule(forGroupWithId: groupId), API.getCurrentWeekNumber()).done({ [weak self] (schedule, currentWeek) in
                self?.segmentedControl.selectedSegmentIndex = currentWeek.index
                self?.schedulePageVC.currentScheduleWeek = currentWeek
                self?.schedulePageVC.scheduleOptions = ScheduleOptions(schedule: schedule, selectedScheduleWeek: currentWeek)
            }).catch({ (error) in
                print(error.localizedDescription)
            })
        }
    }
    
    @IBAction func weekChanged() {
        schedulePageVC.scheduleOptions = schedulePageVC.scheduleOptions?.with(newSelectedScheduleWeek: ScheduleWeek(index: segmentedControl.selectedSegmentIndex)!)
    }
    
    @IBAction func handlePan() {
        print("Pan")
    }
    
}
