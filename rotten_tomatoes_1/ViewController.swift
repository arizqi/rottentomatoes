//
//  ViewController.swift
//  rotten_tomatoes_1
//
//  Created by Ashar Rizqi on 2/7/15.
//  Copyright (c) 2015 Ashar Rizqi. All rights reserved.
//

import UIKit
import AlamoFire
import SVProgressHUD
import MBProgressHUD

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var movieList: NSArray = []
    var jsonResponse: Dictionary<String, NSObject>!
    var refreshControl: UIRefreshControl!
    var lowMC: MovieCell!
    var movieDictionary:NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movies"
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(refreshControl, atIndex: 0)
        self.fetchMovies()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var movieCell: MovieCell = tableView.dequeueReusableCellWithIdentifier("movieCell") as MovieCell
        var posters = movieList[indexPath.row]["posters"] as NSDictionary
        var ratings = movieList[indexPath.row]["ratings"] as NSDictionary
        var url = posters["thumbnail"] as NSString
        var yo = NSURL(string: url)
        Alamofire.request(.GET, yo!).response() {
            (_, _, data, _) in
            
            var image = UIImage(data: data! as NSData)
            movieCell.moviePoster.image = image
//            self.lowMC.moviePoster.image = image
        }
        movieCell.movieTitleLabel.text = movieList[indexPath.row]["title"] as NSString
        movieCell.mpaaRating.text = movieList[indexPath.row]["mpaa_rating"] as NSString
//        println(ratings["critics_score"])
        
        var critRating = ""
        if ratings["critics_score"]! as Int == -1 {
            critRating = "N/A"
        }
        else {
            critRating = String(ratings["critics_score"]! as Int)
        }
        movieCell.criticsRating.text = critRating
        movieCell.audienceRating.text = String(ratings["audience_score"]! as Int)
//        var fresh = UIImage(named: "fresh")
//        movieCell.ratingImage.image = fresh
        
        return movieCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        var mdvc = MovieDetail1()
//                self.navigationController?.pushViewController(mdvc, animated: true)
        performSegueWithIdentifier("movieDetail", sender: indexPath)
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        delay(2, closure: {
            self.fetchMovies()
            self.refreshControl.endRefreshing()
        })
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = tableView.indexPathForSelectedRow()
        if segue.identifier == "movieDetail" {
            
            let detailVC: MovieDetailViewController = segue.destinationViewController as MovieDetailViewController
            let row = sender!.row
            let yoMovieTitle = self.movieList[row]["title"]! as NSString
            var posters = self.movieList[row]["posters"]! as NSDictionary
            var ratings = self.movieList[row]["ratings"]! as NSDictionary
            var year = String(self.movieList[row]["year"]! as Int)
            var mpaa = self.movieList[row]["mpaa_rating"] as NSString
            var url = posters["thumbnail"] as NSString
            var lowRes = NSURL(string: url)
            
            var highResUrl = url.stringByReplacingOccurrencesOfString("tmb", withString: "ori")
            var synopsys = self.movieList[row]["synopsis"] as NSString
            var img:UIImage!
            
            Alamofire.request(.GET, lowRes!).response() {
                (_, _, data, _) in
                
                let img = UIImage(data: data! as NSData)!
                detailVC.movieDetailPoster.image = img
                
            }
            
            var critRating = ""
            if ratings["critics_score"]! as Int == -1 {
                critRating = "N/A"
            }
            else {
                critRating = String(ratings["critics_score"]! as Int)
            }
            
            detailVC.movieTitle = yoMovieTitle
            detailVC.posterUrl = NSURL(string: highResUrl)
            detailVC.criticsScore = critRating
            detailVC.audienceScore = String(ratings["audience_score"]! as Int)
            detailVC.mpaaRating = mpaa
            detailVC.year = year
            detailVC.synopsis = synopsys
        }
    }
    

    
    func fetchMovies() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Alamofire.request(.GET, "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/opening.json?apikey=tdv4xt9utezfn8jxgx2khwf6")
            .responseJSON { (request, response, JSONresponse, error) in
                if error != nil {
                    self.errorLabel.hidden = false
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
                else {
                    self.errorLabel.hidden = true
                dispatch_async(dispatch_get_main_queue()) {
                    self.jsonResponse = JSONresponse as Dictionary<String, NSObject>
                    self.movieList = self.jsonResponse["movies"] as NSArray
                    self.movieDictionary = self.jsonResponse
                    self.tableView.reloadData()
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    }

                }
        }
    }


}

