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

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterSwitchCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let defaults = UserDefaults.standard
    
    let tableStructure = [helperYelp.structDeals, helperYelp.structSort, helperYelp.structDistance, helperYelp.structCategories]
    var tableSelections: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaults.set(nil, forKey: "yelp_filters_raw")
        defaults.synchronize()
        //loadSettings()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Nav heading title
        let titleLabel = UILabel()
        let titleText = NSAttributedString(string: "Filters", attributes: [
            NSFontAttributeName : UIFont(name: "OpenSans", size: 18)!,
            NSForegroundColorAttributeName : UIColor.white
            ])
        titleLabel.attributedText = titleText
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        // Remove the separator inset
        // Ref: https://guides.codepath.com/ios/Table-View-Guide#how-do-you-remove-the-separator-inset
        tableView.separatorInset = UIEdgeInsets.zero
        
        // A little trick for removing the cell separators
        tableView.tableFooterView = UIView()
        
        print("tableSelections: \(tableSelections)")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("tableStructure.count: \(tableStructure.count)")
        
        return tableStructure.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 33.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print("section: \(section) -- headerTitles[section]: \(tableStructure[section]["heading"])")
        
        return tableStructure[section]["heading"] as? String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let structureValues = tableStructure[section]["values"] as! [[String:String]]
        
        print("section: \(section) -- structureValues.count: \(structureValues.count)")
        
        return structureValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cellType = tableStructure[indexPath.section]["type"] as! String
        
        if (cellType == "FilterSwitchCell") {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterSwitchCell") as! FilterSwitchCell
            let sectionValues = tableStructure[indexPath.section]["values"] as! [[String:String]]
            let data = sectionValues[indexPath.row]
            
            cell.descriptionLabel.text = data["name"]
            
            cell.delegate = self
            
            return cell
        }
        else { // if (cellType == "FilterCheckCell") {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCheckCell") as! FilterCheckCell
            let sectionValues = tableStructure[indexPath.section]["values"] as! [[String:String]]
            let data = sectionValues[indexPath.row]
            
            cell.descriptionLabel.text = data["name"]
            
            let cellValues = tableStructure[indexPath.section]["values"] as! [[String:String]]
            let cellValue = cellValues[indexPath.row]["code"]! as String
            let key = String("\(indexPath.section):\(indexPath.row):\(cellValue)")
            
            if (data["checked"] == "1" && tableSelections.count == 0) {
                cell.accessoryType = .checkmark
            } else if (tableSelections.contains(key!)) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
            return cell
        }
    }
    
    // Called by delegate above
    func preferenceSwitchCellDidToggle(cell: FilterSwitchCell, newValue: Bool) {
        // Type of element
        let cellIndexPath = tableView.indexPath(for: cell)!
        // Value of selected cell
        let cellValues = tableStructure[cellIndexPath.section]["values"] as! [[String:String]]
        let cellValue = cellValues[cellIndexPath.row]["code"]! as String
        //print("cellValue: \(cellValue)")
        
        let key = String("\(cellIndexPath.section):\(cellIndexPath.row):\(cellValue)")

        if newValue {
            tableSelections.append(key!)
        } else {
            tableSelections.removeObject(object: key!)
        }
        
        print("tableSelections: \(tableSelections)")
        print(helperYelp.getFilterSettings(selections: tableSelections))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Type of element
        let cellType = tableStructure[indexPath.section]["type"] as! String
        // Value of selected cell
        let cellValues = tableStructure[indexPath.section]["values"] as! [[String:String]]
        let cellValue = cellValues[indexPath.row]["code"]! as String
        //print("cellValue: \(cellValue)")
        
        let key = String("\(indexPath.section):\(indexPath.row):\(cellValue)")
        
        if (cellType == "FilterCheckCell") {
            if let cell = tableView.cellForRow(at: indexPath as IndexPath) as? FilterCheckCell {
                if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                    
                    tableSelections.removeObject(object: key!)
                } else {
                    cell.accessoryType = .checkmark
                    
                    // Cleanup existing list
                    for object in tableSelections {
                        if String(object.characters.prefix(2)) == String("\(indexPath.section):") {
                            tableSelections.removeObject(object: object)
                        }
                    }
                    tableSelections.append(key!)
                    
                    tableView.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .none)
                }
            }
        }
        
        //self.tableView.reloadData()
        print("tableSelections: \(tableSelections)")
    }
    
    // MARK: - IBActions / Navigation
    
    @IBAction func cancel(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func search(_ sender: AnyObject) {
        print(helperYelp.getFilterSettings(selections: tableSelections))
        
        // Save for later re-use
        defaults.set(tableSelections, forKey: "yelp_filters_raw")
        defaults.synchronize()
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "BusinessesViewController.reLoadData"), object: self)
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func loadSettings() {
        if (defaults.object(forKey: "yelp_filters_raw") != nil) {
            tableSelections = defaults.object(forKey: "yelp_filters_raw") as! [String]
        }
    }
    
}
