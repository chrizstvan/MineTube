//
//  FeedCell.swift
//  MineTube
//
//  Created by Chris Stev on 13/05/20.
//  Copyright © 2020 chrizstvan. All rights reserved.
//

import UIKit

class FeedCell: BaseCell {
    
    var videos: [Video]?

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellId"
    
    override func setupView() {
        super.setupView()
        
        fetchVideos()
        
        addSubview(collectionView)
        addConstrainWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstrainWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: cellId)
    }
}

extension FeedCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VideoCell
        cell.video = videos?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (frame.width - 16 - 16) * 9 / 16 // 9:16 is ratio HD
        return CGSize(width: frame.width, height: height + 16 + 88)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // go to video
        let vl = VideoLauncher()
        vl.showVideoPlayer()
    }
    
}

//MARK:- API IMPLEMENT
extension FeedCell {
    @objc dynamic func fetchVideos() {
        ApiService.sharedInstance.fetchVideos { (vid) in
            self.videos = vid
            self.collectionView.reloadData()
        }
    }
}
