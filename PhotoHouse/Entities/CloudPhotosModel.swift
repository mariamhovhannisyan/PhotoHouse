//
//  CloudPhotosModel.swift
//  PhotoHouse
//
//  Created by Mar Hovhannisyan on 12/14/17.
//  Copyright © 2017 Mar Hovhannisyan. All rights reserved.
//

import Foundation

enum CloudType: Int {
    case dropbox
    case google
    case icloud
    
    static let count: Int = {
        var max: Int = 0
        while let _ = CloudType(rawValue: max) { max += 1 }
        return max
    }()
    
    static let mapper: [CloudType: String] = [
        .dropbox: "DropBox",
        .google: "Google Drive",
        .icloud: "iCloud"
    ]
    
    var stringValue: String {
        return CloudType.mapper[self]!
    }
    
}

class CloudPhotosModel {
    
    
    
    var cloudTypes: [CloudType]?
    
    func photosForCloudType(cloudType: CloudType) {
        
    }
}
