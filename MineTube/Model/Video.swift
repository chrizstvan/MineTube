//
//  Video.swift
//  MineTube
//
//  Created by Chris Stev on 05/05/20.
//  Copyright © 2020 chrizstvan. All rights reserved.
//

import UIKit

class Video: NSObject {
    var title : String?
    var thumbnail_image_name: String?
    var number_of_views: NSNumber?
    var uploadDate: NSDate?
    var duration: NSNumber?
    
    var channel: Channel?
}

class Channel: NSObject {
    var name : String?
    var profile_image_name : String?
}
