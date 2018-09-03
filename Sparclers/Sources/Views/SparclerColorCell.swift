//
//  SparclerColorCell.swift
//  Sparclers
//
//  Created by HyunWoo on 03/09/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//


import RxSwift
import RxCocoa

import ReactorKit

final class SparclerColorCell: BaseCollectionViewCell, View {
    private struct Metric {
        static let filterViewWidth: CGFloat = 44.0
        static let filterViewHeight: CGFloat = 44.0
        
    }
    
    private struct Color  {
        static let colorView = UIColor.color(red: 65, green: 66, blue: 65)
        
    }
    private let colorView = UIView().then {
        $0.backgroundColor = Color.colorView
        $0.layer.cornerRadius = Metric.filterViewWidth/2
        $0.layer.borderWidth = 3.0
        
    }
    
    private let name = UILabel().then {
        $0.backgroundColor = .clear
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.colorView.addSubview(self.name)
        self.contentView.addSubview(self.colorView)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.colorView.width = Metric.filterViewWidth
        self.colorView.height = Metric.filterViewHeight
        
        self.name.centerX = self.filterView.width / 2
        self.name.centerY = self.filterView.height / 2
    }
    
    func bind(reactor: SparclerColorCellReactor) {
        reactor.state
            .map { $0.color.name }
            .bind(to: self.name.rx.text)
            .disposed(by: self.disposeBag)
        
        
        reactor.state
            .map { $0.color.color }
            .subscribe(onNext: { [weak self] (color) in
                guard let `self` = self else { return }
                self.colorView.layer.borderColor = color.cgColor
            })
            .disposed(by: self.disposeBag)
        
        
    }
    
}

