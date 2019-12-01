//
//  PostcardTableViewCell.swift
//  Tuta
//
//  Created by Yixing Wang on 11/8/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit
import Cosmos


class PostcardTableViewCell: UITableViewCell {

    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var numRatingsLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var ratingCosmosRating: CosmosView!
    
    var newDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUp()
}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp() {
        
        self.backgroundColor = .clear
        innerView.frame = CGRect(x: 8, y: 8, width: self.frame.width - 16, height: self.frame.height - 16)
        innerView.backgroundColor = UIColor(red:0.85, green:0.93, blue:0.93, alpha:1.0)
        innerView.layer.cornerRadius = 10
        self.addSubview(innerView)
        
        // description
        descriptionLabel.numberOfLines = 0
        profileImageView.layer.cornerRadius = 10
        descriptionLabel.frame = CGRect(x: 164, y: 74, width: 206, height: 55)
        
        // imageView
        profileImageView.centerYAnchor.constraint(equalTo: innerView.centerYAnchor).isActive = true
    }
    
    
    func setUpStarRatingView() {
        ratingCosmosRating.settings.fillMode = .precise
        ratingCosmosRating.settings.starSize = 15

    }

}
