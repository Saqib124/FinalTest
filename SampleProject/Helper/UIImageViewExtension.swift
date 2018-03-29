//
//  UIImageViewExtension.swift
//  SampleProject
//
//  Created by Saqib Khan on 3/28/18.
//  Copyright © 2018 Saqib Khan. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, AnyObject>()
extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        let url = URL(string: urlString)
        self.image = nil
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            }
        }).resume()
    }}
