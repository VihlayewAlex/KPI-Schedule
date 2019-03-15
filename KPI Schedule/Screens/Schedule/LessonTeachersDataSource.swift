//
//  LessonTeachersDataSource.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/15/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import UIKit

class LessonTeachersDataSource: NSObject, UITableViewDataSource {
    
    private let teachers: [Teacher]
    
    init(teachers: [Teacher]) {
        self.teachers = teachers
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teachers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teacherCell", for: indexPath)
        cell.textLabel?.text = teachers[indexPath.row].fullName
        return cell
    }
    
}
