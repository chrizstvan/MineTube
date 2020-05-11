//
//  SettingLauncher.swift
//  MineTube
//
//  Created by Chris Stev on 09/05/20.
//  Copyright © 2020 chrizstvan. All rights reserved.
//

import UIKit

class Setting: NSObject {
    let name: SettingName
    let imageName: String
    
    init(name: SettingName, image: String) {
        self.name = name
        self.imageName = image
    }
}

enum SettingName: String {
    case setting = "Setting"
    case tNC = "Tearm & Privacy Policy"
    case feedback = "Send Feedback"
    case help = "Help"
    case account = "Switch Account"
    case cancel = "Cancel"
}

class SettingLauncher: NSObject {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    //Setting data
    let settings: [Setting] = {
        let setting = [Setting(name: .setting, image: "settings"),
                       Setting(name: .tNC, image: "lock"),
                       Setting(name: .feedback, image: "message-alert"),
                       Setting(name: .help, image: "help-circle"),
                       Setting(name: .account, image: "account-circle"),
                       Setting(name: .cancel, image: "close")]
        return setting
    }()
    
    var homeVC: HomeController?
    
    let cellHeight: CGFloat = 50
    
    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: "cellId")
    }
    
    let blackView = UIView()
    func showSetting() {
        //make black background
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            let height: CGFloat = CGFloat(settings.count) * cellHeight
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)

            }, completion: nil)
            
            
            //dismis tap recog
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        }
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
           
        }
    }
}

extension SettingLauncher: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! SettingCell
        let setting = settings[indexPath.item]
        cell.setting = setting
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let setting = self.settings[indexPath.item]
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }) { (completed) in
            
            if setting.name != .cancel {
                self.homeVC?.showControllerForSetting(setting: setting)
            }
            
        }
    }
}
