//
//  BrightnessView.swift
//  Sparklers
//
//  Created by HyunWoo on 20/11/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//


import UIKit

protocol BrightnessViewDelegate: class {
    func brightnessSelected(_ brightness: CGFloat)
}

final class BrightnessView: UIView {
    
    weak var delegate: BrightnessViewDelegate?
    
    var colorLayer: CAGradientLayer!
    
    var point: CGPoint!
    var indicator = CAShapeLayer()
    var indicatorColor: CGColor = UIColor.lightGray.cgColor
    var indicatorBorderWidth: CGFloat = 2.0
    
    init() {
        super.init(frame: .zero)
        
        // Init the point at the correct position
        
        // Clear the background
        backgroundColor = UIColor.clear
        
        // Create a gradient layer that goes from black to white
        // Create a gradient layer that goes from black to white
      
        colorLayer = CAGradientLayer()
        colorLayer.colors = [
            UIColor.black.cgColor,
            UIColor.white.cgColor
        ]
        colorLayer.locations = [0.0, 1.0]
        colorLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        colorLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        colorLayer.frame = CGRect(x: 2, y: 0, width: 24, height: self.frame.size.height)
        // Insert the colorLayer into this views layer as a sublayer
        self.layer.insertSublayer(colorLayer, below: layer)
        
        // Add the indicator
        indicator.strokeColor = indicatorColor
        indicator.fillColor = indicatorColor
        indicator.lineWidth = indicatorBorderWidth
        self.layer.addSublayer(indicator)
        
        drawIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        colorLayer.frame = CGRect(x: 2, y: 0, width: 24, height: self.frame.size.height)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchHandler(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchHandler(touches)
    }
    
    func touchHandler(_ touches: Set<UITouch>) {
        // Set reference to the location of the touchesMoved in member point
        if let touch = touches.first {
            point = touch.location(in: self)
        }
        
        point.x = self.frame.width/2
        point.y = getYCoordinate(point.y)
        // Notify delegate of the new brightness
        delegate?.brightnessSelected(getBrightnessFromPoint())
        
        drawIndicator()
    }
    
    func getYCoordinate(_ coord: CGFloat) -> CGFloat {
        // Offset the x coordinate to fit the view
        if (coord < 1) {
            return 1
        }
        if (coord > frame.size.height - 1 ) {
            return frame.size.height - 1
        }
        return coord
    }
    
    func drawIndicator() {
        // Draw the indicator
        if (point != nil) {
            indicator.path = UIBezierPath(roundedRect: CGRect(x: 0 , y: point.y-3, width: 28, height: 6), cornerRadius: 3).cgPath
        }
    }
    
    func getBrightnessFromPoint() -> CGFloat {
        // Get the brightness value for a given point
        return point.y/self.frame.height
    }
    
    func getPointFromColor(_ color: UIColor) -> CGPoint {
        // Update the indicator position for a given color
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        let ok: Bool = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        if (!ok) {
            print("SwiftHSVColorPicker: exception <The color provided to SwiftHSVColorPicker is not convertible to HSV>")
        }
        
        logger.verbose(self.frame.size)
        return CGPoint(x: frame.width/2.0, y: brightness * frame.height)
    }
    
    func setViewColor(_ color: UIColor!) {
        // Update the Gradient Layer with a given color
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        let ok: Bool = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        if (!ok) {
            print("SwiftHSVColorPicker: exception <The color provided to SwiftHSVColorPicker is not convertible to HSV>")
        }
        colorLayer.colors = [
            UIColor.black.cgColor,
            UIColor(hue: hue, saturation: saturation, brightness: 1, alpha: 1).cgColor
        ]
        

        self.point = self.getPointFromColor(color)
        drawIndicator()

    }
}

