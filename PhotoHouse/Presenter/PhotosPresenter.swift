//
//  PhotosPresenter.swift
//  PhotoHouse
//
//  Created by Mar Hovhannisyan on 12/14/17.
//  Copyright © 2017 Mar Hovhannisyan. All rights reserved.
//

import Foundation

class PhotosPresenter: ViewToPresenterProtocol {
    
    
    
    var view: PresenterToViewProtocol?
    var interector: PresentorToInterectorProtocol?
    var router: PresenterToRouterProtocol?
    
    func askForPhotosFor(type: CloudType) {
        interector?.fetchPhotos(cloudType: type)
    }
}

extension PhotosPresenter: InterectorToPresenterProtocol {
    
    func photosFetched(photos: [Photo],cloudType: CloudType) {
        view?.showPhotos(photos: photos, cloudType: cloudType)
    }
    
    func photosFetchedFailed(cloudType: CloudType, error: String) {
        view?.showError(cloudType: cloudType, error: error)
    }
    
}
