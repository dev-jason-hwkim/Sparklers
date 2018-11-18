//
//  UIImage-Tint.swift
//  Sparklers
//
//  Created by HyunWoo-Kim on 2018. 9. 16..
//  Copyright © 2018년 HyunWoo. All rights reserved.
//

import UIKit
import CoreImage
extension UIImage {
    func tint(color: UIColor) -> UIImage? {
        let ciImage = CIImage(image: self)
        guard let filter = CIFilter(name: "CIMultiplyCompositing") else { return self }
        
        guard let colorFilter = CIFilter(name: "CIConstantColorGenerator") else { return self }
        let ciColor = CIColor(color: color)
        colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
        
        let colorImage = colorFilter.outputImage
        
        filter.setValue(colorImage, forKey: kCIInputImageKey)
        filter.setValue(ciImage, forKey: kCIInputBackgroundImageKey)

        if let outputImage = filter.outputImage {
            return UIImage(ciImage: outputImage)
        }
        return self
    }
}
