//
//  ViewController.swift
//  TestFabric
//
//  Created by Vavelin Kevin on 11/12/14.
//  Copyright (c) 2014 Vavelin Kevin. All rights reserved.
//

import UIKit
import TwitterKit
import MoPub

class ViewController: UIViewController, MPAdViewDelegate {
    
//    var userId : String!
    
    
    var adView : MPAdView = MPAdView(adUnitId: "ENTER YOUR UNIT ID HERE", size: MOPUB_BANNER_SIZE)


    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = TWTRLogInButton(logInCompletion:{ (session:TWTRSession!, error: NSError!) in
            // Play With Twitter session
            if (session != nil) {
//                self.userId = session.userID
                self.performSegueWithIdentifier("Main", sender: self)
            } else {
                var alertView = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                alertView.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in
                    alertView.dismissViewControllerAnimated(true, completion: nil)
                }))
                self.presentViewController(alertView, animated: true, completion: nil)
            }
        })
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
        println(loginButton.frame.size)
        let authenticateButton = DGTAuthenticateButton(authenticationCompletion:{(session:DGTSession!, error:NSError!) in
            // Play With Digit session
            if (session != nil) {
//                self.userId = session.userID
                self.performSegueWithIdentifier("Main", sender: self)
            } else {
                var alertView = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                alertView.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in
                    alertView.dismissViewControllerAnimated(true, completion: nil)
                }))
                self.presentViewController(alertView, animated: true, completion: nil)
            }
        })
        authenticateButton.frame.origin.x = loginButton.frame.origin.x
        authenticateButton.frame.origin.y = loginButton.frame.origin.y + loginButton.frame.size.height + 20
        self.view.addSubview(authenticateButton)
        
        self.adView.delegate = self
        self.adView.frame = CGRectMake(0, self.view.bounds.size.height - MOPUB_BANNER_SIZE.height, MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height)
        self.view.addSubview(self.adView)
        self.adView.loadAd()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func viewControllerForPresentingModalView() -> UIViewController! {
        return self
    }

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "Main" {
//            var navController = segue.destinationViewController as UINavigationController
//            var tweetViewController = navController.viewControllers.first as TweetTableViewController
//        }
//    }

}

