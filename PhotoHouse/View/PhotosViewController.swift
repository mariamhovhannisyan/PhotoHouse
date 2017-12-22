//
//  PhotosViewController.swift
//  PhotoHouse
//
//  Created by Mar Hovhannisyan on 12/14/17.
//  Copyright © 2017 Mar Hovhannisyan. All rights reserved.
//

import UIKit
import SwiftyDropbox
import GoogleAPIClientForREST
import GoogleSignIn

class PhotosViewController: UIViewController {
    
    
    
    private let service = GTLRDriveService()
    private let scopes = [kGTLRAuthScopeDriveReadonly]
    var presenter: ViewToPresenterProtocol?
    var currentPhotos: [Photo]?
    var signedProfilesCount: Int?
    var selectedCell: CloudTableViewCell?
    let progressVC = ProgressViewController()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        tableView.allowsMultipleSelection = true
        collectionView.register(UINib.init(nibName: "CloudPhotoCell", bundle: nil), forCellWithReuseIdentifier: "collectionViewCell")
        currentPhotos = []
        progressVC.view.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        progressVC.modalPresentationStyle = .overCurrentContext
        setupNotifications()
        
    }
    
    
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(dropboxIsSigned), name: NSNotification.Name(rawValue: "DropBoxLoginSuccess"), object: nil)
    }
    
    @objc func dropboxIsSigned() {
        presenter?.askForPhotosFor(type: .dropbox)
        
    }
    
    @IBAction func myProfilesIsTapped() {
        let shouldHide = !self.tableView.isHidden
        
        if shouldHide {
            closeMyProfiles()
        } else {
            openMyProfiles()
        }
        
    }
    
    fileprivate func closeMyProfiles() {
        let initialRect = tableView.frame
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
            self.tableView.frame = CGRect.zero
        }) { (finished) in
            self.tableView.isHidden = true
            self.tableView.frame = initialRect
        }
    }
    
    fileprivate func openMyProfiles() {
        tableView.isHidden = false
        let initialRect = tableView.frame
        tableView.frame = CGRect.zero
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
            self.tableView.frame = initialRect
        }) { (finished) in
            
        }
    }
}

extension PhotosViewController: PresenterToViewProtocol {
    
    func showPhotos(photos: [Photo], cloudType: CloudType) {
        currentPhotos = photos
        closeMyProfiles()
        selectedCell?.signOutButton.isHidden = false
        progressVC.dismiss(animated: true, completion: nil)
        collectionView.reloadData()
        
    }
    
    func showError(cloudType: CloudType, error: String) {
        showAlert(title: "Something went wrong", message: error)
    }
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (currentPhotos?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CloudPhotoCell
        cell.imageView.image = currentPhotos![indexPath.row].content
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = UIScreen.main.bounds.size.width / 2 - 10
        return CGSize(width: side, height: side)
    }
}

extension PhotosViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CloudType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as? CloudTableViewCell
        cell?.textLabel?.text = CloudType(rawValue: indexPath.row)?.stringValue
        cell?.textLabel?.textColor = .white
        
        return cell!
    }
    
}

extension PhotosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CloudTableViewCell
        cell.selectionStyle = .none
        selectedCell?.signOutButton.isHidden = true
        selectedCell = cell
        
        present(progressVC, animated: true, completion: nil)
        
        
        let cloud = CloudType(rawValue: indexPath.row)!
        switch  cloud {
        case .dropbox:
            if DropboxClientsManager.authorizedClient == nil {
                DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                              controller: self,
                                                              openURL: { (url: URL) -> Void in
                                                                //self.webView.load(URLRequest(url: url))
                                                                UIApplication.shared.open(url, options: [:], completionHandler:nil)
                                                                
                                                                
                })
            } else {
                presenter?.askForPhotosFor(type: .dropbox)
            }
        case .google:
            presenter?.askForPhotosFor(type: .google)
            break
        case .icloud:
            break
            
        }
        
    }
}
