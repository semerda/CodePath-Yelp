//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Ernest on 10/21/16.
//  Copyright © 2016 Purpleblue.com. All rights reserved.
//

import UIKit

enum PrefRowIdentifier : String {
    case AutoRefresh = "Auto Refresh"
    case PlaySounds = "Play Sounds"
    case ShowPhotos = "Show Photos"
}

class Preferences {
    var autoRefresh = true, playSounds = true, showPhotos = true
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterSwitchCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var categories: [[String:String]] = []
    
    
    
    let headerTitles = ["", "Distance", "Sort By", "Category"]
    //let tableStructure: [[PrefRowIdentifier]] = [[.AutoRefresh], [.PlaySounds, .ShowPhotos]]
    
    static let tableStruct0 = [
        "heading": "",
        "key"    : "deals_filter",
        "type"   : "switch",
        "values" : [["name":"Offering a Deal", "code":"1"]]
        ] as [String : Any]
    
    static let tableStruct1 = [
        "heading": "Sort by",
        "key"    : "sort",
        "type"   : "checkmark",
        "values" : [["name":"Best Match", "code":"0"],
                    ["name":"Distance",   "code":"1"],
                    ["name":"Rating",     "code":"2"]
        ]
        ] as [String : Any]
    
    static let tableStruct2 = [
        "heading": "Distance",
        "key"    : "radius_filter",
        "type"   : "checkmark",
        "values" : [["name":"Auto",      "code":""],
                    ["name":"0.3 miles", "code":"1000"],
                    ["name":"1 mile",    "code":"1609"],
                    ["name":"5 mile",    "code":"3218"],
                    ["name":"20 mile",   "code":"8047"]
        ]
        ] as [String : Any]

    let tableStructure = [tableStruct0, tableStruct1, tableStruct2]
    
    /*
    let tableStructure = [
        ["Offering a Deal"],
        ["Auto", "0.3 miles", "1 mile", "5 mile", "20 mile"],
        ["Best Match", "Distance", "Highest Rated"],
        ["Afghan", "African", "American (New)", "American Traditional"]
    ]
    */
    
    var tableSelections = [0, 0, 0]
    
    var prefValues: [PrefRowIdentifier: Bool] = [:]
    
    // should be set by the class that instantiates this view controller
    var currentPrefs: Preferences! {
        didSet {
            prefValues[.AutoRefresh] = currentPrefs.autoRefresh
            prefValues[.PlaySounds] = currentPrefs.playSounds
            prefValues[.ShowPhotos] = currentPrefs.showPhotos
            tableView?.reloadData()
        }
    }
    
    func preferencesFromTableData() -> Preferences {
        let ret = Preferences()
        ret.autoRefresh = prefValues[.AutoRefresh] ?? ret.autoRefresh
        ret.playSounds = prefValues[.PlaySounds] ?? ret.playSounds
        ret.showPhotos = prefValues[.ShowPhotos] ?? ret.showPhotos
        return ret
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPrefs = currentPrefs ?? Preferences()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        categories = helperYelp.getCategories()
        
        let titleLabel = UILabel()
        let titleText = NSAttributedString(string: "Filters", attributes: [
            NSFontAttributeName : UIFont(name: "OpenSans", size: 18)!,
            NSForegroundColorAttributeName : UIColor.darkText
            ])
        
        titleLabel.attributedText = titleText
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        // Remove the separator inset
        // Ref: https://guides.codepath.com/ios/Table-View-Guide#how-do-you-remove-the-separator-inset
        tableView.separatorInset = UIEdgeInsets.zero
        
        // A little trick for removing the cell separators
        tableView.tableFooterView = UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("tableStructure.count: \(tableStructure.count)")
        
        return tableStructure.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 33.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("section: \(section) -- tableStructure[section].count: \(tableStructure[section].count)")
        
        return tableStructure[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0 || indexPath.section == 3) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterSwitchCell") as! FilterSwitchCell
            let prefIdentifier = tableStructure[indexPath.section][indexPath.row]
            
            //cell.prefRowIdentifier = prefIdentifier
            cell.descriptionLabel.text = prefIdentifier
            //cell.onOffSwitch.isOn = prefValues[prefIdentifier]!
            cell.delegate = self
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCheckCell") as! FilterCheckCell
            let prefIdentifier = tableStructure[indexPath.section][indexPath.row]
            
            cell.descriptionLabel.text = prefIdentifier
            
            if (indexPath.row == tableSelections[indexPath.section]) {
                cell.accessoryType = .checkmark
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1 || indexPath.section == 2) {
            if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
                if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                    //checked[indexPath.row] = false
                } else {
                    cell.accessoryType = .checkmark
                    
                    // Mark it as selected
                    tableSelections[indexPath.section] = indexPath.row
                    
                    //checked[indexPath.row] = true
                }
            }
            
            tableView.reloadData()
            print(tableSelections)
        }
    }
    
    func preferenceSwitchCellDidToggle(cell: FilterSwitchCell, newValue: Bool) {
        prefValues[cell.prefRowIdentifier] = newValue
    }
    
    // MARK: - IBActions / Navigation
    
    @IBAction func cancel(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func search(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}

/*
class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let headerTitles = ["", "Distance", "Sort By", "Category"]
    let data = [["Offering a Deal"], ["Auto", "0.3 miles", "1 mile", "5 mile", "20 mile"], ["Best Match"], ["Afghan", "African", "American (New)", "American Traditional"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Table View
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            if headerTitles[section].characters.count > 0 {
                return headerTitles[section]
            } else {
                return nil
            }
        }
        
        return nil
    }
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print("data.count: \(data.count)")
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("section: \(section) - data[section].count: \(data[section].count)")
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Yelp.Filter.Distance.Cell", for: indexPath) as! FilterTableViewCell
        
        cell.nameLabel?.text = data[indexPath.section][indexPath.row]
        
        return cell
    }
    
}
 */
