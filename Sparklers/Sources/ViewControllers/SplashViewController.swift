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
import PersonalizedAdConsent



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
    
    
    private enum LoadState {
        case not_require
        case loading
        case loaded
        case error
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
    
    private var form: PACConsentForm?
   
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var loadState = LoadState.not_require
    
    
    init(
        reactor: SplashViewReactor,
        presentSparklerScreen: @escaping () -> Void
        ) {
        defer { self.reactor = reactor }
        self.presentSparklerScreen = presentSparklerScreen
        super.init()
        
        form = self.getConsentsForm()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        
        
        self.startCoverViewAnimation()
        self.startTouchScreenAnimation()
  
        
        self.consentStatusLog()
        
        if UserDefaults.isCheckGDPR == false {
            self.touchScreen.text = "Please wait..."
            self.consentAdCheck()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func addViews() {
        self.view.addSubview(self.playerView)
        self.view.addSubview(self.coverView)
        self.coverView.addSubview(self.logoImgView)

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
                
                // TO DO: 개인화 광고 잠시 중단
                let information = PACConsentInformation.sharedInstance
                if information.isRequestLocationInEEAOrUnknown
                    && information.consentStatus == .unknown {
                    self.openConsentPopup()
                } else {
                    
                    self.presentSparklerScreen()
                }
                
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
                       options: UIView.AnimationOptions.curveEaseInOut,
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

    
    private func getConsentsForm() -> PACConsentForm? {
        guard let privacyUrl = URL(string: GoogleAdMobInfo.privacyUrl),
            let form = PACConsentForm(applicationPrivacyPolicyURL: privacyUrl) else {
                logger.error("incorrect privacy URL.")
                return nil
        }
        form.shouldOfferPersonalizedAds = true
        form.shouldOfferNonPersonalizedAds = true
        form.shouldOfferAdFree = true
        
        return form
    }
    
    private func consentAdCheck() {
        PACConsentInformation.sharedInstance.consentStatus = PACConsentStatus.unknown

        PACConsentInformation.sharedInstance.requestConsentInfoUpdate(
        forPublisherIdentifiers: [GoogleAdMobInfo.publishId]) { [weak self] (error) in
            guard let `self` = self else { return }
            if let error = error {
                self.touchScreen.text = "Touch Screen"
                PACConsentInformation.sharedInstance.consentStatus = .unknown
                logger.error(error)
            } else  {
                self.consentStatusLog()
                
                if PACConsentInformation.sharedInstance.isRequestLocationInEEAOrUnknown {
                    self.loadState = .loading
                    self.loadConsentForm()
                } else {
                    self.touchScreen.text = "Touch Screen"
                    PACConsentInformation.sharedInstance.consentStatus = .personalized
                }
                
                
                
                
                UserDefaults.isCheckGDPR = true
            }
        }
     
    }
    
    
    
    
    private func loadConsentForm() {
        form?.load(completionHandler: { (error) in
            if let error = error {
                self.loadState = .error
            }  else {
                self.loadState = .loaded
                self.touchScreen.text = "Touch Screen"
            }
        })
    }
    
    private func openConsentPopup() {
        switch self.loadState {
        case .error:
            self.presentSparklerScreen()
        case .loaded:
            self.presentConsentForm()
        default:
            break
            
        }
    }
    
    private func presentConsentForm() {
        form?.present(from: self) { (error, userPrefersAdFree) in
            
            if let error = error {
                logger.error(error)
            } else if userPrefersAdFree {
                self.presentSparklerScreen()
            } else {

            }
        }
    }

    
    private func consentStatusLog() {
        switch PACConsentInformation.sharedInstance.consentStatus {
        case .unknown:
            logger.verbose("unknown")
        case .nonPersonalized:
            logger.verbose("nonPersonalized")
        case .personalized:
            logger.verbose("personalized")
        @unknown default:
            fatalError()
        }
    }
}
