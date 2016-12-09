//
//  CustomCircleView.swift
//  KBPSocial
//
//  Created by Ken Porter on 2016-12-09.
//  Copyright © 2016 Ken Porter. All rights reserved.
//

import UIKit

class CustomCircleView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
    }
}
