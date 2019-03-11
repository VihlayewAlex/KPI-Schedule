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
    @IBOutlet weak var timelineContainerView: UIView!
    @IBOutlet weak var scheduleGlobalContainerLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var scheduleGlobalContainerRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var timelinePointerView: UIView!
    @IBOutlet weak var timelinePointerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var screenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    @IBOutlet var timelinePanGestureRecognizer: UIPanGestureRecognizer!
    
    private var schedulePageVC = SchedulePagerVC()
    
    private var isTimelineOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTimeline()
        configurePageVC()
        loadSchedule()
        setupNotificationObservers()
        
        updateTimelinePointer()
    }
    
    private func configureTimeline() {
        timelineContainerView.layer.cornerRadius = 6.0
        timelineContainerView.layer.maskedCorners = [CACornerMask.layerMaxXMinYCorner]
    }
    
    private func configurePageVC() {
        addChild(schedulePageVC)
        schedulePageVC.scrollingDelegate = self
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
                print("✅ Reloaded schedule")
                self?.segmentedControl.selectedSegmentIndex = currentWeek.index
                self?.schedulePageVC.currentScheduleWeek = currentWeek
                self?.schedulePageVC.scheduleOptions = ScheduleOptions(schedule: schedule, selectedScheduleWeek: currentWeek)
            }).catch({ (error) in
                print(error.localizedDescription)
            })
        }
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(forName: Notification.groupChanged.name, object: nil, queue: nil, using: { [weak self] (notification) in
            self?.loadSchedule()
        })
    }
    
    func updateTimelinePointer() {
        let now = Date()
        if let currentLessonIndex = now.lessonIndex, let currentLessonFraction = now.lessonFraction {
            let position = { () -> CGFloat in
                let numberOfCompletedLessons = CGFloat(currentLessonIndex)
                let numberOfGaps = CGFloat(currentLessonIndex)
                return (numberOfCompletedLessons * 106.0)
                     + (numberOfGaps * 12.0)
                     + (CGFloat(currentLessonFraction) * 106.0)
            }()
            let offset = schedulePageVC.selectedViewController?.tableView.contentOffset.y ?? 0.0
            let newPointerLocation: CGFloat = 32.0 + position - offset
            timelinePointerViewTopConstraint.constant = newPointerLocation
            view.layoutIfNeeded()
            timelinePointerView.isHidden = false
        } else {
            timelinePointerView.isHidden = true
        }
    }
    
    func updateTimelineTableScroll() {
        guard let timelineTableView = (children.first(where: { (viewController) -> Bool in
            return viewController is UITableViewController
        }) as? UITableViewController)?.tableView, let newOffset = schedulePageVC.selectedViewController?.tableView.contentOffset else {
            return
        }
        UIView.animate(withDuration: 0.1, animations: {
            timelineTableView.contentOffset = newOffset
        })
    }
    
    @IBAction func weekChanged() {
        schedulePageVC.scheduleOptions = schedulePageVC.scheduleOptions?.with(newSelectedScheduleWeek: ScheduleWeek(index: segmentedControl.selectedSegmentIndex)!)
    }
    
    @IBAction func handlePan() {
        guard !isTimelineOpen else {
            return
        }
        switch screenEdgePanGestureRecognizer.state {
        case .began, .changed:
            // Update coordinates
            scheduleGlobalContainerLeftConstraint.constant = 0 + screenEdgePanGestureRecognizer.location(in: view).x
            scheduleGlobalContainerRightConstraint.constant = 0 - screenEdgePanGestureRecognizer.location(in: view).x
            UIView.animate(withDuration: 0.1, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            })
        default:
            // Recover or proceed
            scheduleGlobalContainerLeftConstraint.constant = 0 + 60
            scheduleGlobalContainerRightConstraint.constant = 0 - 60
            isTimelineOpen = true
            screenEdgePanGestureRecognizer.isEnabled = false
            timelinePanGestureRecognizer.isEnabled = true
            UIView.animate(withDuration: 0.7, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func handleSwipeBack() {
        switch timelinePanGestureRecognizer.state {
        case .began, .changed:
            scheduleGlobalContainerLeftConstraint.constant = 0
            scheduleGlobalContainerRightConstraint.constant = 0
            isTimelineOpen = false
            timelinePanGestureRecognizer.isEnabled = false
            screenEdgePanGestureRecognizer.isEnabled = true
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            })
        default:
            break
        }
    }
    
}

extension ScheduleVC: ScheduleScrollingDelegate {
    
    func didScrollDay() {
        updateTimelinePointer()
        updateTimelineTableScroll()
    }
    
    func didScrollWeek() {
        let displayedDay = schedulePageVC.selectedViewController?.day.dayOfWeek
        let displayedWeek = schedulePageVC.scheduleOptions?.selectedScheduleWeek
        let noLessons = schedulePageVC.selectedViewController?.day.lessons.isEmpty ?? true
        UIView.animate(withDuration: 0.15) {
            self.timelinePointerView.layer.opacity = (
                (displayedDay != Date().dayOfWeek)
             || (displayedWeek != self.schedulePageVC.currentScheduleWeek)
             || (noLessons)
            ) ? 0.0 : 1.0
        }
    }
    
    func didSelect(lesson: Lesson) {
        performSegue(withIdentifier: "lessonSegue", sender: nil)
    }
    
}
