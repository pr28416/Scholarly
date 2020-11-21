//
//  Global.swift
//  GPA Calculator
//
//  Created by Pranav Ramesh on 11/19/20.
//  Copyright © 2020 Pranav Ramesh. All rights reserved.
//

import UIKit

extension UIColor {
    struct atlassian {
        // Static colors
        static let primaryBlue = UIColor(named: "Primary Blue")!
        static let primaryCyan = UIColor(named: "Primary Cyan")!
        static let primaryGreen = UIColor(named: "Primary Green")!
        static let primaryIndigo = UIColor(named: "Primary Indigo")!
        static let primaryPurple = UIColor(named: "Primary Purple")!
        static let primaryRed = UIColor(named: "Primary Red")!
        static let primaryYellow = UIColor(named: "Primary Yellow")!
        
        // Text and background
        static let listCellBackground = UIColor(named: "List Cell Background")
        static let listViewBackground = UIColor(named: "List View Background")
        static let primaryBackground = UIColor(named: "Primary Background")
        static let primaryLabel = UIColor(named: "Primary Label Text")
        static let secondaryBackground = UIColor(named: "Secondary Background")
        static let secondaryLabel = UIColor(named: "Secondary Label Text")
    }
}

class Global {
    static var main = Global()
    
    var gradeSheets: [GradeSheet]
    var customGPAs: [CustomGPA]
    
    var letterGrades = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-", "F"] // mod 13
    
    /// Create a new empty Global object
    init() {
        gradeSheets = []
        customGPAs = []
    }
    
    /// Create a new Global object with gradesheets and custom GPAs
    init(gradeSheets: [GradeSheet], customGPAs: [CustomGPA]) {
        self.gradeSheets = gradeSheets
        self.customGPAs = customGPAs
    }
    
    /// Returns the letter grade given the index number (range: [0, 12])
    func gradeLetter(for index: Int) -> String {
        return letterGrades[index % 13]
    }
    
    /// Returns the index of the letter grade given if found. Returns nil if not found.
    func gradeIndex(for letter: String) -> Int? {
        return letterGrades.firstIndex(of: letter)
    }
    
    /// Save all data to UserDefaults
    func saveData() {
        
    }
    
    /// Retrieve data from UserDefaults
    func retrieveData() {
        
    }
}

class GradeSheet: CustomStringConvertible {
    
    var description: String {
        var s = "\(title), \(uuid):\n"
        for i in self.grades {
            s += "\t" + i.description + "\n"
        }
        return s
    }
    
    var title: String
    var grades: [GradeItem]
    var uuid: String
    
    init(title: String, grades: [GradeItem], uuid: String) {
        self.title = title
        self.grades = grades
        self.uuid = uuid
    }
    
    init() {
        self.title = ""
        self.grades = []
        self.uuid = UUID().uuidString
    }
    
    /// Get grade at index
    func getGrade(at index: Int) -> GradeItem {
        if index < 0 || index >= self.grades.count {
            fatalError("Attempted to remove a grade from a nonexistent index:\n\tLength: \(self.grades.count) Requested index: \(index)")
        }
        return self.grades[index]
    }
    
    /// Get index given grade
    func index(of grade: GradeItem) -> Int? {
        return self.grades.firstIndex { (item) -> Bool in
            item.uuid == grade.uuid
        }
    }
    
    /// Add an empty grade
    func addGrade() {
        self.grades.append(GradeItem(name: "", classType: .standard, credits: 0, gradeIndex: 0))
    }
    
    /// Add a grade using an existing GradeItem object to the end of the list
    func addGrade(gradeItem: GradeItem) {
        self.grades.append(gradeItem)
    }
    
    /// Move grade from one index to another
    func moveGrade(from startIdx: Int, to endIdx: Int) {
        let start = max(0, startIdx)
        let end = min(self.grades.count-1, endIdx)
        if start < end {
            for i in start..<end {
                self.grades.swapAt(i, i+1)
            }
        } else {
            for i in stride(from: end, to: start, by: -1) {
                self.grades.swapAt(i, i-1)
            }
        }
    }
    
    /// Remove and return a GradeItem at an index
    func removeGrade(index: Int) -> GradeItem {
        if index < 0 || index >= self.grades.count {
            fatalError("Attempted to remove a grade from a nonexistent index:\n\tLength: \(self.grades.count) Requested index: \(index)")
        }
        return self.grades.remove(at: index)
    }
    
    /// Remove and return a GradeItem given the GradeItem object. Returns nil if the GradeItem object doesn't exist.
    func removeGrade(gradeItem: GradeItem) -> GradeItem? {
        let i = self.grades.firstIndex { (item) -> Bool in
            item.uuid == gradeItem.uuid
        }
        guard let index = i else {return nil}
        return self.removeGrade(index: index)
    }
}

class GradeItem: CustomStringConvertible {
    var description: String { return "\(className), \(classType), \(credits), \(Global.main.gradeLetter(for: gradeIndex)), \(uuid), \(timestamp)" }
    
    var className: String
    var classType: ClassType
    var credits: Double
    var gradeIndex: Int
    var uuid: String
    var timestamp: Date
    
    /// Create a new GradeItem object
    init(name: String, classType: ClassType, credits: Double, gradeIndex: Int) {
        self.className = name
        self.classType = classType
        self.credits = credits
        self.gradeIndex = gradeIndex
        self.uuid = UUID().uuidString
        self.timestamp = Date()
    }
    
    /// Create an existing GradeItem object
    init(name: String, classType: ClassType, credits: Double, gradeIndex: Int, uuid: String, timestamp: Date) {
        self.className = name
        self.classType = classType
        self.credits = credits
        self.gradeIndex = gradeIndex
        self.uuid = uuid
        self.timestamp = timestamp
    }
}

class CustomGPA {
    var title: String
    var chart: [String: Weight]
    
    init() {
        title = ""
        chart = [:]
        self.reset()
    }
    
    init(title: String, chart: [String: Weight]) {
        self.title = title
        self.chart = chart
    }
    
    /// Resets the chart
    func reset() {
        chart = [
            "A+": Weight(standard: 0, honors: 0, advanced: 0),
            "A": Weight(standard: 0, honors: 0, advanced: 0),
            "A-": Weight(standard: 0, honors: 0, advanced: 0),
            "B+": Weight(standard: 0, honors: 0, advanced: 0),
            "B": Weight(standard: 0, honors: 0, advanced: 0),
            "B-": Weight(standard: 0, honors: 0, advanced: 0),
            "C+": Weight(standard: 0, honors: 0, advanced: 0),
            "C": Weight(standard: 0, honors: 0, advanced: 0),
            "C-": Weight(standard: 0, honors: 0, advanced: 0),
            "D+": Weight(standard: 0, honors: 0, advanced: 0),
            "D": Weight(standard: 0, honors: 0, advanced: 0),
            "D-": Weight(standard: 0, honors: 0, advanced: 0),
            "F": Weight(standard: 0, honors: 0, advanced: 0),
        ]
    }
    
    /// Retrives the weights for a grade letter
    func getWeights(letter: String) -> Weight {
        if let weight = chart[letter] {return weight}
        fatalError("Attempted to get grade weights for grade letter that doesn't exist: \(letter)")
    }
}

struct Weight {
    var standard: Double
    var honors: Double
    var advanced: Double
}

enum ClassType: String {
    case standard = "Standard"
    case honors = "Honors"
    case advanced = "AP/IB"
}
