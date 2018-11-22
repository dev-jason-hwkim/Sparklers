//
//  CompositionRoot.swift
//  Sparklers
//
//  Created by HyunWoo on 30/07/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import UIKit
import CoreGraphics

import Firebase
import SnapKit

import KYDrawerController

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
            let sparklerViewController = SparklerViewController(reactor: reactor)
            let navigtaionController = UINavigationController(rootViewController: sparklerViewController)
            let rightViewController = RightViewController()
            rightViewController.delegate = sparklerViewController
            
            
            let drawerController = KYDrawerController(drawerDirection: .right, drawerWidth: SCREEN_SIZE.width / 2.0)
            drawerController.mainViewController = navigtaionController
            drawerController.drawerViewController = rightViewController
            drawerController.screenEdgePanGesture.isEnabled = false
            window.rootViewController = drawerController
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
