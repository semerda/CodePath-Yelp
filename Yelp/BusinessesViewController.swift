//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Ernest on 10/20/16.
//  Copyright © 2016 Purpleblue Pty Ltd. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // TODO: Add network check using package?
    
    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [Business] = []
    var selectedIndexPath : IndexPath = []
    var businessesOffset = NSNumber(value: 0)
    
    // Infinity Load
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    // Search Bar
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 340, height: 20))
    var currentQuery = ""
    
    // Refresh Control -- if using TableViewController then this is not needed because it's already embedded into UITableView
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Table View
        tableView.dataSource = self
        tableView.delegate = self
        
        // Automatically resizing rows (iOS 8+)
        // http://guides.codepath.com/ios/Table-View-Guide#automatically-resizing-rows-ios-8
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Only when table is empty
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        // Adding Pull-to-Refresh
        // Ref: https://guides.codepath.com/ios/Table-View-Guide#adding-pull-to-refresh
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        // Set up Infinite Scroll loading indicator
        // Ref: https://guides.codepath.com/ios/Table-View-Guide#adding-infinite-scroll
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filters", style: .plain, target: self, action: #selector(openFilters))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Map"), landscapeImagePhone: nil, style: .done, target: self, action: #selector(openMapView(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Filter"), landscapeImagePhone: nil, style: .done, target: self, action: #selector(openFilters(_:)))
        
        // Remove the separator inset
        // Ref: https://guides.codepath.com/ios/Table-View-Guide#how-do-you-remove-the-separator-inset
        tableView.separatorInset = UIEdgeInsets.zero
        
        // A little trick for removing the cell separators
        tableView.tableFooterView = UIView()
        
        // Add SearchBar to NavigationBar
        searchBar.placeholder = "Search for Food"
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        // Init Data Load
        //searchBar.text = currentQuery
        //loadData(query: currentQuery, usePaging: false)

        // For each view controller that is pushing
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BusinessesViewController.reLoadData),
                                               name: NSNotification.Name(rawValue: "BusinessesViewController.reLoadData"),
                                               object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Data
    
    func loadData1(query: String, usePaging: Bool) {
        
        // Ref: http://guides.codepath.com/ios/Showing-a-progress-HUD
        // Ref: https://github.com/jdg/MBProgressHUD
        // Display HUD right before the request is made
        //MBProgressHUD.showAdded(to: self.view, animated: true)
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = String("Searching for \(query)")
        
        if usePaging {
            businessesOffset = NSNumber(value: businessesOffset.intValue + 20) // 20 is the limit per load
        }
        print("businessesOffset: \(businessesOffset)")
        
        Business.searchWithTerm(term: query, offset: businessesOffset, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            //self.businesses = businesses!
            self.businesses.append(contentsOf: businesses!)
            
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
                
                // Update flag
                self.isMoreDataLoading = false
                
                // Stop the loading indicator
                self.loadingMoreView!.stopAnimating()
                
                // Update table
                self.tableView.reloadData()
                
                // Tell the refreshControl to stop spinning
                self.refreshControl.endRefreshing()
                
                // Hide HUD once the network request comes back (must be done on main UI thread)
                //MBProgressHUD.hide(for: self.view, animated: true)
                loadingNotification.hide(animated: true)
            }
        })
    }
    
    func reLoadData() {
        loadData(query: currentQuery, usePaging: false)
    }
    
    func loadData(query: String, usePaging: Bool) {
        
        // Ref: http://guides.codepath.com/ios/Showing-a-progress-HUD
        // Ref: https://github.com/jdg/MBProgressHUD
        // Display HUD right before the request is made
        //MBProgressHUD.showAdded(to: self.view, animated: true)
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = String("Searching for \(query)")
        
        if usePaging {
            businessesOffset = NSNumber(value: businessesOffset.intValue + 20) // 20 is the limit per load
        }
        print("businessesOffset: \(businessesOffset)")
        
        var hasHeals = true
        var sortBy = YelpSortMode.bestMatched
        var radius = "0" as String
        var categoriesList = [] as [String]
        
        var filters = helperYelp.getSavedSettings()
        print("filters: \(filters)")
        if filters.count > 0 {
            hasHeals = filters[0] as! Bool
            sortBy = filters[1] as! YelpSortMode
            radius = filters[2] as! String
            categoriesList = filters[3] as! [String]
        }
        
        Business.searchWithTerm(term: query, offset: businessesOffset, sort: sortBy, radius: radius, categories: categoriesList, deals: hasHeals, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            //self.businesses = businesses!
            self.businesses.append(contentsOf: businesses!)
            
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                    print(business.hasDeal!)
                }
                
                // Update flag
                self.isMoreDataLoading = false
                
                // Stop the loading indicator
                self.loadingMoreView!.stopAnimating()
                
                // Update table
                self.tableView.reloadData()
                
                // Tell the refreshControl to stop spinning
                self.refreshControl.endRefreshing()
                
                // Hide HUD once the network request comes back (must be done on main UI thread)
                //MBProgressHUD.hide(for: self.view, animated: true)
                loadingNotification.hide(animated: true)
            }
        })
    }
    
    // MARK: - IBActions / Navigation
    
    @IBAction func openFilters(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "FilterSegue", sender: self)
    }
    
    @IBAction func openMapView(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "MapViewSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "BusinessDetailSegue" {
            // Get a reference to the detail view controller
            let destinationViewController = segue.destination as! BusinessDetailViewController
            
            // Pass the image through
            let indexPath = sender as! IndexPath
            //print("businesses[indexPath.row]: \(businesses[indexPath.row])")
            destinationViewController.business = businesses[indexPath.row]
        }
        
        if segue.identifier == "MapViewSegue" {
            // Get a reference to the detail view controller
            let destinationViewController = segue.destination as! BusinessesMapViewController
            
            // Pass the image through
            destinationViewController.businesses = businesses
        }
        
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        // Load data from API
        loadData(query: currentQuery, usePaging: false)
    }
    
    // MARK: - Table view data source & delegates
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessTableViewCell", for: indexPath) as! BusinessTableViewCell
        
        let business = (self.businesses[indexPath.row]) as Business

        cell.loadBusinessImage(imageUrl: business.imageURL!)
        cell.nameLabel?.text = business.name
        cell.distanceLabel?.text = business.distance
        cell.loadRatingImage(imageUrl: business.ratingImageURL!)
        cell.addReviews(reviewCount: business.reviewCount!)
        cell.addressLabel?.text = business.address
        cell.categoriesLabel?.text = business.categories
        cell.loadHasDealImage(hasDeal: business.hasDeal!)
        
        // Customizing the cell selection effect
        // http://guides.codepath.com/ios/Table-View-Guide#customizing-the-cell-selection-effect
        // Use a red color when the user selects the cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(netHex:Constants.cellSelectedColor)
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count // new school: posts.count ?? 0 vs. old school: (posts ? posts.count : 0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get rid of the gray selection effect by deselecting the cell with animation
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        selectedIndexPath = indexPath
        
        self.performSegue(withIdentifier: "BusinessDetailSegue", sender: indexPath)
    }
    
}

// ScollView methods
extension BusinessesViewController: UIScrollViewDelegate {
    
    // Add a loading view to your view controller
    // https://guides.codepath.com/ios/Table-View-Guide#add-a-loading-view-to-your-view-controller
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Handle scroll behavior here
        
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // ... Code to load more results ...
                loadData(query: currentQuery, usePaging: true)
            }
        }
    }
}

// SearchBar methods
extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        
        // Remove focus from the search bar.
        searchBar.endEditing(true)
        
        searchBar.resignFirstResponder()
        
        // New search so we clear existing list
        self.businesses.removeAll()
        
        // Load data from API
        loadData(query: currentQuery, usePaging: false) // Default mode
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        //print(searchBar.text)
        
        // New search so we clear existing list
        self.businesses.removeAll()
        
        // Load data from API
        loadData(query: searchBar.text!, usePaging: false) // Search mode
    }
    
    // http://shrikar.com/swift-ios-tutorial-uisearchbar-and-uisearchbardelegate/
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
    }
}

// DZNEmptyData methods
extension BusinessesViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Nothing here yet"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Please try the Search bar or Filters above."
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "kraken-pb-eyes-colored")
    }
    
}
