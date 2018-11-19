//
//  Constants.swift
//  Sparklers
//
//  Created by HyunWoo-Kim on 2018. 9. 2..
//  Copyright © 2018년 HyunWoo. All rights reserved.
//

import UIKit


struct GoogleAdMobInfo {
    static let appId = "ca-app-pub-4718977625494132~6911275288"

    enum AdUnitId: String {
        #if DEBUG
        case selectColorPage = "ca-app-pub-3940256099942544/2934735716"
        case colorPicker = "ca-app-pub-3940256099942544/4411468910"
        #else
        case selectColorPage = "ca-app-pub-4718977625494132/6997113180"
        case colorPicker = "ca-app-pub-3940256099942544/4411468910"
        #endif
    }
}




public let SCREEN_SIZE = CGSize(width: UIScreen.main.nativeBounds.size.width / UIScreen.main.nativeScale,
                                height: UIScreen.main.nativeBounds.size.height / UIScreen.main.nativeScale)

public let SCREEN_RATIO =  SCREEN_SIZE.width / 320.0
