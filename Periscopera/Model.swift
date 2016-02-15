//
//  Model.swift
//  Periscopera
//
//  Created by Giorgia Marenda on 2/14/16.
//  Copyright © 2016 Giorgia Marenda. All rights reserved.
//

import Foundation
import SwiftyJSON
import Keys

class Video {
    
    var id: Int?
    var url: String?
    var video: NSURL?
    var tags: [String]?
    var country: String?
    var city: String?
    var lat: Int?
    var lng: Int?
    
    init(_ entry: JSON) {
        
        id = entry["gsx$id"]["$t"].int
        url = entry["gsx$url"]["$t"].string
        tags = entry["gsx$tags"]["$t"].string?.componentsSeparatedByString(",")
        if let url =  entry["gsx$video"]["$t"].string, videoUrl = NSURL(string: url) {
            video = videoUrl
        } else {
            video = nil
        }

        country = entry["gsx$country"]["$t"].string
        city = entry["gsx$city"]["$t"].string
        lat = entry["gsx$lat"]["$t"].int
        lng = entry["gsx$lng"]["$t"].int
    }
}

class Model {
    
    class func requestModel(handler:([Video]?, NSError?) -> Void) {
        let keys = PeriscoperaKeys()
        guard let url = NSURL(string: keys.spreadsheet()) else { return }
        let request = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if error != nil {
                handler(nil, error)
            } else {
                guard let videosData = data else { return }
                let json = JSON(data: videosData)
                let entries = json["feed"]["entry"].array
                let videos = entries?.map{ Video($0) }
                handler(videos, nil)
            }
        }
        task.resume()
    }

}
