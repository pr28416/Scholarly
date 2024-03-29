//
//  Global.swift
//  GPA Calculator
//
//  Created by Pranav Ramesh on 11/19/20.
//  Copyright © 2020 Pranav Ramesh. All rights reserved.
//

import UIKit

protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}

extension Date {
    static func stringFromDate(_ date: Date, format: String) -> String {
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: date)
    }
}

extension Notification.Name {
    static let mainMenuReloadTable = Notification.Name("mainMenuReloadTable")
    static let customGPASheetsReloadTable = Notification.Name("customGPASheetsReloadTable")
}

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
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
}

class Profile: Codable {
    var username: String
    var uid: String
    
    init() { username = ""; uid = UUID().uuidString }
    init(name: String) {
        self.username = name
        self.uid = UUID().uuidString
    }
    init(name: String, uid: String) {
        self.username = name
        self.uid = uid
    }
}

class Leaderboard: Codable {
    var title: String
    var id: String
    var members: [Profile]
    var customGPA: CustomGPA
    
    init(title: String = "", id: String = "", members: [Profile] = [], customGPA: CustomGPA = Global.main.defaultCustomGPA) {
        self.title = title
        self.id = id
        self.members = members
        self.customGPA = customGPA
    }
}

class Global {
    static var main = Global()
    
    var migrated = false
    var gradeSheets: [GradeSheet] = []
    var customGPAs: [CustomGPA] = [
        // Default 4.5
        CustomGPA(title: "Default 4.5 Scale", chart: [
            "A+": Weight(standard: 4.33, honors: 4.83, advanced: 5.33),
            "A": Weight(standard: 4.00, honors: 4.50, advanced: 5.00),
            "A-": Weight(standard: 3.67, honors: 4.17, advanced: 4.67),
            "B+": Weight(standard: 3.33, honors: 3.83, advanced: 4.33),
            "B": Weight(standard: 3.00, honors: 3.50, advanced: 4.00),
            "B-": Weight(standard: 2.67, honors: 3.17, advanced: 3.67),
            "C+": Weight(standard: 2.33, honors: 2.83, advanced: 3.33),
            "C": Weight(standard: 2.00, honors: 2.50, advanced: 3.00),
            "C-": Weight(standard: 1.67, honors: 2.17, advanced: 2.67),
            "D+": Weight(standard: 1.33, honors: 1.83, advanced: 2.33),
            "D": Weight(standard: 1.00, honors: 1.50, advanced: 2.00),
            "D-": Weight(standard: 0.67, honors: 1.17, advanced: 1.67),
            "F": Weight(standard: 0.00, honors: 0.00, advanced: 0.00),
        ]),
        
        // Default 4.33
        CustomGPA(title: "Default 4.33 Scale", chart: [
            "A+": Weight(standard: 4.33, honors: 4.67, advanced: 5.00),
            "A": Weight(standard: 4.00, honors: 4.33, advanced: 4.67),
            "A-": Weight(standard: 3.67, honors: 4.00, advanced: 4.33),
            "B+": Weight(standard: 3.33, honors: 3.67, advanced: 4.00),
            "B": Weight(standard: 3.00, honors: 3.33, advanced: 3.67),
            "B-": Weight(standard: 2.67, honors: 3.00, advanced: 3.33),
            "C+": Weight(standard: 2.33, honors: 2.67, advanced: 3.00),
            "C": Weight(standard: 2.00, honors: 2.33, advanced: 2.67),
            "C-": Weight(standard: 1.67, honors: 2.00, advanced: 2.33),
            "D+": Weight(standard: 1.33, honors: 1.67, advanced: 2.00),
            "D": Weight(standard: 1.00, honors: 1.33, advanced: 1.67),
            "D-": Weight(standard: 0.67, honors: 1.00, advanced: 1.33),
            "F": Weight(standard: 0.00, honors: 0.00, advanced: 0.00),
        ])
    ]
    
    var profile: Profile!
    var defaultCustomGPAIdx = 0
    var defaultCustomGPA: CustomGPA {
        return customGPAs[defaultCustomGPAIdx]
    }
    
    var letterGrades = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-", "F"]
    
    /// Initialize main instance
    func configure() {
        retrieveData()
        
        if !migrated {
            print("Beginning migration")
            migrate()
        } else {
            print("Already migrated")
        }
    }
    
    /// Migrate data
    func migrate() {
        // Migrate custom GPA weights
        for gradeWeightRow in customGPAList {
            let gpaList = CustomGPA(
                title: gradeWeightRow[0][0] as! String,
                chart: [:])
            for (idx, weight) in gradeWeightRow.enumerated() {
                if idx == 0 {continue}
                gpaList.chart[weight[0] as! String] = Weight(
                    standard: weight[2] as! Double,
                    honors: weight[3] as! Double,
                    advanced: weight[4] as! Double)
            }
            customGPAs.append(gpaList)
        }
        
        print("=================")
        print("Migrated custom GPA weights:")
        print("=================")
        
        for row in customGPAs {
            print(row.title)
            for (k, v) in row.chart {
                print("\t\(k), Std: \(v.standard), Hon: \(v.honors), Adv: \(v.advanced)")
            }
        }
        print("=================")
        
        // Migrate GPA sheets
        for sheet in globalStorage {
            let newSheet = GradeSheet(
                title: sheet.count > 0 ? sheet[0][6] as! String : "Unnamed",
                grades: sheet.map({ (item) -> GradeItem in
                    let typeIdx = item[5] as! Int
                    return GradeItem(
                        name: item[0] as! String,
                        classType: typeIdx == 0 ? .standard : typeIdx == 1 ? .honors : .advanced,
                        credits: item[3] as! Double,
                        gradeIndex: item[1] as! Int)
                }),
                uuid: sheet.count > 0 ? sheet[0][7] as! String : UUID().uuidString,
                customGPAIdx: Global.main.defaultCustomGPAIdx,
                timestamp: sheet.count > 0 ? Date(timeIntervalSinceReferenceDate: (sheet[0][8] as! NSDate).timeIntervalSinceReferenceDate) : Date())
            gradeSheets.append(newSheet)
        }
        
        print("=================")
        print("Migrated grade sheets:")
        print("=================")
        
        for row in gradeSheets {
            print(row)
        }
        print("=================")
        
        migrated = true
        saveData()
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
        let userDefaults = UserDefaults.standard
        do {
            try userDefaults.setObject(gradeSheets, forKey: "gradeSheets")
            try userDefaults.setObject(customGPAs, forKey: "customGPAs")
            try userDefaults.setObject(defaultCustomGPAIdx, forKey: "defaultCustomGPAIdx")
            try userDefaults.setObject(profile, forKey: "userProfile")
            try userDefaults.setObject(migrated, forKey: "migrated")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Retrieve data from UserDefaults
    func retrieveData() {
        let userDefaults = UserDefaults.standard
        do {
            gradeSheets = try userDefaults.getObject(forKey: "gradeSheets", castTo: [GradeSheet].self)
//            print("GradeSheets:\n\(gradeSheets)")
            customGPAs = try userDefaults.getObject(forKey: "customGPAs", castTo: [CustomGPA].self)
            defaultCustomGPAIdx = try userDefaults.getObject(forKey: "defaultCustomGPAIdx", castTo: Int.self)
            profile = try userDefaults.getObject(forKey: "userProfile", castTo: Profile.self)
            migrated = try userDefaults.getObject(forKey: "migrated", castTo: Bool.self)
        } catch {
            print(error.localizedDescription)
            profile = Profile()
        }
    }
    
    /// Returns the default custom GPA
    func defaultGPA() -> CustomGPA {
        return Global.main.customGPAs[Global.main.defaultCustomGPAIdx]
    }
}

class GradeSheet: Codable, CustomStringConvertible {
    
    var description: String {
        var s = "\(title), \(uuid), \(timestamp), \(customGPAIdx):\n"
        for i in self.grades {
            s += "\t" + i.description + "\n"
        }
        return s
    }
    
    var title: String
    var grades: [GradeItem]
    var uuid: String
    var customGPAIdx: Int
    var timestamp: Date
    
    init(title: String, grades: [GradeItem], uuid: String, customGPAIdx: Int, timestamp: Date) {
        self.title = title
        self.grades = grades
        self.uuid = uuid
        self.customGPAIdx = customGPAIdx
        self.timestamp = timestamp
    }
    
    init() {
        self.title = ""
        self.grades = []
        self.uuid = UUID().uuidString
        self.customGPAIdx = Global.main.defaultCustomGPAIdx
        self.timestamp = Date()
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
        self.grades.insert(self.grades.remove(at: max(0, startIdx)), at: min(self.grades.count, endIdx))
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
    
    /// Calculate and return unweighted GPA
    func getUnweightedGPA() -> Double {
        guard grades.count > 0 else {return 0.0}
        let weights = [4.33, 4.0, 3.67, 3.33, 3.0, 2.67, 2.33, 2.0, 1.67, 1.33, 1.0, 0.67, 0]
        var avg = 0.0
        var creditSum = 0.0
        for i in grades {
            avg += weights[i.gradeIndex] * i.credits
            creditSum += i.credits
        }
//        return avg / Double(grades.count)
        guard creditSum > 0 else {return 0.0}
        return avg / creditSum
    }
    
    /// Calculate and return weighted GPA
    func getWeightedGPA(scale: CustomGPA) -> Double {
        var avg = 0.0
        var creditSum = 0.0
        for grade in grades {
            switch grade.classType {
            case .standard: avg += grade.credits * scale.getWeights(letter: Global.main.gradeLetter(for: grade.gradeIndex)).standard
            case .honors: avg += grade.credits * scale.getWeights(letter: Global.main.gradeLetter(for: grade.gradeIndex)).honors
            case .advanced: avg += grade.credits * scale.getWeights(letter: Global.main.gradeLetter(for: grade.gradeIndex)).advanced
            }
            creditSum += grade.credits
        }
        guard creditSum > 0 else {return 0.0}
        return avg / creditSum
    }
    
    /// Get total number of credits
    var totalCredits: Double {
        var credits = 0.0
        for grade in grades {
            credits += grade.credits
        }
        return credits
    }
    
    /// Calculate and return weighted GPA from customGPAIdx property
    func getWeightedGPA() -> Double {
        return getWeightedGPA(scale: Global.main.customGPAs[customGPAIdx])
    }
    
    /// Return a copy of the GradeSheet object
    func copy() -> GradeSheet {
        var copiedGrades: [GradeItem] = []
        for grade in grades {
            copiedGrades.append(GradeItem(name: grade.className, classType: grade.classType, credits: grade.credits, gradeIndex: grade.gradeIndex, uuid: UUID().uuidString))
        }
        return GradeSheet(title: title, grades: copiedGrades, uuid: UUID().uuidString, customGPAIdx: customGPAIdx, timestamp: timestamp)
    }
}

class GradeItem: Codable, CustomStringConvertible {
    var description: String { return "\(className), \(classType), \(credits), \(Global.main.gradeLetter(for: gradeIndex)), \(uuid)" }
    
    var className: String
    var classType: ClassType
    var credits: Double
    var gradeIndex: Int
    var uuid: String
    
    /// Create a new GradeItem object
    init(name: String, classType: ClassType, credits: Double, gradeIndex: Int) {
        self.className = name
        self.classType = classType
        self.credits = credits
        self.gradeIndex = gradeIndex
        self.uuid = UUID().uuidString
    }
    
    /// Create an existing GradeItem object
    init(name: String, classType: ClassType, credits: Double, gradeIndex: Int, uuid: String) {
        self.className = name
        self.classType = classType
        self.credits = credits
        self.gradeIndex = gradeIndex
        self.uuid = uuid
    }
}

class CustomGPA: Codable {
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

struct Weight: Codable {
    var standard: Double
    var honors: Double
    var advanced: Double
}

enum ClassType: String, Codable {
    case standard = "Standard"
    case honors = "Honors"
    case advanced = "AP/IB"
}

func showAlert(_ controller: UIViewController, title: String, message: String, actions: [UIAlertAction]) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    for action in actions {alert.addAction(action)}
    controller.present(alert, animated: true, completion: nil)
}


