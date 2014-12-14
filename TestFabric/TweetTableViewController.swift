//
//  TweetTableViewController.swift
//  TestFabric
//
//  Created by Vavelin Kevin on 12/12/14.
//  Copyright (c) 2014 Vavelin Kevin. All rights reserved.
//

import UIKit
import TwitterKit
import Crashlytics

class TweetTableViewController: UITableViewController, TWTRTweetViewDelegate {
    
    var tweets : [TWTRTweet] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var prototypeCell: TWTRTweetTableViewCell?
    
    let tweetTableCellReuseIdentifier = "Tweet"
    var isLoadingTweets = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Tweets"
        
        let composeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: "composeTweet")
        self.navigationItem.rightBarButtonItem = composeButton
        
        self.prototypeCell = TWTRTweetTableViewCell(style: .Default, reuseIdentifier: tweetTableCellReuseIdentifier)
        loadTweets()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func composeTweet() {
        let composer = TWTRComposer()
        composer.showWithCompletion { (result) -> Void in
            if result == TWTRComposerResult.Cancelled {
                println("Cancel")
            } else {
                println("OK")
            }
        }
    }

    func loadTweets() {
        // Do not trigger another request if one is already in progress.
        if self.isLoadingTweets {
            return
        }
        self.isLoadingTweets = true
        
        // set tweetIds to find
        var tweetIDs = ["266031293945503744", "440322224407314432","542816760546615300","543748002951991300","543747977068965900","543720469149782016","543715020132335600"];
        
        // load tweets with guest login
        Twitter.sharedInstance().logInGuestWithCompletion { (session: TWTRGuestSession!, error: NSError!) in
            
            // Find the tweets with the tweetIDs
            Twitter.sharedInstance().APIClient.loadTweetsWithIDs(tweetIDs) {
                (twttrs, error) -> Void in
                
                // If there are tweets do something magical
                if ((twttrs) != nil) {
                    
                    // Loop through tweets and do something
                    for i in twttrs {
                        // Append the Tweet to the Tweets to display in the table view.
                        self.tweets.append(i as TWTRTweet)
                    }
                } else {
                    println(error)
                }
                
            }
        }
        
    }
    
    func refreshInvoked() {
        // Trigger a load for the most recent Tweets.
        loadTweets()
    }
    
    // MARK: TWTRTweetViewDelegate
    func tweetView(tweetView: TWTRTweetView!, didSelectTweet tweet: TWTRTweet!) {
        // Display a Web View when selecting the Tweet.
        let webViewController = UIViewController()
        let webView = UIWebView(frame: webViewController.view.bounds)
        webView.loadRequest(NSURLRequest(URL: tweet.permalink))
        webViewController.view = webView
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    // MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of Tweets.
        return tweets.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Retrieve the Tweet cell.
        let cell = tableView.dequeueReusableCellWithIdentifier(tweetTableCellReuseIdentifier, forIndexPath: indexPath) as TWTRTweetTableViewCell
        
        // Assign the delegate to control events on Tweets.
        cell.tweetView.delegate = self
        
        // Retrieve the Tweet model from loaded Tweets.
        let tweet = tweets[indexPath.row]
        
        // Configure the cell with the Tweet.
        cell.configureWithTweet(tweet)
        
        // Return the Tweet cell.
        return cell
    }
    
    // MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tweet = self.tweets[indexPath.row]
        self.prototypeCell?.configureWithTweet(tweet)
        if let height = self.prototypeCell?.calculatedHeightForWidth(self.view.bounds.width) {
            return height
        } else {
            return self.tableView.estimatedRowHeight
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
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
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
