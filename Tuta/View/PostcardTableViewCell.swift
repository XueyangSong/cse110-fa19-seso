//
//  PostcardTableViewCell.swift
//  Tuta
//
//  Created by Yixing Wang on 11/8/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit

class PostcardTableViewCell: UITableViewCell {

    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var numRatingsLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
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
        print("set up ui in postcard cell view")
        print(self.frame.width)
        innerView.frame = CGRect(x: 8, y: 8, width: self.frame.width - 16, height: self.frame.height - 16)
        print(innerView.frame.width)
        print(self.frame.origin.x, self.frame.origin.y)
        print(innerView.frame.origin.x, innerView.frame.origin.y)
        innerView.backgroundColor = UIColor(red:0.85, green:0.93, blue:0.93, alpha:1.0)
        innerView.layer.cornerRadius = 10
        self.addSubview(innerView)
        
        // description label
        //descriptionLabel.frame.origin.x = 15
        
        descriptionLabel.textAlignment = .left
        print(descriptionLabel.frame.width)
        print(descriptionLabel.frame.origin.x)
    }

}
