//
//  TrackDetailsViewController.swift
//  SampleProject
//
//  Created by Saqib Khan on 3/29/18.
//  Copyright © 2018 Saqib Khan. All rights reserved.
//

import UIKit

class TrackDetailsViewController: UIViewController{
    
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var perviewImage: UIImageView!
    
    var trackDetails: Track?
    
    // MARK: - Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Track Details"
        
        guard let perviewURL = trackDetails?.artworkUrl60 else {
            return
        }
        
        guard let collectionName = trackDetails?.collectionName else {
            return
        }
        
        guard let artistName = trackDetails?.artistName else {
            return
        }
        
        guard let trackName = trackDetails?.trackName else {
            return
        }
        
        self.artistName.text = artistName
        self.collectionName.text = collectionName
        self.trackName.text = trackName
        self.perviewImage.imageFromServerURL(urlString: perviewURL)
        
        print(perviewURL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Register for notifications
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

