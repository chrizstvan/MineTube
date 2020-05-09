//
//  Video.swift
//  MineTube
//
//  Created by Chris Stev on 05/05/20.
//  Copyright © 2020 chrizstvan. All rights reserved.
//

import UIKit

class Video: NSObject {
    var title: String?
    var thumbnailImage: String?
    var numberOfView: NSNumber?
    var uploadDate: NSDate?
    
    var channel: Channel?
}

class Channel: NSObject {
    var name: String?
    var profileImage: String?
}
