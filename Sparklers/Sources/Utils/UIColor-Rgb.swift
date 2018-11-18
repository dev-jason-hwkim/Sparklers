//
//  UIColor-Rgb.swift
//  Sparklers
//
//  Created by HyunWoo-Kim on 2018. 9. 2..
//  Copyright © 2018년 HyunWoo. All rights reserved.
//

import UIKit
extension UIColor {
    
    
    class func color(red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat = 1.0) -> UIColor {
        let r:CGFloat = red/255.0
        let g:CGFloat = green/255.0
        let b:CGFloat = blue/255.0
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}
