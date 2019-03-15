//
//  FlickApi.swift
//  Photorama
//
//  Created by Rodrigo Silva on 2019-03-14.
//  Copyright © 2019 rodrigo. All rights reserved.
//

import Foundation

enum FlickrError: Error {
    case invalidJsonData
}
enum Method : String {
    case interestingPhotos = "flickr.interestingness.getList"
}
struct FlickrApi {
    private static let baseUrl = "https://api.flickr.com/services/rest"
    private static let apiKey = "a6d819499131071f158fd740860a5a88"
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    private static func flickrUrl(method: Method, parameters: [String: String]?) -> URL {
        var components = URLComponents(string: baseUrl)!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": apiKey
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        return components.url!
    }
    
    static var interestingPhotosUrl: URL {
        return flickrUrl(method: .interestingPhotos, parameters: ["extras": "url_h,date_taken"])
    }
    
    static func photos(fromJson data: Data) -> PhotosResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard
                let jsonDictionary = jsonObject as? [AnyHashable:Any],
                let photos = jsonDictionary["photos"] as? [String:Any],
                let photosArray = photos["photo"] as? [[String:Any]] else {
                    return .failure(FlickrError.invalidJsonData)
            }
                    
            
            var finalPhotos = [Photo]()
            for photoJson in photosArray {
                if let photo = photo(fromJson: photoJson) {
                    finalPhotos.append(photo)
                }
            }
            if finalPhotos.isEmpty && !photosArray.isEmpty {
                return .failure(FlickrError.invalidJsonData)
            }
            return .success(finalPhotos)
        } catch let error {
            return .failure(error)
        }
    }
    
    private static func photo(fromJson json: [String: Any]) -> Photo? {
        guard
            let photoId = json["id"] as? String,
            let title = json["title"] as? String,
            let dateString = json["datetaken"] as? String,
            let photoUrlString = json["url_h"] as? String,
            let url = URL(string: photoUrlString),
            let dateTaken = dateFormatter.date(from: dateString) else {
                return nil
        }
        return Photo(title: title, remoteUrl: url, photoId: photoId, dateTaken: dateTaken)
    }
}
