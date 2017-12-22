//
//  PhotosInteractor.swift
//  PhotoHouse
//
//  Created by Mar Hovhannisyan on 12/14/17.
//  Copyright © 2017 Mar Hovhannisyan. All rights reserved.
//

import Foundation
import SwiftyDropbox
import GoogleAPIClientForREST
import GoogleSignIn

class PhotosInteractor: NSObject, PresentorToInterectorProtocol {
    
    var presenter: InterectorToPresenterProtocol?
    private let scopes = [kGTLRAuthScopeDriveReadonly]
    private let googleService = GTLRDriveService()
    private var currentError: Any?
    
    func fetchPhotos(cloudType: CloudType) {
        
        switch cloudType {
        case .dropbox:
            photosForDropBox(completion: { (photos) in
                self.presenter?.photosFetched(photos: photos, cloudType: .dropbox)
            })
            
        case .google:
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().scopes = scopes
            GIDSignIn.sharedInstance().signIn()
            
            
            
            
            
        case .icloud:
            break
        }
    }
    
    fileprivate func photosForDropBox(completion: @escaping (_ result: Array<Photo>) -> Void) {
        var photos: [Photo]?
        DispatchQueue.global(qos: .background).async {
            if let _ = DropboxClientsManager.authorizedClient {
                let client = DropboxClientsManager.authorizedClient
                
                _ = client?.files.listFolder(path: "").response { response, error in
                    if let result = response {
                        photos = []
                        var count = 0
                        for entry in result.entries {
                            
                            // Check that file is a photo (by file extension)
                            if entry.name.hasSuffix(".jpg") || entry.name.hasSuffix(".png") {
                                // Add photo!
                                count += 1
                                client?.files.download(path: entry.pathLower!)
                                    .response(completionHandler: { (file, error) in
                                        if let fileInfo = file {
                                            let img = UIImage(data: (fileInfo.1))
                                            let photo = Photo()
                                            photo.cloudType = .dropbox
                                            photo.content = img
                                            photos?.append(photo)
                                            if photos?.count == count {
                                                DispatchQueue.main.async {
                                                    completion(photos!)
                                                    
                                                }
                                            }
                                        }
                                    })
                                
                                
                            }
                        }
                        
                    }
                }
                
            }
        }
        
    }
    
    fileprivate func listGoogleFiles() {
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 10
        
        googleService.executeQuery(query,
                                   delegate: self,
                                   didFinish: #selector(displayGoogleResultsWithTicket(ticket:finishedWithObject:error:))
        )
    }
    
    
    
    @objc fileprivate func displayGoogleResultsWithTicket(ticket: GTLRServiceTicket,
                                                          finishedWithObject result : GTLRDrive_FileList,
                                                          error : NSError?) {
        if let error = error {
            presenter?.photosFetchedFailed(cloudType: .google, error: error.localizedDescription)
            return
        }
        
        if let files = result.files, !files.isEmpty {
            var photos: [Photo]?
            photos = []
            var count = 0
            for file in files {
                if file.name!.hasSuffix(".jpg") || file.name!.hasSuffix(".png") {
                    count += 1
                    DispatchQueue.global(qos: .background).async {
                        let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: file.identifier!)
                        self.googleService.executeQuery(query, completionHandler: { (ticket, fileData, error) in
                            let img = UIImage(data: (fileData as! GTLRDataObject).data)
                            let photo = Photo()
                            photo.cloudType = .google
                            photo.content = img
                            photos?.append(photo)
                            
                            if photos?.count == count {
                                DispatchQueue.main.async {
                                    //                                    completion(photos!)
                                    self.presenter?.photosFetched(photos: photos!, cloudType: .google)
                                    
                                }
                            }
                        })
                    }
                    
                }
            }
        } else {
            print("No files found.")
        }
    }
    
    fileprivate func photosForICloud() -> [Photo]? {
        var photos: [Photo]?
        
        return photos ?? nil
    }
}

extension PhotosInteractor: GIDSignInDelegate, GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            presenter?.photosFetchedFailed(cloudType: .google, error: error.localizedDescription)
            self.googleService.authorizer = nil
        } else {
            self.googleService.authorizer = user.authentication.fetcherAuthorizer()
            listGoogleFiles()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        
    }
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        
    }
}

