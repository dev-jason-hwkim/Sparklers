//
//  AppDelegate.swift
//  Sparklers
//
//  Created by HyunWoo on 30/07/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import UIKit



final class AppDelegate: UIResponder, UIApplicationDelegate{
    
    // MARK: Properties
    
    var dependency: AppDependency!
    
    
    // MARK: UI
    
    var window: UIWindow?
    
    
    // MARK: UIApplicationDelegate
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
        ) -> Bool {
        
        #if DEBUG
        UIView.Start()
        #endif
        self.dependency = self.dependency ?? CompositionRoot.resolve()
        self.dependency.configureSDKs()
        self.dependency.configureAppearance()
        self.window = self.dependency.window
        
        return true
    }
}
