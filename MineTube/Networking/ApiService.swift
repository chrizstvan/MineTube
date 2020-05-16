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
    let baseURL = "https://s3-us-west-2.amazonaws.com/youtubeassets"
    
    func fetchVideos(completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString("\(baseURL)/home.json") { (videos) in
            completion(videos)
        }
    }
    
    func fetchTrendingVideos(completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString("\(baseURL)/trending.json", completion: completion)
    }
    
    func fetchSubscriptionVideos(completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString("\(baseURL)/subscriptions.json", completion: completion)
    }
    
    func fetchFeedForUrlString(_ url: String, completion: @escaping ([Video]) -> ()) {
        let url = URL(string: url)
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
                    video.thumbnail_image_name = dictionary["thumbnail_image_name"] as? String
                    video.number_of_views = dictionary["number_of_views"] as? NSNumber
                    
                    //video.setValuesForKeys(dictionary)
                    
                    let channelDictionary = dictionary["channel"] as! [String: AnyObject]
                    
                    let channel = Channel()
                    //channel.setValuesForKeys(channelDictionary)
                    channel.name = channelDictionary["name"] as? String
                    channel.profile_image_name = channelDictionary["profile_image_name"] as? String
                    
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
