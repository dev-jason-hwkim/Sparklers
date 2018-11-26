//
//  UserDefaults-isFirstLaunch.swift
//  Sparklers
//
//  Created by HyunWoo on 26/11/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import Foundation
extension UserDefaults {
    // check for is first launch - only true on first invocation after app install, false on all further invocations
    // Note: Store this value in AppDelegate if you have multiple places where you are checking for this flag
    static func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = UserDefaultsKey.isFirstLaunching
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if (isFirstLaunch) {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}
