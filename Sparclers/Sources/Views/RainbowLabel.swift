//
//  RainbowLabel.swift
//  Sparclers
//
//  Created by HyunWoo on 04/09/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

final class RainbowLabel:UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(1)
        context?.setLineJoin(.round)
        context?.setTextDrawingMode(.stroke)
        self.textColor = UIColor(patternImage: self.gradientImage(bounds: rect))
        super.drawText(in: rect)
    }
    
    private func gradientImage(bounds:CGRect) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor, UIColor.green.cgColor]
        gradientLayer.bounds = bounds
        UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, true, 0.0)
        let context = UIGraphicsGetCurrentContext()
        gradientLayer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

