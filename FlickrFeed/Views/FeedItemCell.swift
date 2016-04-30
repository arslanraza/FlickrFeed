//
//  FeedItemCell.swift
//  FlickrFeed
//
//  Created by Arslan Raza on 30/04/2016.
//  Copyright © 2016 Arslan Raza. All rights reserved.
//

import UIKit

class FeedItemCell: UITableViewCell {

    @IBOutlet weak var feedTitle: UILabel!
    @IBOutlet weak var feedImageView: UIImageView!
    
    // MARK: Private methods
    
    // MARK: Life Cycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Public methods

}
