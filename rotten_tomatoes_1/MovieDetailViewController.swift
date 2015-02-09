//
//  MovieDetailViewController.swift
//  rotten_tomatoes_1
//
//  Created by Ashar Rizqi on 2/7/15.
//  Copyright (c) 2015 Ashar Rizqi. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

class MovieDetailViewController: UIViewController {
    
    var movieTitle: String!
    var mpaaRating: String!
    var year: String!
    var criticsScore: String!
    var audienceScore: String!
    var synopsis: String!
    var posterUrl: NSURL!
    var lowResUrl: String!
    
    @IBOutlet weak var movieDetailPoster: UIImageView!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var mpaaRatingLabel: UILabel!
    @IBOutlet weak var criticsScoreLabel: UILabel!
    @IBOutlet weak var audienceScoreLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var synopsysLabel: UILabel!
    
    @IBOutlet weak var detailScroll: UIScrollView!
    
//    @IBOutlet weak var movieDetailImagePoster: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = movieTitle
        //self.detailScroll.delegate = self
        self.movieTitleLabel.text = movieTitle
        self.mpaaRatingLabel.text = mpaaRating
        self.yearLabel.text = year
        self.criticsScoreLabel.text = criticsScore
        self.audienceScoreLabel.text = audienceScore
        self.synopsysLabel.text = synopsis
        self.synopsysLabel.sizeToFit()
        
        
        
        Alamofire.request(.GET, self.posterUrl).response() {
            (_, _, data, _) in
            sleep(2)
            dispatch_async(dispatch_get_main_queue()) {
                let image = UIImage(data: data! as NSData)
                self.movieDetailPoster.image = image
            }
            
        }
        
        var total = CGFloat()
        
        for v in self.detailScroll.subviews {
            total += v.frame.size.height
        }
        
        var tot = Float(total)
        var h = self.synopsysLabel.frame.height
        var w = self.synopsysLabel.frame.width
        self.detailScroll.contentSize = CGSizeMake(w, total);
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
