//
//  MoviesViewController.swift
//  RottenMovieController
//
//  Created by Monika Gorkani on 9/14/14.
//  Copyright (c) 2014 Monika Gorkani. All rights reserved.
//

import UIKit

class MoviesViewController: UITableViewController {
    
    var movies: [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
      
        self.refreshControl?.addTarget(self, action: Selector("refreshInvoked"), forControlEvents: UIControlEvents.ValueChanged)
        
        
         refresh()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func refreshInvoked() {
        refresh(viaPullToRefresh: true)
    }
    
    func refresh(viaPullToRefresh: Bool = false) {
        if (!viaPullToRefresh) {
            self.view.showActivityViewWithLabel("Loading")
        }
        var url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=9zp76vqxbpnmzngbtqs937ne"
        var request = NSURLRequest(URL: NSURL(string: url))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error? != nil) {
                let errorString = error.localizedDescription
                
                CSNotificationView.showInViewController(self, style: CSNotificationViewStyleError, message: errorString)
                
                if (viaPullToRefresh) {
                    self.refreshControl?.endRefreshing()
                }
                else {
                    self.view.hideActivityView()
                }
                
                
            }
            else {
                
                
                var object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                self.movies = object["movies"] as [NSDictionary]
                self.tableView.reloadData()
                if (viaPullToRefresh) {
                    self.refreshControl?.endRefreshing()
                }
                else {
                    self.view.hideActivityView()
                }
            }
            
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
         return movies.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        let movie = movies[indexPath.row]
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        let posters = movie["posters"] as NSDictionary
        let posterURL = posters["thumbnail"] as String
        cell.thumbnailView.setImageWithURL(NSURL(string:posterURL))
        return cell;

    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showDetail") {
            var indexPath:NSIndexPath = self.tableView.indexPathForSelectedRow()!
            let detailController = segue.destinationViewController as DetailMovieController
            let movie = self.movies[indexPath.row] as NSDictionary
            detailController.synopsisText = movie["synopsis"] as String
            let posters = movie["posters"] as NSDictionary
            var imageURL = posters["original"] as String
            imageURL = imageURL.stringByReplacingOccurrencesOfString("tmb", withString: "ori")
            detailController.imageURL = imageURL
            detailController.movieTitle = movie["title"] as String
            let year = movie["year"] as NSNumber
            detailController.titleYearText = "\(detailController.movieTitle) (\(year.stringValue))"
            detailController.rating = movie["mpaa_rating"] as String
            let rottenRating = movie["ratings"] as NSDictionary
            let criticRating = rottenRating["critics_score"] as NSNumber
            let audienceRating = rottenRating["audience_score"] as NSNumber
            detailController.rottenRating = "Critic score: \(criticRating.stringValue) Audience score: \(audienceRating.stringValue)"
            let thumbnailURL = posters["thumbnail"] as String
            detailController.thumbnailURL = thumbnailURL
            
            
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
