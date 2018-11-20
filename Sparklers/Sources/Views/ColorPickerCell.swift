//
//  ColorPickerCell.swift
//  Sparklers
//
//  Created by HyunWoo on 20/11/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import Foundation
import UIKit
import ReactorKit

final class ColorPickerCell: BaseCollectionViewCell, View {
    
    
    
    private struct Metric {
        static let colorViewWidth: CGFloat = 44.0
        static let colorViewHeight: CGFloat = 44.0
        
    }
    
    private struct Color  {
        static let colorView = UIColor.color(red: 65, green: 66, blue: 65)
    }
    
    private struct Font {
        static let name = UIFont.boldSystemFont(ofSize: 30)
    }
    
    private let colorView = UIView().then {
        $0.layer.cornerRadius = Metric.colorViewWidth/2
        $0.layer.borderWidth = 1.5
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private let check = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "check_white")
        $0.isHidden = true
    }

    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.check.isHidden = false
            } else {
                self.check.isHidden = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.colorView.addSubview(self.check)
        self.contentView.addSubview(self.colorView)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.colorView.frame = self.contentView.bounds
        self.check.sizeToFit()
        self.check.center = self.colorView.center
        
        
    }
    
    func bind(reactor: ColorPickerCellReactor) {

        reactor.state.map { $0.color }
            .subscribe(onNext: { [weak self] (color) in
                guard let `self` = self else { return }
                self.colorView.backgroundColor = color
            })
            .disposed(by: self.disposeBag)
        
        
    }
    
}
