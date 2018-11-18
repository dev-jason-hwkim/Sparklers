//
//  TestConfiguration.swift
//  SparklersTests
//
//  Created by HyunWoo on 31/07/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import QuickLook
import Stubber


@testable import Sparklers
class TestConfiguration: QuickConfiguration {
    override class func configure(_ configuration: Configuration) {
        configuration.beforeEach {
            Stubber.clear()
            UIApplication.shared.delegate = StubAppDelegate()
        }
        
        configuration.afterEach {
            Stubber.clear()
        }
    }
}

