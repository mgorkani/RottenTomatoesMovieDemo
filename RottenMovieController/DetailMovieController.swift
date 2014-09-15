//
//  MovieDetailController.swift
//  MovieBrowser
//
//  Created by Monika Gorkani on 9/14/14.
//  Copyright (c) 2014 Monika Gorkani. All rights reserved.
//

import UIKit

class DetailMovieController: UIViewController {
    
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    var synopsisText:String = ""
    var imageURL:String = ""
    var movieTitle:String = ""
    var titleYearText:String = ""
    var rottenRating:String = ""
    var rating:String = ""
    var thumbnailURL:String = ""
    
    @IBOutlet weak var titleYearLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var detailSynopsis: UITextView!
    
    @IBOutlet weak var rottenRatingLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailSynopsis.text = synopsisText
      //  self.posterView.setImageWithURL(NSURL(string:imageURL))
       
        let request = NSURLRequest(URL: NSURL(string: thumbnailURL))
        let largeRequest = NSURLRequest(URL: NSURL(string: imageURL))
        let largeImageRequestSuccess = {
            (request : NSURLRequest!, response : NSHTTPURLResponse!, image : UIImage!) -> Void in
            
            self.thumbnailView.hidden = true
            self.posterView.image = image;
            
        }
        
        let imageRequestFailure = {
            (request : NSURLRequest!, response : NSHTTPURLResponse!, error : NSError!) -> Void in
            NSLog("imageRequrestFailure")
        }


        let imageRequestSuccess = {
            (request : NSURLRequest!, response : NSHTTPURLResponse!, image : UIImage!) -> Void in
           
            self.thumbnailView.image = image
            self.posterView.setImageWithURLRequest(largeRequest, placeholderImage: nil, success: largeImageRequestSuccess, failure: imageRequestFailure)
            
        
        }
        
       
        
        self.thumbnailView.setImageWithURLRequest(request, placeholderImage: nil, success: imageRequestSuccess, failure: imageRequestFailure)
        
        
        self.title = movieTitle
        self.titleYearLabel.text = self.titleYearText
        self.ratingLabel.text = self.rating
        self.rottenRatingLabel.text = self.rottenRating
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
