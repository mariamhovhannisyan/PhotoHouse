//
//  iCloudViewController.swift
//  PhotoHouse
//
//  Created by Mar Hovhannisyan on 12/12/17.
//  Copyright © 2017 Mar Hovhannisyan. All rights reserved.
//

import UIKit
import CloudKit

class iCloudViewController: UIViewController {
    
    var arrayDetails: Array<Any>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    @IBAction func iCLoudButton() {
        let container = CKContainer.default()
        let privateDatabase = container.privateCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "", predicate: predicate)

        privateDatabase.perform(query, inZoneWith: nil) { (results, error) -> Void in
            if error != nil {
                print(error?.localizedDescription)
                
                //MBProgressHUD.hide(for: self.view, animated: true)
            }
            else {
                print(results)
                
                for result in results! {
                    self.arrayDetails?.append(result)
                }
                
                OperationQueue.main.addOperation({ () -> Void in
                    //self.tableView.reloadData()
                    //self.tableView.isHidden = false
                    //MBProgressHUD.hide(for: self.view, animated: true)
                })
            }
        }
        
    }
}
extension iCloudViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
    }
}
