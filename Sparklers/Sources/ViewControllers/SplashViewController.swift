//
//  SplashViewController.swift
//  Sparklers
//
//  Created by HyunWoo-Kim on 2018. 9. 2..
//  Copyright © 2018년 HyunWoo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxViewController
import RxGesture
import ReactorKit



final class SplashViewController: BaseViewController, ReactorKit.View{
    
    
    private struct Metric {
        static let touchScreenHeight: CGFloat = 70.0
        static let squareLineViewWidth: CGFloat = 300.0// * SCREEN_RATIO
        static let logoLeftRight: CGFloat = 80.0
    }
    
    private struct Color {
        static let coverView = UIColor.color(red: 29, green: 34, blue: 83, alpha: 0.73)
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
        
    }
    
    private let logoImgView = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "splash_center_logo")
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
    
    private let presentSparklerScreen: () -> Void
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    init(
        reactor: SplashViewReactor,
        presentSparklerScreen: @escaping () -> Void
        ) {
        defer { self.reactor = reactor }
        self.presentSparklerScreen = presentSparklerScreen
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startCoverViewAnimation()
        self.startTouchScreenAnimation()
//        self.squareLineView.animationStart(timeInterval: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.gradientLayer.frame = self.appName.bounds
    }
    
    override func addViews() {
        self.view.addSubview(self.playerView)
        self.view.addSubview(self.coverView)
        self.coverView.addSubview(self.logoImgView)
//        self.coverView.addSubview(self.squareLineView)
//        self.coverView.addSubview(self.appName)
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
        
        self.logoImgView.snp.makeConstraints { (make) in
            make.left.equalTo(Metric.logoLeftRight)
            make.right.equalTo(-Metric.logoLeftRight)
            make.centerY.equalToSuperview().offset(-Metric.touchScreenHeight / 2.0)
        
            if let image = self.logoImgView.image {
                make.height.equalTo(self.logoImgView.snp.width).dividedBy(image.size.width/image.size.height)
            }
        }
        
//        self.squareLineView.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//            make.width.equalTo(Metric.squareLineViewWidth)
//            make.height.equalTo(self.squareLineView.snp.width)
//        }
//
//        self.appName.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//        }
        
        self.touchScreen.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-self.safeAreaInsets.bottom)
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
        
        self.view.rx.tapGesture()
            .when(.ended)
            .subscribe(onNext: {[weak self] (_) in
                guard let `self` = self else { return }
                self.presentSparklerScreen()
            })
            .disposed(by: self.disposeBag)
        
        
    }
    
    private func startCoverViewAnimation() {
        self.coverView.alpha = 0.0

        UIView.animate(withDuration: 1) {
            self.coverView.alpha = 1.0
        }
        self.logoImgView.alpha = 0.0

        UIView.animate(withDuration: 0.8, delay: 1.0,
                       options: UIViewAnimationOptions.curveEaseInOut,
                       animations: {
                        self.logoImgView.alpha = 1.0

        })
    }
    private func startTouchScreenAnimation() {
        UIView.animate(withDuration: 0.8,
                       delay: 1.5,
                       options: [.repeat, .autoreverse, .allowUserInteraction],
                       animations: {
                        self.touchScreen.alpha = 0.0
                        self.touchScreen.alpha = 1.0
        }, completion: nil)
    }
    

}
