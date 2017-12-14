//
//  CloudPhotosModel.swift
//  PhotoHouse
//
//  Created by Mar Hovhannisyan on 12/14/17.
//  Copyright © 2017 Mar Hovhannisyan. All rights reserved.
//

import Foundation

class CloudPhotosModel {
    
    enum CloudType {
        case dropbox
        case google
        case icloud
    }
    
    var cloudTypes: [CloudType]?
    
    func photosForCloudType(cloudType: CloudType) {
        
    }
}
