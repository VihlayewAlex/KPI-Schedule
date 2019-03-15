//
//  LessonVC.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/11/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import UIKit

class LessonVC: UIViewController {
    
    @IBOutlet weak var dateBarItem: UIBarButtonItem!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: LessonTypeLabel!
    @IBOutlet weak var lessonRangeLabel: UILabel!
    @IBOutlet weak var breakRangeLabel: UILabel!
    @IBOutlet weak var teachersTableView: UITableView!
    @IBOutlet weak var teachersTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationsTableView: UITableView!
    @IBOutlet weak var locationsTableViewHeightConstraint: NSLayoutConstraint!
    
    var lesson: Lesson?
    var dateString: String?
    
    var teachersDataSource: LessonTeachersDataSource?
    var locationsDataSource: LessonLocationsDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLabels()
        configureTableViews()
    }
    
    private func configureLabels() {
        guard let lesson = lesson else { return }
        
        dateBarItem.title = dateString
        nameLabel.text = lesson.name
        typeLabel.text = lesson.type.fullName
        typeLabel.backgroundColor = lesson.type.color
        lessonRangeLabel.text = lesson.start + " - " + lesson.end
        breakRangeLabel.text = lesson.breakStart + " - " + lesson.breakEnd
    }
    
    private func configureTableViews() {
        guard let lesson = lesson else { return }
        
        teachersDataSource = LessonTeachersDataSource(teachers: lesson.teachers)
        locationsDataSource = LessonLocationsDataSource(locations: lesson.rooms)
    
        teachersTableView.delegate = self
        teachersTableView.dataSource = teachersDataSource
    
        locationsTableView.delegate = self
        locationsTableView.dataSource = locationsDataSource
        
        teachersTableViewHeightConstraint.constant = CGFloat(lesson.teachers.count) * 44.0
        locationsTableViewHeightConstraint.constant = CGFloat(lesson.rooms.count) * 200.0
    }
    
}

extension LessonVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == teachersTableView {
            print("Show teacher")
        } else if tableView == locationsTableView {
            print("Show location")
        }
    }
    
}
