//
//  GalleryScrollView.swift
//  SampleProject
//
//  Created by Saqib Khan on 3/29/18.
//  Copyright © 2018 Saqib Khan. All rights reserved.
//

import Foundation
import UIKit

extension TracksGalleryViewController {
    
    
    // MARK: - Utilities
    func removeAnyImages() {
        for page in pages where page != nil {
            page?.removeFromSuperview()
        }
    }
    
    
    /// Readjust the scroll view's content size in case the layout has changed.
    func adjustScrollView() {
        scrollView.contentSize =
            CGSize(width: scrollView.frame.width * CGFloat(numPages),
                   height: scrollView.frame.height - topLayoutGuide.length)
    }
    
    
    // MARK: - Transitioning
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        /**
         Since we transitioned to a different screen size we need to reconfigure the scroll view content.
         Remove any the pages from our scrollview's content.
         */
        removeAnyImages()
        
        coordinator.animate(alongsideTransition: nil) { _ in
            // Adjust the scroll view's contentSize (larger or smaller) depending on the new transition size.
            self.adjustScrollView()
            
            // Clear out and reload the relevant pages.
            self.pages = [UIView?](repeating: nil, count: self.numPages)
            
            self.transitioning = true
            
            // Go to the appropriate page (but with no animation).
            self.gotoPage(page: self.pageControl.currentPage, animated: false)
            
            self.transitioning = false
        }
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    
    // MARK: - Page Loading
    func loadPage(_ page: Int) {
        guard page < numPages && page != -1 else { return }
        
        if pages[page] == nil {
            let trackDetails:Track = tracksArray[page]
            let newImageView = UIImageView(image: nil)
            
            let urlString =  trackDetails.artworkUrl60
            newImageView.imageFromServerURL(urlString: urlString)
            self.artistName.text = trackDetails.artistName
            self.trackName.text = trackDetails.trackName
            
            //self.selectedTrack = trackDetails
            
            
            newImageView.contentMode = .scaleAspectFit
            
            /**
             Setup the canvas view to hold the image.
             Its frame will be the same as the scroll view's frame.
             */
            var frame = scrollView.frame
            // Offset the frame's X origin to its correct page offset.
            frame.origin.x = frame.width * CGFloat(page)
            // Set frame's y origin value to take into account the top layout guide.
            frame.origin.y = -self.topLayoutGuide.length
            frame.size.height += self.topLayoutGuide.length
            let canvasView = UIView(frame: frame)
            scrollView.addSubview(canvasView)
            
            // Setup the imageView's constraints to snap to all sides of its superview (canvasView).
            newImageView.translatesAutoresizingMaskIntoConstraints = false
            canvasView.addSubview(newImageView)
            
            NSLayoutConstraint.activate([
                (newImageView.leadingAnchor.constraint(equalTo: canvasView.leadingAnchor)),
                (newImageView.trailingAnchor.constraint(equalTo: canvasView.trailingAnchor)),
                (newImageView.topAnchor.constraint(equalTo: canvasView.topAnchor)),
                (newImageView.bottomAnchor.constraint(equalTo: canvasView.bottomAnchor))
                ])
            pages[page] = canvasView
        }
    }
    
    
    func loadCurrentPages(page: Int) {
        // Load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling).
        
        // Don't load if we are at the beginning or end of the list of pages.
        guard (page >= 0 && page < numPages) || transitioning else { return }
        
        // Remove all of the images and start over.
        removeAnyImages()
        pages = [UIView?](repeating: nil, count: numPages)
        
        // Load the appropriate new pages for scrolling.
        loadPage(Int(page))
    }
    
    
    func gotoPage(page: Int, animated: Bool) {
        loadCurrentPages(page: page)
        
        // Update the scroll view scroll position to the appropriate page.
        var bounds = scrollView.bounds
        bounds.origin.x = bounds.width * CGFloat(page)
        bounds.origin.y = 0
        scrollView.scrollRectToVisible(bounds, animated: animated)
    }
    
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Switch the indicator when more than 50% of the previous/next page is visible.
        let pageWidth = scrollView.frame.width
        let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        pageControl.currentPage = Int(page)
        
        self.selectedTrack = self.tracksArray[Int(page)]
        
        loadCurrentPages(page: pageControl.currentPage)
    }
    
    
}
