//
//  CompositionRoot.swift
//  Sparklers
//
//  Created by HyunWoo on 30/07/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import UIKit
import Firebase
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

        var presentSparklerScreen: (() -> Void)!
        
        presentSparklerScreen = {
            let reactor = SparklerViewReactor(colorCellReactorFactory: SparklerColorCellReactor.init)
            let navigtaionController = UINavigationController(rootViewController: SparklerViewController(reactor: reactor))
            window.rootViewController = navigtaionController
        }
        
        let reactor = SplashViewReactor()
        let splashViewController = SplashViewController(reactor: reactor, presentSparklerScreen: presentSparklerScreen)
        window.rootViewController = splashViewController
        
        
        return AppDependency(window: window,
                             configureSDKs: self.configureSDKs,
                             configureAppearance: self.configureAppearance)
    }
    
    static func configureSDKs() {
        FirebaseApp.configure()
        GADMobileAds.configure(withApplicationID: GoogleAdMobInfo.appId)
        


    }
    
    static func configureAppearance() {

    }

}