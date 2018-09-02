//
//  CompositionRoot.swift
//  Sparclers
//
//  Created by HyunWoo on 30/07/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import UIKit

import SnapKit

struct AppDependency {
    
    
    let window: UIWindow
    let configureSDKs: () -> Void
    let configureAppearance: () -> Void
    
    
}



final class CompositionRoot {
    static func resolve() -> AppDependency {
        
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        window.makeKeyAndVisible()

        var presentSparclerScreen: (() -> Void)!
        
        presentSparclerScreen = {
            let reactor = SparclerViewReactor()
            let navigtaionController = UINavigationController(rootViewController: SparclerViewController(reactor: reactor))
            window.rootViewController = navigtaionController
        }
        
        let reactor = SplashViewReactor()
        let splashViewController = SplashViewController(reactor: reactor, presentSparclerScreen: presentSparclerScreen)
        window.rootViewController = splashViewController
        
        
        return AppDependency(window: window,
                             configureSDKs: self.configureSDKs,
                             configureAppearance: self.configureAppearance)
    }
    
    static func configureSDKs() {

    }
    
    static func configureAppearance() {

    }

}
