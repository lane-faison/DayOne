//
//  Models.swift
//  Pods-DayOne
//
//  Created by Lane Faison on 7/7/18.
//

import UIKit
import RealmSwift
import Toucan

class Entry: Object {
    @objc dynamic var text = ""
    @objc dynamic var date = Date()
    
    let pictures = List<Picture>()
}

class Picture: Object {
    @objc dynamic var fullImageName = ""
    @objc dynamic var thumbnailName = ""
    @objc dynamic var entry: Entry?
    
    convenience init(image: UIImage) {
        self.init()
        
        fullImageName = imageToUrlString(image: image)
        Toucan(image: image)
    }
    
    func imageToUrlString(image: UIImage) -> String {
        guard let imageData = UIImagePNGRepresentation(image) else { return "" }
        
        let fileName = UUID().uuidString + ".png"
        
        if var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            path.appendPathComponent(fileName)
            
            try? imageData.write(to: path)
            
            return fileName
        } else {
            return ""
        }
    }
}
