//
//  BaseViewController.swift
//  money-manager
//
//  Created by developer on 13.04.2024.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addTapGestureToHideKeyboard()
    }
}
