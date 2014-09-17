//
//  MovieDetailController.swift
//  MovieBrowser
//
//  Created by Monika Gorkani on 9/14/14.
//  Copyright (c) 2014 Monika Gorkani. All rights reserved.
//

import UIKit

class DetailMovieController: UIViewController {
    
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    var synopsisText:String = ""
    var imageURL:String = ""
    var movieTitle:String = ""
    var titleYearText:String = ""
    var rottenRating:String = ""
    var rating:String = ""
    var thumbnailURL:String = ""
    var animate = false;
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleYearLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
   
    
    @IBOutlet weak var rottenRatingLabel: UILabel!
    let tapRec = UITapGestureRecognizer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.synopsisLabel.text = synopsisText
      
       
        let request = NSURLRequest(URL: NSURL(string: thumbnailURL))
        let largeRequest = NSURLRequest(URL: NSURL(string: imageURL))
        let largeImageRequestSuccess = {
            (request : NSURLRequest!, response : NSHTTPURLResponse!, image : UIImage!) -> Void in
            
            self.thumbnailView.hidden = true
            self.posterView.image = image;
         
           
            
        }
        
        let imageRequestFailure = {
            (request : NSURLRequest!, response : NSHTTPURLResponse!, error : NSError!) -> Void in
            if (error? != nil) {
                let errorString = error.localizedDescription
                
                CSNotificationView.showInViewController(self, style: CSNotificationViewStyleError, message: errorString)
                
                             
            }

        }


        let imageRequestSuccess = {
            (request : NSURLRequest!, response : NSHTTPURLResponse!, image : UIImage!) -> Void in
           
            self.thumbnailView.image = image
            self.thumbnailView.alpha = 0.0;
            self.thumbnailView.image = image;
            UIView.animateWithDuration(0.7, animations: { () -> Void in
                self.thumbnailView.alpha = 1.0
            })
            self.posterView.setImageWithURLRequest(largeRequest, placeholderImage: nil, success: largeImageRequestSuccess, failure: imageRequestFailure)
            
        
        }
     
        self.thumbnailView.setImageWithURLRequest(request, placeholderImage: nil, success: imageRequestSuccess, failure: imageRequestFailure)
        
        
        self.title = movieTitle
        self.titleYearLabel.text = self.titleYearText
        self.ratingLabel.text = self.rating
        self.rottenRatingLabel.text = self.rottenRating
        tapRec.addTarget(self, action: "tappedView")
        self.containerView.addGestureRecognizer(tapRec)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func tappedView() {
        // animate
        if (!self.animate) {
            
            UIView.animateWithDuration(0.3, delay: 0.1, options: .CurveEaseOut, animations: {
                var contentFrame = self.containerView.frame
                contentFrame.origin.y -= contentFrame.size.height
                var synopsisFrame = self.synopsisLabel.frame
                synopsisFrame.size.height += contentFrame.size.height
                self.synopsisLabel.frame = synopsisFrame
                contentFrame.size.height *= 2
               
                self.containerView.frame = contentFrame
                
                }, completion: { finished in
                    self.animate = true
            })
            
        }
        else {
            // reverse the animation
            
            UIView.animateWithDuration(0.3, delay: 0.1, options: .CurveEaseOut, animations: {
                var contentFrame = self.containerView.frame
                contentFrame.origin.y += contentFrame.size.height/2
                var synopsisFrame = self.synopsisLabel.frame
                synopsisFrame.size.height -= contentFrame.size.height/2
                self.synopsisLabel.frame = synopsisFrame
                contentFrame.size.height /= 2
                self.containerView.frame = contentFrame
               
                
                }, completion: { finished in
                    self.animate = false
            })
            
        }
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
