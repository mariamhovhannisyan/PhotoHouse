//
//  ProgressViewController.swift
//  PhotoHouse
//
//  Created by Mar Hovhannisyan on 12/19/17.
//  Copyright © 2017 Mar Hovhannisyan. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController {
    
    
    fileprivate var alertView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        alertView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        alertView?.backgroundColor = UIColor(red: 55/255.0, green: 131/255.0, blue: 193/255.0, alpha: 1)
        alertView?.center = view.center
        view.addSubview(alertView!)
        let label = UILabel()
        label.text = "Please Wait"
        label.textColor = .white
        label.sizeToFit()
        label.center = view.center
        view.addSubview(label)
        alertView?.layer.cornerRadius = 20
    }
    
    
    
}
