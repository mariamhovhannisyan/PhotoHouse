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
    func showPhotos(photos: [Photo], cloudType: CloudType);
    func showError(cloudType: CloudType, error: String);
}

protocol InterectorToPresenterProtocol: class{
    func photosFetched(photos: [Photo], cloudType: CloudType);
    func photosFetchedFailed(cloudType: CloudType, error: String);
}

protocol PresentorToInterectorProtocol: class{
    var presenter: InterectorToPresenterProtocol? {get set} ;
    func fetchPhotos(cloudType: CloudType);
}

protocol ViewToPresenterProtocol: class{
    var view: PresenterToViewProtocol? {get set};
    var interector: PresentorToInterectorProtocol? {get set};
    var router: PresenterToRouterProtocol? {get set}
    //func updateView();
    func askForPhotosFor(type: CloudType)
}

protocol PresenterToRouterProtocol: class{
    static func createModule() -> UIViewController;
}
