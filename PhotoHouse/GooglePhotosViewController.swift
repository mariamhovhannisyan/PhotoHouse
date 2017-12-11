//
//  GooglePhotosViewController.swift
//  PhotoHouse
//
//  Created by Mar Hovhannisyan on 12/8/17.
//  Copyright © 2017 Mar Hovhannisyan. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn

class GooglePhotosViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    private let scopes = [kGTLRAuthScopeDriveReadonly]
    
    @IBOutlet weak var tableView: UITableView!
    private let service = GTLRDriveService()
    let signInButton = GIDSignInButton()
    var googleImages: Array<Any>?
    let imageCache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        googleImages = []
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()
        
        // Add the sign-in button.
        view.addSubview(signInButton)
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.signInButton.isHidden = true
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            listFiles()
        }
    }
    
    // List up to 10 files in Drive
    func listFiles() {
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 10
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:))
        )
    }
    
    // Process the response and display output
    @objc func displayResultWithTicket(ticket: GTLRServiceTicket,
                                       finishedWithObject result : GTLRDrive_FileList,
                                       error : NSError?) {
        
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        if let files = result.files, !files.isEmpty {
            for file in files {
                if file.name!.hasSuffix(".jpg") || file.name!.hasSuffix(".png") {
                    self.googleImages?.append(file)
                    
                }
            }
            tableView.reloadData()
        } else {
            print("No files found.")
        }
    }
    
    
    // Helper for showing an alert
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
}

extension GooglePhotosViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (googleImages?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.tag = indexPath.row
        cell?.imageView?.image = nil
        
        let file = googleImages?[indexPath.row] as! GTLRDrive_File
        if let chachedImage = imageCache.object(forKey: file.name! as NSString) {
            cell?.imageView?.image = chachedImage
        }
        else {
            DispatchQueue.global(qos: .background).async {
                let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: file.identifier!)
                self.service.executeQuery(query, completionHandler: { (ticket, fileData, error) in
                    let img = UIImage(data: (fileData as! GTLRDataObject).data)
                    if (cell?.tag == indexPath.row) {
                        DispatchQueue.main.async {
                            cell?.imageView?.image = img
                            cell?.setNeedsLayout()
                            self.imageCache.setObject(img!, forKey: file.name! as NSString)
                        }
                    }
                })
            }
        }
        
        return cell!
    }
    
}
