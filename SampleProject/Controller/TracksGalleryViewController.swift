//
//  TracksGalleryViewController.swift
//  SampleProject
//
//  Created by Saqib Khan on 3/29/18.
//  Copyright © 2018 Saqib Khan. All rights reserved.
//

import UIKit

class TracksGalleryViewController: UIViewController, UIScrollViewDelegate, TrackHandlerDelegate{
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var trackName: UILabel!
    
    var numPages = 6
    var pages = [UIView?]()
    var transitioning = false
    var tracksArray: [Track] = []
    
    
    let trackHandler = TrackHandler()
    
    var selectedTrack: Track?
    
    // MARK: - Controller Life Cycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tracks Gallery"
        
        self.scrollView.layer.cornerRadius = 5.0
        self.scrollView.clipsToBounds = true
        
        self.showActivityIndicator()
        trackHandler.getSearchResults()
        trackHandler.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Register for notifications
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "trackDetailSegue"
        {
            let trackDetailViewController = segue.destination as! TrackDetailsViewController
            trackDetailViewController.trackDetails = self.selectedTrack
        }
    }
    
    
    
    
    // MARK: - Initial Setup
    lazy var setupInitialPages: Void = {
        /**
         Setup our initial scroll view content size and first pages once.
         
         Layout the scroll view's content size after we have knowledge of the topLayoutGuide dimensions.
         Each page is the width and height of the scroll view's frame.
         
         Note: Set the scroll view's content size to take into account the top layout guide.
         */
        adjustScrollView()
        
        // Pages are created on demand, load the visible page and next page.
        loadPage(0)
        //loadPage(1)
    }()
    
    
    // MARK: - Utilities
    func showActivityIndicator(){
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator(){
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    
    
    // MARK: - Actions
    @IBAction func gotoPage(_ sender: UIPageControl) {
        // User tapped the page control at the bottom, so move to the newer page, with animation.
        gotoPage(page: sender.currentPage, animated: true)
    }
    
    
    @IBAction func showDetailsForTrack() {
        self.performSegue(withIdentifier:"trackDetailSegue" , sender: self)
    }
    
    
}
