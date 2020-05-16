//
//  SubscriptionCell.swift
//  MineTube
//
//  Created by Chris Stev on 15/05/20.
//  Copyright © 2020 chrizstvan. All rights reserved.
//

import UIKit

class SubscriptionCell: FeedCell {
    
}

extension SubscriptionCell {
    override func fetchVideos() {
        ApiService.sharedInstance.fetchSubscriptionVideos { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}
