//
//  ColorPaletteView.swift
//  Sparklers
//
//  Created by HyunWoo on 17/09/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import UIKit


final class ColorPaletteView: UIView {

    
    private struct Metric {
        static let backgroundInset: CGFloat = 8.0
    }

    
    private let background = UIColor.color(red: 29, green: 34, blue: 83)
    
    
    
    override func draw(_ rect: CGRect) {

        let arcStep = 2 * CGFloat.pi / 360
        let x = rect.width / 2
        let y = rect.height / 2
        let radius = min(x, y) / 2
        
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(UIColor.red.cgColor)
        ctx?.setLineWidth(2 * radius)
        for i in 0..<360 {
            let color = UIColor(hue: CGFloat(360 - i)/360, saturation: 1, brightness: 1, alpha: 1)
            let startAngle = CGFloat(i) * arcStep
            let endAngle = startAngle + arcStep + 0.01
            ctx?.setStrokeColor(color.cgColor)
            ctx?.addArc(center: CGPoint(x: x, y: y), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            ctx?.strokePath()

        }
        
        
        ctx?.addEllipse(in: rect.insetBy(dx: Metric.backgroundInset, dy: Metric.backgroundInset))
        ctx?.setFillColor(background.cgColor)
        ctx?.fillPath()

    }
   
}




