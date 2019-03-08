//
//  SchedulePagerVC.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import UIKit
import Pageboy

struct ScheduleOptions {
    var schedule: Schedule
    var selectedScheduleWeek: ScheduleWeek
    
    init(schedule: Schedule, selectedScheduleWeek: ScheduleWeek) {
        self.schedule = schedule
        self.selectedScheduleWeek = selectedScheduleWeek
    }
    
    func with(newSchedule: Schedule) -> ScheduleOptions {
        return ScheduleOptions(schedule: newSchedule, selectedScheduleWeek: self.selectedScheduleWeek)
    }
    
    func with(newSelectedScheduleWeek: ScheduleWeek) -> ScheduleOptions {
        return ScheduleOptions(schedule: self.schedule, selectedScheduleWeek: newSelectedScheduleWeek)
    }
}

final class SchedulePagerVC: PageboyViewController {

    private var viewControllers = [UIViewController]()
    private var selectedPageIndex: Int?
    
    var currentScheduleWeek: ScheduleWeek = .first
    
    var scheduleOptions: ScheduleOptions? {
        didSet {
            displaySchedule()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
    }
    
    private func displaySchedule() {
        guard let scheduleOptions = scheduleOptions else { return }
        let week = scheduleOptions.schedule.weeks[scheduleOptions.selectedScheduleWeek.index]
        self.viewControllers = []
        for day in week.days {
            let dayVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scheduleDayVC") as! ScheduleDayVC
            dayVC.day = day
            dayVC.week = scheduleOptions.selectedScheduleWeek
            dayVC.currentWeek = currentScheduleWeek
            self.viewControllers.append(dayVC)
            self.reloadData()
        }
    }
    
}

extension SchedulePagerVC: PageboyViewControllerDelegate {
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, willScrollToPageAt index: PageboyViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) { }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollTo position: CGPoint, direction: PageboyViewController.NavigationDirection, animated: Bool) { }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: PageboyViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        self.selectedPageIndex = index
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didReloadWith currentViewController: UIViewController, currentPageIndex: PageboyViewController.PageIndex) { }
    
}

extension SchedulePagerVC: PageboyViewControllerDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return PageboyViewController.Page.at(index: selectedPageIndex ?? Date().dayOfWeek.index)
    }
    
}
