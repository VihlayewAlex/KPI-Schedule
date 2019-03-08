//
//  ScheduleDayVC.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

protocol ScheduleScrollingDelegate: class {
    
    func didScrollDay()
    
    func didScrollWeek()
    
}

final class ScheduleDayVC: UIViewController {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableFooterView: UIView!
    
    weak var delegate: ScheduleScrollingDelegate?
    
    var day: Day!
    var week: ScheduleWeek!
    var currentWeek: ScheduleWeek!
    
    let backgroundView = { () -> UIView in
        let view = UIView()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "scheduleBgPattern")!)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 229 / 255, green: 229 / 255, blue: 229 / 255, alpha: 1.0).cgColor
        view.layer.cornerRadius = 6.0
        view.clipsToBounds = true
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.layer.masksToBounds = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.reloadEmptyDataSet()
        
        if day.lessons.isEmpty {
            tableFooterView.isHidden = true
        }
        
        dayLabel.text = day.dayOfWeek.name.uppercased() + { () -> String in
            let currentDay = Date().dayOfWeek
            let displayedDay = day.dayOfWeek
            if week == currentWeek && displayedDay == currentDay {
                return " (TODAY)"
            } else {
                return ""
            }
        }()
        dateLabel.text = { () -> String in
            let currentDay = Date().dayOfWeek
            let displayedDay = day.dayOfWeek
            let offsetInDays = displayedDay.index - currentDay.index
            var displayedDate = Calendar.current.date(byAdding: .day, value: offsetInDays, to: Date())!
            if week == .first && currentWeek == .second {
                // Substract week
                displayedDate = Calendar.current.date(byAdding: .day, value: -7, to: displayedDate)!
            } else if week == .second && currentWeek == .first {
                // Add week
                displayedDate = Calendar.current.date(byAdding: .day, value: 7, to: displayedDate)!
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            return dateFormatter.string(from: displayedDate)
        }()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delegate?.didScrollDay()
        
        if backgroundView.superview == nil {
            backgroundView.layer.opacity = 0.0
            view.insertSubview(backgroundView, belowSubview: tableView)
            let calculatedWidth = { () -> CGFloat in
                let screenWidth = UIScreen.main.bounds.size.width
                return screenWidth - (16.0 * 2)
            }()
            let calculatedHeight = { () -> CGFloat in
                guard let daysCount = self.day?.lessons.count else {
                    return 0.0
                }
                guard daysCount != 0 else {
                    return 0.0
                }
                let dividersCount = daysCount - 1
                return CGFloat(dividersCount) * 12.0 + CGFloat(dividersCount + 1) * 106.0
            }()
            backgroundView.frame = CGRect(origin: tableView.frame.origin, size: CGSize(width: calculatedWidth, height: calculatedHeight))
            
            UIView.animate(withDuration: 0.5) {
                self.backgroundView.layer.opacity = 1.0
            }
        }
    }
    
    @IBAction func share() {
        let textToShare = [day.lessons.reduce("", { (result, nextLesson) in
            var lessonString = "No lesson"
            if let lesson = nextLesson {
                lessonString = lesson.timeStart + " | " + lesson.name + " | " + (lesson.rooms.first?.name ?? "Somewhere")
            }
            return result + lessonString + "\n"
        }) + "Sent from @KPI-Schedule on iOS"]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}

extension ScheduleDayVC: UITableViewDataSource, UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.didScrollDay()
        backgroundView.frame = tableView.rect(forSection: 0)
            .shifted(by: tableView.frame.origin)
            .unshifted(by: scrollView.contentOffset)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let lessonsCount = day?.lessons.count else {
            return 0
        }
        guard lessonsCount != 0 else {
            return 0
        }
        return (2 * lessonsCount) - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 != 0 {
            let separatorCell = tableView.dequeueReusableCell(withIdentifier: "separatorCell", for: indexPath)
            return separatorCell
        }
        if let lesson = day?.lessons[(indexPath.row) / 2] {
            let lessonCell = tableView.dequeueReusableCell(withIdentifier: "lessonCell", for: indexPath) as! LessonCell
            lessonCell.nameLabel.text = lesson.name
            lessonCell.locationLabel.text = lesson.rooms.first?.name
            lessonCell.teacherLabel.text = lesson.teachers.first?.shortName
            lessonCell.typeLabel.text = lesson.type.name
            lessonCell.typeLabel.backgroundColor = lesson.type.color
            
            lessonCell.layer.cornerRadius = 6.0
            lessonCell.clipsToBounds = true
            lessonCell.layer.shadowPath = UIBezierPath(roundedRect: lessonCell.bounds, cornerRadius: lessonCell.layer.cornerRadius).cgPath
            lessonCell.layer.shadowColor = UIColor.black.cgColor
            lessonCell.layer.shadowOpacity = 0.3
            lessonCell.layer.shadowOffset = CGSize(width: 0, height: 4)
            lessonCell.layer.shadowRadius = 8
            lessonCell.layer.masksToBounds = false
            
            return lessonCell
        } else {
            let gapCell = tableView.dequeueReusableCell(withIdentifier: "gapCell", for: indexPath)
            return gapCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 != 0 {
            return 12.0
        } else {
            return 106.0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.25, delay: 0.05 * Double(indexPath.row), animations: {
            cell.alpha = 1
        })
    }
    
}

extension ScheduleDayVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributedString = NSMutableAttributedString(string: "NO LESSONS TODAY")
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 183 / 255, green: 183 / 255, blue: 190 / 255, alpha: 1.0),
            .font: UIFont.systemFont(ofSize: 18.0, weight: .heavy)
        ]
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributedString = NSMutableAttributedString(string: "Or not only today? ;)")
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 183 / 255, green: 183 / 255, blue: 190 / 255, alpha: 1.0),
            .font: UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        ]
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return day.lessons.isEmpty
    }
    
}

