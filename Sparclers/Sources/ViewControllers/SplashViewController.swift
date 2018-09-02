//
//  SplashViewController.swift
//  Sparclers
//
//  Created by HyunWoo-Kim on 2018. 9. 2..
//  Copyright © 2018년 HyunWoo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxViewController
import ReactorKit



final class SplashViewController: BaseViewController, ReactorKit.View{
    
    
    private struct Metric {
        static let touchScreenHeight: CGFloat = 70.0
        static let squareLineViewWidth: CGFloat = 300.0// * SCREEN_RATIO
    }
    
    private struct Color {
        static let coverView = UIColor.color(red: 255, green: 255, blue: 255, alpha: 0.4)
    }
    
    private struct Font {
        static let appName = UIFont.boldSystemFont(ofSize: 50)
        static let touchScreen = UIFont.boldSystemFont(ofSize: 20)
    }
    
    
    private let playerView = PlayerView().then {
        $0.backgroundColor = .black
        $0.playerLayer.videoGravity = .resizeAspectFill
    }
    
    private let coverView = UIView().then {
        $0.backgroundColor = Color.coverView
        $0.alpha = 0.0
    }
    
    private let squareLineView = SquareLineView().then {
        $0.backgroundColor = .clear
    }
    
    private let appName = UILabel().then {
        $0.font = Font.appName
        $0.textColor = .white
        $0.text = Bundle.main.infoDictionary![kCFBundleNameKey! as String] as? String
        

        
        
//        $0.layer.shadowColor = UIColor.red.cgColor
        $0.layer.shadowOffset = CGSize.zero
        $0.layer.shadowRadius = 3.0
        $0.layer.shadowOpacity = 0.5
        $0.layer.masksToBounds = false
        $0.layer.shouldRasterize = true
    }
    
    
    private let gradientLayer = CAGradientLayer().then {
        $0.colors = [UIColor.red.cgColor, UIColor.blue.cgColor, UIColor.green.cgColor]
        $0.startPoint = CGPoint(x: 0, y: 0.5)
        $0.endPoint = CGPoint(x: 1, y: 0.5)
    }

    private let touchScreen = UILabel().then {
        $0.font = Font.touchScreen
        $0.textColor = .white
        $0.text = "Touch Screen"
        $0.textAlignment = .center
        
    }
    
    private let presentSparclerScreen: () -> Void

    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    init(
        reactor: SplashViewReactor,
        presentSparclerScreen: @escaping () -> Void
        ) {
        defer { self.reactor = reactor }
        self.presentSparclerScreen = presentSparclerScreen
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startCoverViewAnimation()
        self.startTouchScreenAnimation()
        self.squareLineView.animationStart(timeInterval: 1)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientLayer.frame = self.appName.bounds
    }
    
    override func addViews() {
        self.view.addSubview(self.playerView)
        self.view.addSubview(self.coverView)
        self.coverView.addSubview(self.squareLineView)
        self.coverView.addSubview(self.appName)
//        self.appName.layer.addSublayer(self.gradientLayer)
        self.view.addSubview(self.touchScreen)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        self.playerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.coverView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.squareLineView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(Metric.squareLineViewWidth)
            make.height.equalTo(self.squareLineView.snp.width)
        }
        
        self.appName.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        self.touchScreen.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(self.safeAreaInsets.bottom)
            make.height.equalTo(Metric.touchScreenHeight)
        }
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        
    }
    
    
    func bind(reactor: SplashViewReactor) {
        self.playerView.playerLayer.player = reactor.currentState.player
        self.rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.rx.viewDidDisappear
            .map { _ in Reactor.Action.viewDidDisappear }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
    
    private func startCoverViewAnimation() {
        UIView.animate(withDuration: 1) {
            self.coverView.alpha = 1.0
        }
    }
    private func startTouchScreenAnimation() {
        UIView.animate(withDuration: 0.8,
                       delay: 1.0,
                       options: [.repeat, .autoreverse],
                       animations: {
                        self.touchScreen.alpha = 0.0
                        self.touchScreen.alpha = 1.0
        }, completion: nil)
    }
}