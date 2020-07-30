//
//  LicenseViewController.swift
//  Sparklers
//
//  Created by HyunWoo on 22/11/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import Foundation
import UIKit

final class LicenseViewController : BaseViewController {
    
    
    private struct Metric {
        static let topButtonWidth: CGFloat = 44.0

    }
    
    
    private struct Color {
        static let background = UIColor.color(red: 29, green: 34, blue: 83)
        
    }
    
    
    private let backBtn = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "arrow_back"), for: .normal)
        $0.setImage(#imageLiteral(resourceName: "arrow_back"), for: .highlighted)
    }
    
    private let bottomLogo = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "splash_bottom_logo")
    }
    
    private let textView = UITextView().then {
        $0.backgroundColor = .clear
        $0.isEditable = false
        $0.isSelectable = false
        
        if let url = Bundle.main.url(forResource: "OpenSource", withExtension: "rtf") {
            
            let attrString = try! NSMutableAttributedString(url: url, options: [:], documentAttributes: nil)
            attrString.addAttributes([.foregroundColor: UIColor.white], range: NSRange(location: 0, length: attrString.length))
            $0.attributedText = attrString
        }
        
    }
    
    
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        self.view.backgroundColor = Color.background
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.backBtn.rx.tap
            .subscribe(onNext: { (_) in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
        
        
    }
    
    override func addViews() {
        super.addViews()
        self.view.addSubview(self.backBtn)
        self.view.addSubview(self.bottomLogo)
        self.view.addSubview(self.textView)

    }
    
    
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaInsets.top)
            make.left.equalToSuperview()
            make.width.equalTo(Metric.topButtonWidth)
            make.height.equalTo(self.backBtn.snp.width)
        }
        
 
        self.bottomLogo.snp.makeConstraints { (make) in
            
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(self.view.snp.width).multipliedBy(0.5)
            
            if let image = self.bottomLogo.image {
                make.height.equalTo(self.bottomLogo.snp.width).dividedBy(image.size.width/image.size.height)
            }
        }
        
        
        self.textView.snp.makeConstraints { (make) in
            make.top.equalTo(self.backBtn.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
  
    }


    
    
    
}
