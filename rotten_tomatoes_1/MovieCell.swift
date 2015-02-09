//
//  MovieCell.swift
//  rotten_tomatoes_1
//
//  Created by Ashar Rizqi on 2/7/15.
//  Copyright (c) 2015 Ashar Rizqi. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieSynopsysLabel: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var mpaaRating: UILabel!
    @IBOutlet weak var criticsRating: UILabel!
    @IBOutlet weak var audienceRating: UILabel!
//    @IBOutlet weak var ratingImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
