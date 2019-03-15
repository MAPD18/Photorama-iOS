//
//  ViewController.swift
//  Photorama
//
//  Created by Rodrigo Silva on 2019-03-14.
//  Copyright © 2019 rodrigo. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var store: Photostore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        store.fetchInterestingPhotos(completion: { (photosResult) in
            switch photosResult {
            case let .success(photos):
                print("Successfullt found \(photos.count) photos")
                if let firstPhoto = photos.first {
                    self.updateImageView(for: firstPhoto)
                }
            case let .failure(error):
                print("Error \(error)")
            }
        })
    }

    func updateImageView(for photo: Photo) {
        store.fetchImage(for: photo) {
            (imageResult) -> Void in
            
            switch (imageResult) {
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error: \(error)")
            }
        }
    }

}

