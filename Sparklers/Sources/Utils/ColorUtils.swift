//
//  ColorUtils.swift
//  Sparklers
//
//  Created by HyunWoo on 20/11/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//


import UIKit

// Typealias for RGB color values
typealias RGB = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)

// Typealias for HSV color values
typealias HSV = (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)
final class ColorUtils {
    static func hsv2rgb(_ hsv: HSV) -> RGB {
        // Converts HSV to a RGB color
        var rgb: RGB = (red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        var r: CGFloat
        var g: CGFloat
        var b: CGFloat
        
        let i = Int(hsv.hue * 6)
        let f = hsv.hue * 6 - CGFloat(i)
        let p = hsv.brightness * (1 - hsv.saturation)
        let q = hsv.brightness * (1 - f * hsv.saturation)
        let t = hsv.brightness * (1 - (1 - f) * hsv.saturation)
        switch (i % 6) {
        case 0: r = hsv.brightness; g = t; b = p; break;
            
        case 1: r = q; g = hsv.brightness; b = p; break;
            
        case 2: r = p; g = hsv.brightness; b = t; break;
            
        case 3: r = p; g = q; b = hsv.brightness; break;
            
        case 4: r = t; g = p; b = hsv.brightness; break;
            
        case 5: r = hsv.brightness; g = p; b = q; break;
            
        default: r = hsv.brightness; g = t; b = p;
        }
        
        rgb.red = r
        rgb.green = g
        rgb.blue = b
        rgb.alpha = hsv.alpha
        return rgb
    }
    
    static func rgb2hsv(_ rgb: RGB) -> HSV {
        // Converts RGB to a HSV color
        var hsb: HSV = (hue: 0.0, saturation: 0.0, brightness: 0.0, alpha: 0.0)
        
        let rd: CGFloat = rgb.red
        let gd: CGFloat = rgb.green
        let bd: CGFloat = rgb.blue
        
        let maxV: CGFloat = max(rd, max(gd, bd))
        let minV: CGFloat = min(rd, min(gd, bd))
        var h: CGFloat = 0
        var s: CGFloat = 0
        let b: CGFloat = maxV
        
        let d: CGFloat = maxV - minV
        
        s = maxV == 0 ? 0 : d / minV;
        
        if (maxV == minV) {
            h = 0
        } else {
            if (maxV == rd) {
                h = (gd - bd) / d + (gd < bd ? 6 : 0)
            } else if (maxV == gd) {
                h = (bd - rd) / d + 2
            } else if (maxV == bd) {
                h = (rd - gd) / d + 4
            }
            
            h /= 6;
        }
        
        hsb.hue = h
        hsb.saturation = s
        hsb.brightness = b
        hsb.alpha = rgb.alpha
        return hsb
    }
    
    
    static func calculateLuminance(color: UIColor) -> CGFloat {
        var colors: [CGFloat] {
            let comps = color.cgColor.components!
            if comps.count == 4 { return comps }
            return [comps[0], comps[0], comps[0], comps[1]]
        }
        let red = colors[0] < 0.03928 ? colors[0] / 12.92 : pow((colors[0] + 0.055) / 1.055, 2.4)
        let green = colors[1] < 0.03928 ? colors[1] / 12.92 : pow((colors[1] + 0.055) / 1.055, 2.4)
        let blue = colors[2] < 0.03928 ? colors[2] / 12.92 : pow((colors[2] + 0.055) / 1.055, 2.4)
        
        return (0.2126 * red) + (0.7152 * green) + (0.0722 * blue)
    }
}
