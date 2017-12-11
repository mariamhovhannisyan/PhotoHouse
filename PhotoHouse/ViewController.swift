//
//  ViewController.swift
//  PhotoHouse
//
//  Created by Mar Hovhannisyan on 12/4/17.
//  Copyright © 2017 Mar Hovhannisyan. All rights reserved.
//

import UIKit
import SwiftyDropbox
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var webView: WKWebView!
    
    var dropboxImages: Array<UIImage>?
    var cache:NSCache<AnyObject, AnyObject> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotifications()
        self.dropboxImages = []
        accessToDropbox()
        
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(getImages), name: NSNotification.Name(rawValue: "DropBoxLoginSuccess"), object: nil)
    }
    
    func accessToDropbox() {
        if let client = DropboxClientsManager.authorizedClient {
            getImages()
        } else {
            DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                          controller: self,
                                                          openURL: { (url: URL) -> Void in
                                                            self.webView.load(URLRequest(url: url))
                                                            UIApplication.shared.open(url, options: [:], completionHandler:nil)
                                                            
                                                            
            })
            
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func getImages() {
        let client = DropboxClientsManager.authorizedClient
        
        _ = client?.files.listFolder(path: "").response { response, error in
            if let result = response {
                print("Folder contents:")
                
                for entry in result.entries {
                    print(entry.name)
                    
                    // Check that file is a photo (by file extension)
                    if entry.name.hasSuffix(".jpg") || entry.name.hasSuffix(".png") {
                        // Add photo!
                        
                        client?.files.download(path: entry.pathLower!)
                            .response(completionHandler: { (file, error) in
                                if let fileInfo = file {
                                    let img = UIImage(data: (fileInfo.1))
                                    self.dropboxImages?.append(img!)
                                    self.tableView.reloadData()
                                    
                                }
                            })
                    }
                }
            }
        }
    }
    
    @IBAction func signOutFromDropbox() {
        DropboxClientsManager.resetClients()
        dropboxImages = []
        tableView.reloadData()
        accessToDropbox()
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dropboxImages?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let img = dropboxImages?[indexPath.row]
        cell?.imageView?.image = img
        
        return cell!
    }
    
}

extension String {
    public func lastPathComponent() -> String {
        return (self as NSString).lastPathComponent
    }
    
    public func pathExtension() -> String {
        return (self as NSString).pathExtension
    }
}
