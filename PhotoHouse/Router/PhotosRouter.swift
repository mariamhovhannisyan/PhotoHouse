//
//  PhotosRouter.swift
//  PhotoHouse
//
//  Created by Mar Hovhannisyan on 12/15/17.
//  Copyright © 2017 Mar Hovhannisyan. All rights reserved.
//

import Foundation
import UIKit

class PhotosRouter: PresenterToRouterProtocol {
    
    class func createModule() ->UIViewController{
        let view = mainstoryboard.instantiateViewController(withIdentifier: "PhotosViewController") as? PhotosViewController;
        //if let view = navController.childViewControllers.first as? LiveNewsViewController {
        let presenter: ViewToPresenterProtocol & InterectorToPresenterProtocol = PhotosPresenter();
        let interactor: PresentorToInterectorProtocol = PhotosInteractor()
        let router: PresenterToRouterProtocol = PhotosRouter();
        
        view?.presenter = presenter;
        presenter.view = view;
        presenter.router = router;
        presenter.interector = interactor;
        interactor.presenter = presenter;
        
        return view!;
        
        //}
        
        //return UIViewController()
    }
    
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
}
