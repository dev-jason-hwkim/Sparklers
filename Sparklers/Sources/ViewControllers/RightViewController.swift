//
//  RightViewController.swift
//  Sparklers
//
//  Created by HyunWoo on 19/11/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import Foundation

import UIKit
import KYDrawerController


protocol RightViewProtocol: class {
    func infoTouched()
    func tutorialTouched()
    func licensesTouched()
}

final class RightViewController: BaseViewController {
    
    private struct Metric {
        static let menuHeight: CGFloat = 44.0
    }

    
    private struct Color {
        static let background = UIColor.color(red: 29, green: 34, blue: 83)
        
    }
    
    
    private let info = UIButton().then {
        $0.setTitle(NSLocalizedString("menu_info", comment: "Information"), for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    
    private let tutorial = UIButton().then {
        $0.setTitle(NSLocalizedString("menu_tuto", comment: "Tutorial"), for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    
    private let licenses = UIButton().then {
        $0.setTitle(NSLocalizedString("menu_licenses", comment: "Licenses"), for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }

    weak var delegate: RightViewProtocol?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.background
        
        
        self.info.rx
            .tap
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                self.closeNavigationDrawer(completion: { () in
                    self.delegate?.infoTouched()

                })
                

            })
            .disposed(by: self.disposeBag)
        
        self.tutorial.rx
            .tap
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                self.closeNavigationDrawer(completion: { () in
                    self.delegate?.tutorialTouched()

                })
            })
            .disposed(by: self.disposeBag)
        
        
        self.licenses.rx
            .tap
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                self.closeNavigationDrawer(completion: { () in
                    self.delegate?.licensesTouched()

                })
            })
            .disposed(by: self.disposeBag)
        
    }
    
    override func addViews() {
        super.addViews()
        
        self.view.addSubview(self.info)
        self.view.addSubview(self.tutorial)
        self.view.addSubview(self.licenses)
    }
    
    override func setupConstraints() {
        self.info.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(self.tutorial.snp.top)
            make.height.equalTo(Metric.menuHeight)
        }
        
        self.tutorial.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(Metric.menuHeight)
        }
        
        self.licenses.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.tutorial.snp.bottom)
            make.height.equalTo(Metric.menuHeight)
        }
    }
    
    
}


extension RightViewController {
    private func closeNavigationDrawer(completion: (() -> Void)? = nil) {
        if let drawerController = parent as? KYDrawerController {
            drawerController.setDrawerState(.closed, animated: true)
        }
     
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
            if let completion = completion {
                completion()
            }
        }
    }
}


