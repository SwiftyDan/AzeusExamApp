//
//  Photos.swift
//  ExamApp
//
//  Created by Dan Albert Luab on 8/29/22.
//

import SwiftyJSON

class PhotosDataModel {
    var id: String?
    var link: String?
    var gifv: String?
    var title: String?
    var images: [Images]?
    init(_ json: JSON) {
        id = json["id"].string
        link = json["link"].string
        gifv = json["gifv"].string
        title = json["title"].string
        images = json["images"].array?.map{Images($0)}
    }
}
class Images {
    var link: String?
  
    
    init(_ json: JSON) {
        link = json["link"].string
        
    }
}

class SavedData: NSObject, NSCoding {
 
    var id: String?
    var link: String?
    var gifv: String?
    var title: String?
    var images: String?

    init(_ json: JSON) {
        
        id = json["id"].string
        link = json["link"].string
        gifv = json["gifv"].string
        title = json["title"].string
        images = json["images"].string
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(link, forKey: "link")
        aCoder.encode(gifv, forKey: "gifv")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(images, forKey: "images")
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        id = aDecoder.decodeObject(forKey: "id") as? String
        link = aDecoder.decodeObject(forKey: "link") as? String
        gifv = aDecoder.decodeObject(forKey: "gifv") as? String
        title = aDecoder.decodeObject(forKey: "title") as? String
        images = aDecoder.decodeObject(forKey: "images") as? String
      
    }
}
