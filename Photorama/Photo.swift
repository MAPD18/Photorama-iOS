//
//  Photo.swift
//  Photorama
//
//  Created by Rodrigo Silva on 2019-03-14.
//  Copyright © 2019 rodrigo. All rights reserved.
//

import Foundation

class Photo: Equatable {
    let title: String
    let remoteUrl: URL
    let photoId: String
    let dateTaken: Date
    
    init(title: String, remoteUrl: URL, photoId: String, dateTaken: Date) {
        self.title = title
        self.remoteUrl = remoteUrl
        self.photoId = photoId
        self.dateTaken = dateTaken
    }
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.photoId == rhs.photoId
    }
    
}
