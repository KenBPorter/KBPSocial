//
//  CustomUITextField.swift
//  KBPSocial
//
//  Created by Ken Porter on 2016-12-08.
//  Copyright © 2016 Ken Porter. All rights reserved.
//

import UIKit

class CustomUITextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.4).cgColor
        layer.borderWidth = 1.0
        
        layer.cornerRadius = 2.0
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
  
}





































