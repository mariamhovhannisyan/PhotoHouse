//
//  PhotoHouseProtocols.swift
//  PhotoHouse
//
//  Created by Mar Hovhannisyan on 12/14/17.
//  Copyright © 2017 Mar Hovhannisyan. All rights reserved.
//

import Foundation
import UIKit

protocol PresenterToViewProtocol: class{
    func showPhotos(photos: CloudPhotosModel);
    func showError();
}

protocol InterectorToPresenterProtocol: class{
    func photosFetched(news: PhotosModel);
    func photosFetchedFailed();
}

protocol PresentorToInterectorProtocol: class{
    var presenter: InterectorToPresenterProtocol? {get set} ;
    func fetchLiveNews();
}

protocol ViewToPresenterProtocol: class{
    var view: PresenterToViewProtocol? {get set};
    var interector: PresentorToInterectorProtocol? {get set};
    var router: PresenterToRouterProtocol? {get set}
    func updateView();
}

protocol PresenterToRouterProtocol: class{
    static func createModule() -> UIViewController;
}
