//
//  HSVColorView.swift
//  Sparklers
//
//  Created by HyunWoo on 20/11/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import Foundation
import UIKit
protocol HSVColorViewProtocol :class {
    func selectColor(color:UIColor)
}
final class HSVColorView:  UIView {
    
    
    private struct Metric {
        static let colorWheelSize: CGFloat = 206.0
        static let brightnessViewHeight: CGFloat = 26.0
    }
    
    
    
    private let colorWheel = ColorWheel()
    
    private let brightnessView = BrightnessView()
    
    private var color: UIColor = .clear
    private var hue: CGFloat = 1.0
    private var saturation: CGFloat = 1.0
    private var brightness: CGFloat = 1.0
    
    var delegate: HSVColorViewProtocol?
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.clear
        
        self.colorWheel.delegate = self
        self.brightnessView.delegate = self
        
        self.addSubview(self.colorWheel)
        self.addSubview(self.brightnessView)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.colorWheel.top = 0
        self.colorWheel.left = 0
        self.colorWheel.width = self.frame.height
        self.colorWheel.height = self.frame.height
        
        self.brightnessView.centerY = self.frame.size.height / 2.0
        self.brightnessView.centerX = self.colorWheel.right2 + (self.frame.width - self.colorWheel.frame.width) / 2.0
        self.brightnessView.width = 26
        self.brightnessView.height = Metric.colorWheelSize
        
    }
    
    func setViewColor(_ color: UIColor) {
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        let ok: Bool = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        if (!ok) {
            print("SwiftHSVColorPicker: exception <The color provided to SwiftHSVColorPicker is not convertible to HSV>")
        }
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.color = color
        colorWheel.setViewColor(self.color)
        brightnessView.setViewColor(self.color)

    }
    
    func getColor() -> UIColor {
        return self.color
    }
    
}

extension HSVColorView: ColorWheelDelegate {
    func hueAndSaturationSelected(_ hue: CGFloat, saturation: CGFloat) {
        self.hue = hue
        self.saturation = saturation
        self.color = UIColor(hue: self.hue, saturation: self.saturation, brightness: self.brightness, alpha: 1.0)
        brightnessView.setViewColor(self.color)
        self.delegate?.selectColor(color: self.color)
    }
    
}

extension HSVColorView: BrightnessViewDelegate {
    func brightnessSelected(_ brightness: CGFloat) {
        self.brightness = brightness
        self.color = UIColor(hue: self.hue, saturation: self.saturation, brightness: self.brightness, alpha: 1.0)
        colorWheel.setViewBrightness(brightness)
        self.delegate?.selectColor(color: self.color)
    }
}

