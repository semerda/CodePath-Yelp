//
//  BusinessTableViewCell.swift
//  Yelp
//
//  Created by Ernest on 10/20/16.
//  Copyright © 2016 Purpleblue Pty Ltd. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var addressLabel: UILabel?
    @IBOutlet weak var imageImageView: UIImageView?
    @IBOutlet weak var categoriesLabel: UILabel?
    @IBOutlet weak var distanceLabel: UILabel?
    @IBOutlet weak var ratingImageView: UIImageView?
    @IBOutlet weak var reviewCount: UILabel?
    @IBOutlet weak var hasDealImageView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Remove the separator inset
        // Ref: https://guides.codepath.com/ios/Table-View-Guide#how-do-you-remove-the-separator-inset
        self.layoutMargins = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadBusinessImage(imageUrl: URL) {
        // Fading in an Image Loaded from the Network
        // https://guides.codepath.com/ios/Working-with-UIImageView#fading-in-an-image-loaded-from-the-network
        let imageRequest = NSURLRequest(url: imageUrl)
        self.imageImageView?.setImageWith(
            imageRequest as URLRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    self.imageImageView?.alpha = 0.0
                    self.imageImageView?.image = image
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        self.imageImageView?.alpha = 1.0
                    })
                } else {
                    print("Image was cached so just update the image")
                    self.imageImageView?.image = image
                }
            },
            failure: { (imageRequest, imageResponse, error) -> Void in
                print("Image failed with error = \(error)")
                // do something for the failure condition
                self.imageImageView?.image = UIImage.init(named: "kraken-failure")
        })
    }
    
    func loadRatingImage(imageUrl: URL) {
        self.ratingImageView?.setImageWith(imageUrl)
    }
    
    func addReviews(reviewCount: NSNumber) {
        self.reviewCount?.text = String("\(reviewCount) Review\(reviewCount.intValue > 0 ? "s" : "")")
    }
    
    func loadHasDealImage(hasDeal: Bool) {
        self.hasDealImageView?.image = hasDeal ? UIImage.init(named: "Cutting-Coupon-Filled") : nil
    }

}
