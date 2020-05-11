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
        titleLabel.text = "  Home"
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
        navigationController?.hidesBarsOnSwipe = true
        
        let redView = UIView()
        redView.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 32)
        view.addSubview(redView)
        view.addConstrainWithFormat(format: "H:|[v0]|", views: redView)
        view.addConstrainWithFormat(format: "V:[v0(50)]", views: redView)
        
        view.addSubview(menuBar)
        view.addConstrainWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstrainWithFormat(format: "V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
    }
    
    func setupNavNarButton() {
        let searchImage = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        let moreBarButtonItem = UIBarButtonItem(image: UIImage(named: "more")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
        navigationItem.rightBarButtonItems = [moreBarButtonItem, searchBarButtonItem]
    }
    
    lazy var setting: SettingLauncher = {
        let setting = SettingLauncher()
        setting.homeVC = self
        return setting
    }()
    
    @objc func handleMore() {
        setting.showSetting()
    }
    
    @objc func handleSearch() {
        print("search")
    }
    
    func showControllerForSetting(setting: Setting) {
        let dummySettingVC = UIViewController()
        dummySettingVC.navigationItem.title = setting.name.rawValue
        dummySettingVC.view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.pushViewController(dummySettingVC, animated: true)
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
        ApiService.sharedInstance.fetchVideos { (vid) in
            self.videos = vid
            self.collectionView.reloadData()
        }
    }
}





