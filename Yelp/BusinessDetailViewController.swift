//
//  BusinessDetailViewController.swift
//  Yelp
//
//  Created by Ernest on 10/23/16.
//  Copyright © 2016 Purpleblue.com. All rights reserved.
//

import UIKit
import MapKit

class BusinessDetailViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var addressLabel: UILabel?
    @IBOutlet weak var imageImageView: UIImageView?
    @IBOutlet weak var categoriesLabel: UILabel?
    @IBOutlet weak var distanceLabel: UILabel?
    @IBOutlet weak var ratingImageView: UIImageView?
    @IBOutlet weak var reviewCount: UILabel?
    @IBOutlet weak var hasDealImageView: UIImageView?

    @IBOutlet weak var mapView: MKMapView!
    
    var business: Business! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.mapView.delegate = self
        
        print("business: \(business)")
        
        showData()
    }
    
    func showData() {
        // Nav heading title
        let titleLabel = UILabel()
        let titleText = NSAttributedString(string: business.name!, attributes: [
            NSFontAttributeName : UIFont(name: "OpenSans", size: 18)!,
            NSForegroundColorAttributeName : UIColor.white
            ])
        titleLabel.attributedText = titleText
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        // Business info
        imageImageView?.setImageWith(business.imageURL!)
        distanceLabel?.text = business.distance
        ratingImageView?.setImageWith(business.ratingImageURL!)
        reviewCount?.text = String("\(business.reviewCount!) Review\((business.reviewCount?.intValue)! > 0 ? "s" : "")")
        addressLabel?.text = business.address
        categoriesLabel?.text = business.categories
        hasDealImageView?.image = business.hasDeal! ? UIImage.init(named: "Cutting-Coupon-Filled") : nil
        
        // Find business on the map and center it
        let centerLocation = CLLocation(latitude: business.coordinateLat!, longitude: business.coordinateLng!)
        goToLocation(location: centerLocation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Map
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    // MARK: - Navigate
    
    @IBAction func navigateToLocation(_ sender: AnyObject) {
        let url = URL(string: String("\(Constants.googleMapsNavigate)\(business.coordinateLat!),\(business.coordinateLng!)"))!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
