//
//  main.swift
//  Sparclers
//
//  Created by HyunWoo on 30/07/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import UIKit


private func appDelegateClassName() -> String {
    let isTesting = NSClassFromString("XCTestCase") != nil
    return isTesting ? "SparclersTests.StubAppDelegate" : NSStringFromClass(AppDelegate.self)
}

UIApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(
        to: UnsafeMutablePointer<Int8>.self,
        capacity: Int(CommandLine.argc)
    ),
    NSStringFromClass(UIApplication.self),
    appDelegateClassName()
)
