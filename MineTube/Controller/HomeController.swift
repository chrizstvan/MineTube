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
    
    let pageTitle = ["Home", "Trending", "Subscription", "Account"]
    let trendingId = "trendingId"
    let subscriptId = "subscriptionId"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //navigationItem.title = "Home"

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
        setupCollectionView()
        //collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: "cellId2")
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        collectionView.register(TrendingCell.self, forCellWithReuseIdentifier: trendingId)
        collectionView.register(SubscriptionCell.self, forCellWithReuseIdentifier: subscriptId)
    }
    
    func setupCollectionView() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        collectionView.isPagingEnabled = true
        
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
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
    
    private func setTitleForIndex(index: Int) {
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "  \(pageTitle[Int(index)])"
        }
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
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(row: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .init(), animated: true)
        
        setTitleForIndex(index: menuIndex)
    }
    
    func showControllerForSetting(setting: Setting) {
        let dummySettingVC = UIViewController()
        dummySettingVC.navigationItem.title = setting.name.rawValue
        dummySettingVC.view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.pushViewController(dummySettingVC, animated: true)
    }
    
    //MARK:- Set Scroll View
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.move().x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
        
        //change title
        setTitleForIndex(index: Int(index))
    }
    
    //MARK:- Set Collection view
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstrain?.constant = scrollView.contentOffset.x / 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier: String
        
        if indexPath.item == 1 {
            identifier = trendingId
        } else if indexPath.item == 2 {
            identifier = subscriptId
        } else {
            identifier = "cellId2"
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }

    
}






