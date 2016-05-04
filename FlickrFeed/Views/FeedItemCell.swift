//
//  FeedItemCell.swift
//  FlickrFeed
//
//  Created by Arslan Raza on 30/04/2016.
//  Copyright © 2016 Arslan Raza. All rights reserved.
//

import UIKit

class FeedItemCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelDatePublished: UILabel!
    @IBOutlet weak var imageViewFeed: UIImageView!
    
    
    // MARK: Private methods
    
    // MARK: Life Cycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageViewFeed.layer.cornerRadius = 5.0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Public methods

}
