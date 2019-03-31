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

    @IBOutlet weak var groupDropdownButton: UIButton!
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
    private var selectedLesson: Lesson?
    private var selectedDate: String?
    private var isTimelineOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLabels()
        configureTimeline()
        configurePageVC()
        loadSchedule()
        setupNotificationObservers()
        
        updateTimelinePointer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !Preferences.isScheduleTutorialShown {
            showTutorial()
            Preferences.isScheduleTutorialShown = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateTimelinePointer()
    }
    
    private func configureLabels() {
        segmentedControl.setTitle("Week".localized + " 1", forSegmentAt: 0)
        segmentedControl.setTitle("Week".localized + " 2", forSegmentAt: 1)
    }
    
    private func showTutorial() {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            let scheduleTutorialVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scheduleTutorialVC")
            topController.present(scheduleTutorialVC, animated: true, completion: nil)
        }
    }
    
    private func configureTimeline() {
        let radius: CGFloat = 6.0
        let corners = CACornerMask.layerMaxXMinYCorner
        timelineContainerView.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            timelineContainerView.layer.maskedCorners = [corners]
        } else {
            var cornerMask = UIRectCorner()
            if(corners.contains(.layerMinXMinYCorner)){
                cornerMask.insert(.topLeft)
            }
            if(corners.contains(.layerMaxXMinYCorner)){
                cornerMask.insert(.topRight)
            }
            if(corners.contains(.layerMinXMaxYCorner)){
                cornerMask.insert(.bottomLeft)
            }
            if(corners.contains(.layerMaxXMaxYCorner)){
                cornerMask.insert(.bottomRight)
            }
            let path = UIBezierPath(roundedRect: timelineContainerView.bounds, byRoundingCorners: cornerMask, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            timelineContainerView.layer.mask = mask
        }
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
    
    private func loadSchedule(for group: GroupInfo? = nil) {
        if let group = (group ?? Preferences.selectedGroup) {
            when(fulfilled: API.getSchedule(forGroupWithId: group.id, allowCached: true), API.getCurrentWeekNumber()).done({ [weak self] (schedule, currentWeek) in
                print("✅ Reloaded schedule for " + group.name)
                self?.segmentedControl.selectedSegmentIndex = currentWeek.index
                self?.segmentedControl.setTitle("Week".localized + " 1" + ((currentWeek.index == 0) ? " (Current)".localized : ""), forSegmentAt: 0)
                self?.segmentedControl.setTitle("Week".localized + " 2" + ((currentWeek.index == 1) ? " (Current)".localized : ""), forSegmentAt: 1)
                self?.segmentedControl.sizeToFit()
                self?.schedulePageVC.currentScheduleWeek = currentWeek
                self?.schedulePageVC.scheduleOptions = ScheduleOptions(group: group, schedule: schedule, selectedScheduleWeek: currentWeek)
                self?.groupDropdownButton.setAttributedTitle({ () -> NSAttributedString in
                    let attrStr = NSMutableAttributedString(string: group.name)
                    attrStr.append(NSAttributedString(string: " ▼", attributes: [.font: UIFont.systemFont(ofSize: 14.0)]))
                    return attrStr
                }(), for: .normal)
            }).catch({ [weak self] (error) in
                let alert = UIAlertController(title: "Error".localized, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok".localized, style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Retry".localized, style: .cancel, handler: { (_) in
                    self?.loadSchedule(for: group)
                }))
                self?.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(forName: Notification.groupChanged.name, object: nil, queue: nil, using: { [weak self] (notification) in
            self?.loadSchedule()
        })
        NotificationCenter.default.addObserver(forName: Notification.scheduleTabTapped.name, object: nil, queue: nil, using: { [weak self] (notification) in
            guard let group = self?.schedulePageVC.scheduleOptions?.group else { return }
            // self?.schedulePageVC.scrollToPage(PageboyViewController.Page.at(index: targetIndex), animated: true)
            self?.schedulePageVC.selectedPageIndex = Date().dayOfWeek.index
            self?.loadSchedule(for: group)
        })
    }
    
    func updateTimelinePointer() {
        let now = Date()
        if let currentLessonIndex = now.lessonIndex,
            let currentLessonFraction = now.lessonFraction {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lessonSegue" {
            let lessonVC = segue.destination as! LessonVC
            lessonVC.lesson = selectedLesson
            lessonVC.dateString = selectedDate
            selectedLesson = nil
        } else if segue.identifier == "groupSelectionSegue" {
            let groupsVC = segue.destination as! GroupsSelectionTVC
            groupsVC.groups = [Preferences.selectedGroup!] + Preferences.favouriteGroups
            groupsVC.currentlySelectedGroup = schedulePageVC.scheduleOptions?.group
            groupsVC.delegate = self
            groupsVC.modalPresentationStyle = .popover
            groupsVC.popoverPresentationController?.delegate = self
            groupsVC.preferredContentSize = CGSize(width: 200.0, height: 44.0 * Double(groupsVC.groups.count))
        }
    }
    
    @IBAction func switchGroup() {
        performSegue(withIdentifier: "groupSelectionSegue", sender: nil)
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
    
    func didSelect(lesson: Lesson, forDate dateString: String) {
        self.selectedLesson = lesson
        self.selectedDate = dateString
        performSegue(withIdentifier: "lessonSegue", sender: nil)
    }
    
}

extension ScheduleVC: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}

extension ScheduleVC: GroupsSelectionTVCDelegate {
    
    func didSelect(group: GroupInfo) {
        loadSchedule(for: group)
    }
    
}
