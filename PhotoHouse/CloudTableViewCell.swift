//
//  CloudTableViewCell.swift
//  PhotoHouse
//
//  Created by Mar Hovhannisyan on 12/18/17.
//  Copyright © 2017 Mar Hovhannisyan. All rights reserved.
//

import UIKit

class CloudTableViewCell: UITableViewCell {

    @IBOutlet weak var signOutButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        signOutButton.titleLabel?.minimumScaleFactor = 0.5
        signOutButton.titleLabel?.numberOfLines = 0
        signOutButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //signOutButton.isHidden = selected ? false : true
        // Configure the view for the selected state
    }

   
    @IBAction func signOutButtonTapped(_ sender: Any) {
        
    }
}
