//
//  UIView-Debug.swift
//  Sparklers
//
//  Created by HyunWoo-Kim on 2018. 9. 2..
//  Copyright © 2018년 HyunWoo. All rights reserved.
//

import UIKit

extension UIView {
    
    class func renderBorder(_ view : UIView) {
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.cyan.cgColor
        
        for v in view.subviews {
            UIView.renderBorder(v)
        }
        
        if view.layer.sublayers != nil {
            for l in view.layer.sublayers! {
                UIView.renderBorderLayer(l)
            }
        }
        
        
        
    }
    
    class func renderBorderLayer(_ layer : CALayer) {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.cyan.cgColor
        if layer.sublayers != nil {
            for l in layer.sublayers! {
                UIView.renderBorderLayer(l)
            }
        }
    }
    
    func start() {
        Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(layer_debug), userInfo: nil, repeats: true)
    }
    
    @objc func layer_debug() {
        for w in UIApplication.shared.windows {
            UIView.renderBorder(w)
        }
        
        
    }
    
    static let sharedInstance = UIView()
    
    class func Start() {
        sharedInstance.start()
    }
    
}
