//
//  Service.swift
//  Examination
//
//  Created by Dan Albert Luab on 9/3/22.
//

import SwiftyJSON
import Alamofire

class Service {
    
    func getPhotos(completion: @escaping ([PhotosDataModel]?, String?, Error?) -> Void) {
        let key = "Client-ID 0e5fc490db8c844"
        let headers: HTTPHeaders = ["Authorization": key]
        
        Alamofire.request("https://api.imgur.com/3/gallery/top/top/week/1", method: .get, headers: headers ).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                

               
                let data = json["data"].array?.map{PhotosDataModel($0)}
                
                completion(data, nil, nil)
                
            case .failure(let error):
             
                completion(nil, nil, error)
            }
        }
    }
   
}
