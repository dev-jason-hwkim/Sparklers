//
//  CompositionRoot.swift
//  Sparclers
//
//  Created by HyunWoo on 30/07/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import UIKit


struct AppDependency {
    
    
    let window: UIWindow
    let configureSDKs: () -> Void
    let configureAppearance: () -> Void
    
    
}



final class CompositionRoot {
    static func resolve() -> AppDependency {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        
        window.rootViewController = BaseViewController()
        window.makeKeyAndVisible()
        
        
        
        return AppDependency(window: window,
                             configureSDKs: self.configureSDKs,
                             configureAppearance: self.configureAppearance)
    }
    
    static func configureSDKs() {

    }
    
    static func configureAppearance() {

    }

}
