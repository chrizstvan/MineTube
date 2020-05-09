//
//  ViewController.swift
//  MineTube
//
//  Created by Chris Stev on 03/05/20.
//  Copyright © 2020 chrizstvan. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
//    var videos: [Video] = {
//        let mdchannel = Channel()
//        mdchannel.name = "MD Entertainment"
//        //mdchannel.profileImage = ""
//
//       let perahuKertasVideo = Video()
//        perahuKertasVideo.title = "Maudy Ayunda - Kamu & Kenangan (Official Music Video) | OST Habibie & Ainun 3"
//        perahuKertasVideo.thumbnailImage = "maudy_thumbnail"
//        perahuKertasVideo.channel = mdchannel
//        perahuKertasVideo.numberOfView = 1445554987
//
//        let ownChannel = Channel()
//        ownChannel.name = "Maudy Ayunda VEVO"
//
//        let tahuDiri = Video()
//        tahuDiri.title = "Maudy Ayunda - Tahu Diri"
//        tahuDiri.thumbnailImage = "maudy_thumbnail"
//        tahuDiri.channel = ownChannel
//        tahuDiri.numberOfView = 4377166618
//
//        return [perahuKertasVideo, tahuDiri]
//    }()
    
    var videos: [Video]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //navigationItem.title = "Home"
        fetchVideos()

        navigationController?.navigationBar.isTranslucent = false
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        
        collectionView.backgroundColor = .white
        
        setupElement()
        setupMenuBar()
        setupNavNarButton()
    }
    
    //Helper method
    private func setupElement() {
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addConstrainWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstrainWithFormat(format: "V:|[v0(50)]", views: menuBar)
    }
    
    func setupNavNarButton() {
        let searchImage = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        let moreBarButtonItem = UIBarButtonItem(image: UIImage(named: "more")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
        navigationItem.rightBarButtonItems = [moreBarButtonItem, searchBarButtonItem]
    }
    
    let setting = SettingLauncher()
    @objc func handleMore() {
        setting.showSetting()
    }
    
    @objc func handleSearch() {
        print("search")
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! VideoCell
        cell.video = videos?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.width - 16 - 16) * 9 / 16 // 9:16 is ratio HD
        return CGSize(width: view.frame.width, height: height + 16 + 88)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
        
}

//MARK:- API IMPLEMENTATION
extension HomeController {
    func fetchVideos() {
        let url = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error as Any)
                return
            }
            
            //let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //print(str as Any)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                self.videos = [Video]()
                
                for dictionary in json as! [[String: AnyObject]] {
                    let video = Video()
                    video.title = dictionary["title"] as? String
                    video.thumbnailImage = dictionary["thumbnail_image_name"] as? String
                    video.numberOfView = dictionary["number_of_views"] as? NSNumber
                    
                    let channelDictionary = dictionary["channel"] as! [String: AnyObject]
                    
                    let channel = Channel()
                    channel.name = channelDictionary["name"] as? String
                    channel.profileImage = channelDictionary["profile_image_name"] as? String
                    
                    video.channel = channel
                    self.videos?.append(video)
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
}





