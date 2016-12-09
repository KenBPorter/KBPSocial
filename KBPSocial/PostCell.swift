//
//  PostCell.swift
//  KBPSocial
//
//  Created by Ken Porter on 2016-12-09.
//  Copyright © 2016 Ken Porter. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    // @IBOutlets
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
