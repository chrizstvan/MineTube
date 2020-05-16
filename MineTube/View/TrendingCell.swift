//
//  TrendingCell.swift
//  MineTube
//
//  Created by Chris Stev on 15/05/20.
//  Copyright © 2020 chrizstvan. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {
    
    
}

extension TrendingCell {
    override func fetchVideos() {
        ApiService.sharedInstance.fetchTrendingVideos { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}
