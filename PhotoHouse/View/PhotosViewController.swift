//
//  PhotosViewController.swift
//  PhotoHouse
//
//  Created by Mar Hovhannisyan on 12/14/17.
//  Copyright © 2017 Mar Hovhannisyan. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {

    var presenter: ViewToPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.updateView()
    }

}

extension PhotosViewController: PresenterToViewProtocol {
    
    func showPhotos(photos: CloudPhotosModel) {
        
    }
    
    func showError() {
        
    }
}
