//
//  SparklerColorCell.swift
//  Sparklers
//
//  Created by HyunWoo on 03/09/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//


import RxSwift
import RxCocoa
import RxOptional

import ReactorKit

import ManualLayout

final class SparklerColorCell: BaseCollectionViewCell, View {
    private struct Metric {
        static let colorViewWidth: CGFloat = 44.0
        static let colorViewHeight: CGFloat = 44.0
        
    }
    
    private struct Color  {
        static let colorView = UIColor.color(red: 29, green: 34, blue: 83)
    }
    
    private struct Font {
        static let name = UIFont.boldSystemFont(ofSize: 30)
    }
    
    private let colorView = UIView().then {
        $0.backgroundColor = Color.colorView
        $0.layer.cornerRadius = Metric.colorViewWidth/2

        
    }
    
    private let name = UILabel().then {
        $0.backgroundColor = .clear
        $0.textAlignment = .center
        $0.font = Font.name
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.colorView.addSubview(self.name)
        self.contentView.addSubview(self.colorView)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.colorView.frame = self.contentView.bounds
        self.name.frame = self.colorView.bounds

    }
    
    func bind(reactor: SparklerColorCellReactor) {
        reactor.state
            .map { $0.color.name }
            .bind(to: self.name.rx.text)
            .disposed(by: self.disposeBag)
        
        
        reactor.state
            .map { $0.color.color }
            .subscribe(onNext: { [weak self] (color) in
                guard let `self` = self else { return }
                self.name.textColor = color
            })
            .disposed(by: self.disposeBag)
        
        
    }
    
}

