//
//  InfoViewController.swift
//  Sparklers
//
//  Created by HyunWoo on 19/11/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import Foundation
import UIKit

final class InfoViewController: BaseViewController {
    
    
    
    private struct Metric {
        static let topButtonWidth: CGFloat = 44.0

        static let logoLeftRight: CGFloat = 60.0
        static let versionTop: CGFloat = 15.0
        static let copyrightBottom: CGFloat  = 5.0

    }
    
    
    private struct Color {
        static let background = UIColor.color(red: 29, green: 34, blue: 83)

    }
    
    private struct Font {
        static let version = UIFont.boldSystemFont(ofSize: 20)
        static let copyright = UIFont.systemFont(ofSize: 17)

    }
    
    private let backBtn = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "arrow_back"), for: .normal)
        $0.setImage(#imageLiteral(resourceName: "arrow_back"), for: .highlighted)
    }
    
    private let centerLogo = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "splash_center_logo")
    }
    
    private let version = UILabel().then {
        $0.textColor = .white
        $0.font = Font.version
        if let text = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String {
            $0.text = text
        }
        
    }
    
    
    private let copyright = UILabel().then {
        $0.textColor = .white
        $0.font = Font.copyright
        $0.text = "Copyright © 2018 - TravelPicTools"
    }
    
    
    private let bottomLogo = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "splash_bottom_logo")
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
        self.view.addSubview(self.centerLogo)
        self.view.addSubview(self.version)
        self.view.addSubview(self.bottomLogo)
        self.view.addSubview(self.copyright)

    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaInsets.top)
            make.left.equalToSuperview()
            make.width.equalTo(Metric.topButtonWidth)
            make.height.equalTo(self.backBtn.snp.width)
        }
        
        
        self.centerLogo.snp.makeConstraints { (make) in
            make.left.equalTo(Metric.logoLeftRight)
            make.right.equalTo(-Metric.logoLeftRight)
            make.centerY.equalToSuperview().offset(-(Metric.versionTop + 20)/2.0)
            if let image = self.centerLogo.image {
                make.height.equalTo(self.centerLogo.snp.width).dividedBy(image.size.width/image.size.height)
            }
        }
        
        self.version.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.centerLogo.snp.bottom).offset(Metric.versionTop)
        }
        
        self.bottomLogo.snp.makeConstraints { (make) in
            
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(self.view.snp.width).multipliedBy(0.5)

            if let image = self.bottomLogo.image {
                make.height.equalTo(self.bottomLogo.snp.width).dividedBy(image.size.width/image.size.height)
            }
        }
        
        self.copyright.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-safeAreaInsets.bottom)
        }
    }
}




