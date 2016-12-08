//
//  CustomUIView.swift
//  KBPSocial
//
//  Created by Ken Porter on 2016-12-08.
//  Copyright © 2016 Ken Porter. All rights reserved.
//

import UIKit

class CustomUIView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // add a drop shadow to the UIView
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.8).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
    }

}
