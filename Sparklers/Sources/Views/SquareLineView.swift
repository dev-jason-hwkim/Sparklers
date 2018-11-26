//
//  SquareLineView.swift
//  Sparklers
//
//  Created by HyunWoo-Kim on 2018. 9. 2..
//  Copyright © 2018년 HyunWoo. All rights reserved.
//

import UIKit
//import ValueAnimator
extension BinaryInteger {
    var degreesToRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}

final class SquareLineView: UIView {
    
    
    private var changeSize: CGFloat = 0.0
    
//    private var animator: ValueAnimator?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.setShouldAntialias(true)
        context?.setLineWidth(5.0)
        
        context?.move(to: CGPoint(x: 0.0, y: 0.0))
        context?.addLine(to: CGPoint(x: changeSize, y: 0))
        
        context?.move(to: CGPoint(x: self.bounds.width, y: 0.0))
        context?.addLine(to: CGPoint(x: self.bounds.width, y: changeSize))
        
        context?.move(to: CGPoint(x: self.bounds.width, y: self.bounds.width))
        context?.addLine(to: CGPoint(x: self.bounds.width - changeSize, y: self.bounds.width))
        
        context?.move(to: CGPoint(x: 0, y: self.bounds.width))
        context?.addLine(to: CGPoint(x:0 , y: self.bounds.width - changeSize))
        context?.strokePath()
        
    }
    
    func animationStart(timeInterval: TimeInterval)  {
        self.animationStop()
        
        
//        animator = ValueAnimator.animate("count", from: 0,
//                                         to: 1,
//                                         duration: timeInterval,
//                                         easing: EaseCircular.easeInOut(),
//                                         onChanged: { [weak self] (p, v) in
//                                            guard let `self` = self else { return }
//                                            self.changeSize = self.bounds.width * CGFloat(v.value)
//                                            self.setNeedsDisplay()
//        })
//
//
//        animator?.resume()
        
        UIView.animate(withDuration: timeInterval) {
            self.transform = CGAffineTransform(rotationAngle: 10.degreesToRadians)
        }
        
    }
    
    func animationStop() {
//        animator?.finish()
        self.layer.removeAllAnimations()
//        animator = nil
        self.changeSize = 0
    }
    

}
