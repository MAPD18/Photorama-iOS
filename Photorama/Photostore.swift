//
//  Photostore.swift
//  Photorama
//
//  Created by Rodrigo Silva on 2019-03-14.
//  Copyright © 2019 rodrigo. All rights reserved.
//

import Foundation
import UIKit

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}
enum PhotoError : Error {
    case imageCreationError
}
enum PhotosResult {
    case success([Photo])
    case failure(Error)
}
class Photostore {
    private let session: URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default)
    }()
    
    func fetchInterestingPhotos(completion: @escaping (PhotosResult) -> Void) {
        let url = FlickrApi.interestingPhotosUrl
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            let result = self.processPhotosRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        })
        task.resume()
    }
    
    func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return FlickrApi.photos(fromJson: jsonData)
    }
    
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void) {
        let photoUrl = photo.remoteUrl
        let request = URLRequest(url: photoUrl)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            let result = self.processImageRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        guard let imageData = data,
            let image = UIImage(data: imageData) else {
                if data == nil {
                    return .failure(error!)
                } else {
                    return .failure(PhotoError.imageCreationError)
                }
        }
        
        return .success(image)
    }

}

