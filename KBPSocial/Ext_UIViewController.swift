//
//  Ext_UIViewController.swift
//  KBPSocial
//
//  Created by Ken Porter on 2016-12-10.
//  Copyright © 2016 Ken Porter. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
