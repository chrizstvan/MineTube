//
//  ApiService.swift
//  MineTube
//
//  Created by Chris Stev on 11/05/20.
//  Copyright © 2020 chrizstvan. All rights reserved.
//

import UIKit

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
    func fetchVideos(completion: @escaping ([Video]) -> ()) {
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
                var videos = [Video]()
                
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
                    videos.append(video)
                }
                
                DispatchQueue.main.async {
                    completion(videos)
                }
            }
            catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
}
