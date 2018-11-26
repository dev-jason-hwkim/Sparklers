//
//  UserDefaults-isCheckGADR.swift
//  Sparklers
//
//  Created by HyunWoo on 26/11/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import Foundation
extension UserDefaults {
    // check for is first launch - only true on first invocation after app install, false on all further invocations
    // Note: Store this value in AppDelegate if you have multiple places where you are checking for this flag
    
    
    static var isCheckGDPR: Bool  {
        set(newValue) {
            let isCheckGDPRFlag = UserDefaultsKey.isCheckGDPR
            UserDefaults.standard.set(newValue, forKey: isCheckGDPRFlag)
        }
        get {
            let isCheckGDPRFlag = UserDefaultsKey.isCheckGDPR
            let isCheckGDPR = UserDefaults.standard.bool(forKey: isCheckGDPRFlag)
            return isCheckGDPR
        }
    }
    
    
}
