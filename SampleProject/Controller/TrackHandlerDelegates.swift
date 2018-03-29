//
//  TrackHandlerDelegates.swift
//  SampleProject
//
//  Created by Saqib Khan on 3/29/18.
//  Copyright © 2018 Saqib Khan. All rights reserved.
//

import Foundation
import UIKit

extension TracksGalleryViewController {
    // MARK: - TrackHandler Delegate
    func getTheTracks(array: Array<Track>) {
        if array.count == 0 {
            let alert = UIAlertController(title: "Alert", message: "Array count is zero", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.tracksArray = array;
        
        numPages = array.count
        pages = [UIView?](repeating: nil, count: numPages)
        
        pageControl.numberOfPages = numPages
        pageControl.currentPage = 0
        
        self.selectedTrack = self.tracksArray[0]
        
        print(self.selectedTrack?.artworkUrl60)
        /**
         Setup the initial scroll view content size and first pages only once.
         (Due to this function called each time views are added or removed).
         */
        _ = setupInitialPages
        
        
        self.hideActivityIndicator()
    }
    
    func errorInFetchingTrack(error: Error) {
        let alert = UIAlertController(title: "Alert", message: "Error in fetching the records", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        //        print(error)
        self.hideActivityIndicator()
    }
}

