//
//  KYDrawerController-StatusBar.swift
//  Sparklers
//
//  Created by HyunWoo on 22/11/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import Foundation
import KYDrawerController

extension KYDrawerController {
    open override var prefersStatusBarHidden: Bool {
        if self.mainViewController is UINavigationController {
            let nvc = self.mainViewController as! UINavigationController
            return nvc.visibleViewController?.prefersStatusBarHidden ?? false
            
        } else {
            return self.mainViewController.prefersStatusBarHidden
        }
        
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        
        if self.mainViewController is UINavigationController {
            let nvc = self.mainViewController as! UINavigationController
            return nvc.visibleViewController?.preferredStatusBarStyle ?? .lightContent
            
        } else {
            return self.mainViewController.preferredStatusBarStyle
        }
    }
}
