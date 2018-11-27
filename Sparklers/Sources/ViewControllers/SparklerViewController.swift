//
//  SparklerViewController.swift
//  Sparklers
//
//  Created by HyunWoo on 03/09/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//


import CoreImage

import RxSwift
import RxCocoa
import RxDataSources

import ReactorKit
import ReusableKit

import GoogleMobileAds
import PersonalizedAdConsent
import KYDrawerController




final class SparklerViewController: BaseViewController, ReactorKit.View {
    
    
    private struct Metric {
        
        
        
        static let topButtonWidth: CGFloat = 44.0
        static let openMenuWidth: CGFloat = 35.0
        
        static let openMenuBottom: CGFloat = 10.0

        static let paletteLeft: CGFloat = 10.0

        static let lineHeight: CGFloat = 15.0
        static let colorListHeight: CGFloat = 60.0
        static let colorListItemSize: CGFloat = 44.0
        static let colorListItemSpacing: CGFloat = 10.0
        static let colorListSectioninset = UIEdgeInsetsMake(0, 10, 0, 10)
        
        
    }
    
    
    private struct Reusable {
        static let colorCell = ReusableCell<SparklerColorCell>()
        static let emptyView = ReusableView<UICollectionReusableView>()

    }
    
    private let backBtn = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "arrow_back"), for: .normal)
        $0.setImage(#imageLiteral(resourceName: "arrow_back"), for: .highlighted)
    }

    private let infoBtn = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "info"), for: .normal)
        $0.setImage(#imageLiteral(resourceName: "info"), for: .highlighted)
    }
    
    
    private let openMenuBtn = UIButton().then {
        $0.setBackgroundImage(#imageLiteral(resourceName: "ic_outline_up.pdf"), for: .normal)
        $0.setBackgroundImage(#imageLiteral(resourceName: "ic_outline_up.pdf"), for: .highlighted)
    }
    
    private let contentView = UIView().then {
        $0.backgroundColor = .black
        $0.isHidden = true
    }
    
    private let preview = UIImageView().then {
        $0.backgroundColor = .clear
    }
    
    private let colorView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let colorPaletteView = ColorPaletteView().then {
        $0.layer.cornerRadius = Metric.colorListItemSize / 2.0
        $0.clipsToBounds = true
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = .white
    }
    
    
    private let colorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        $0.alpha = 0.0
        
        let layout  = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        
        $0.register(Reusable.colorCell)
        $0.register(Reusable.emptyView, kind: "emptyView")
    }
    
    private let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait).then {
        $0.adUnitID = GoogleAdMobInfo.AdUnitId.selectColorPage.rawValue
    }
    
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<SparklerColorCollectionViewSection>(
        configureCell: { (datasource, collectionView, indexPath, sectionItem)  in
            switch sectionItem {
            case .setItem(let reactor):
                let cell = collectionView.dequeue(Reusable.colorCell, for: indexPath)
                cell.reactor = reactor
                return cell
            }
    },
        configureSupplementaryView: {  dataSource, collectionView, kind, indexPath in
            return collectionView.dequeue(Reusable.emptyView, kind: "empty", for: indexPath)
    }
    )
    

    override var prefersStatusBarHidden: Bool {
        if let reactor = self.reactor {
            if reactor.currentState.isShowMenu {
                return false
            } else {
                return true
            }
        }

        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private var interstitial: GADInterstitial!


    init(
        reactor: SparklerViewReactor
        ) {
        defer { self.reactor = reactor }
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        self.setupGARequest()
        
        if UserDefaults.isFirstLaunch() {
            let reactor = TutorialViewReactor(colorCellReactorFactory: SparklerColorCellReactor.init)
            self.navigationController?.pushViewController(TutorialViewController(reactor: reactor), animated: false)
            
        }
    }
    
    override func addViews() {
        super.addViews()
      
        self.view.addSubview(self.openMenuBtn)
        self.view.addSubview(self.contentView)
        
        self.contentView.addSubview(self.backBtn)
        self.contentView.addSubview(self.infoBtn)
        
        self.contentView.addSubview(self.preview)
        
        self.contentView.addSubview(self.colorView)
        self.colorView.addSubview(self.colorPaletteView)
        self.colorView.addSubview(self.lineView)
        self.colorView.addSubview(self.colorCollectionView)
        self.contentView.addSubview(self.bannerView)
        
        
        
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.openMenuBtn.snp.makeConstraints { (make) in
            if safeAreaInsets.bottom > 0 {
                make.bottom.equalTo(-safeAreaInsets.bottom)
            } else {
                make.bottom.equalTo(-safeAreaInsets.bottom - Metric.openMenuBottom)
            }
            make.width.equalTo(Metric.openMenuWidth)
            make.height.equalTo(self.openMenuBtn.snp.width)
            make.centerX.equalToSuperview()
        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        self.backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(Metric.topButtonWidth)
            make.height.equalTo(self.backBtn.snp.width)
        }
        
        
        self.infoBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.backBtn.snp.top)
            make.right.equalToSuperview()
            make.width.equalTo(Metric.topButtonWidth)
            make.height.equalTo(self.backBtn.snp.width)
        }
        
        self.preview.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.centerY.equalToSuperview().offset(-self.bannerView.frame.height / 2.0)
            if let image = self.preview.image {
                make.height.equalTo(self.preview.snp.width).dividedBy(image.size.width/image.size.height)
            }
        }
        
        self.colorView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(self.bannerView.snp.top)
            make.height.equalTo(Metric.colorListHeight)
        }
        
        self.colorPaletteView.snp.makeConstraints { (make) in
            make.left.equalTo(Metric.paletteLeft)
            make.bottom.equalTo(-(Metric.colorListHeight - Metric.colorListItemSize) / 2.0)
            make.width.equalTo(Metric.colorListItemSize)
            make.height.equalTo(Metric.colorListItemSize)
        }
        
        self.lineView.snp.makeConstraints { (make) in
            make.left.equalTo(self.colorPaletteView.snp.right).offset(Metric.colorListItemSpacing)
            make.centerY.equalTo(self.colorPaletteView.snp.centerY)
            make.width.equalTo(1.0)
            make.height.equalTo(Metric.lineHeight)
        }
        
        
        self.colorCollectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(self.lineView.snp.right)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.bannerView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-safeAreaInsets.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
 
    }
    

    func bind(reactor: SparklerViewReactor) {
        self.rx
            .viewDidLoad
            .map { Reactor.Action.loadColors }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        
        self.backBtn.rx
            .tap
            .map { Reactor.Action.hideMenu }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        
        self.infoBtn.rx
            .tap
            .subscribe(onNext: { [weak self] (_) in
                guard let`self` = self else { return }
                if let drawerController = self.navigationController?.parent as? KYDrawerController {
                    drawerController.setDrawerState(.opened, animated: true)
                }

            })
            .disposed(by: self.disposeBag)
        
        
        self.openMenuBtn.rx
            .tap
            .map { Reactor.Action.showMenu }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)


        
        
        self.colorPaletteView.rx
            .tapGesture()
            .when(.ended)
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
      
                if self.interstitial.isReady {
                    self.interstitial.present(fromRootViewController: self)
                }

                let alert = ColorPickerAlertView(currentColor: reactor.currentState.color)
                alert.delegate = self
                self.view.addSubview(alert)
                alert.snp.makeConstraints({ (make) in
                    make.edges.equalToSuperview()
                })
                
                self.setNeedsStatusBarAppearanceUpdate()
                
            })
            .disposed(by: self.disposeBag)
        
        self.colorCollectionView.rx.itemSelected(dataSource: self.dataSource)
            .map { (item) -> UIColor in
                switch item {
                case .setItem(let reactor):
                    return reactor.currentState.color.color
                }
            }
            .map { Reactor.Action.selectColor($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        
        
        self.colorCollectionView.rx.setDelegate(self).disposed(by: self.disposeBag)
        
        
        reactor.state
            .map { $0.isShowMenu }
            .filter({ [weak self] (_) -> Bool in
                guard let `self` = self else { return false }
                return self.isViewLoaded
            })
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] (isShowMenu) in
                guard let `self` = self else { return }
                if isShowMenu {
                    self.showMenu()
                } else {
                    self.hideMenu()
                }
            })
            .disposed(by: self.disposeBag)

        
        reactor.state
            .map { $0.isShowMenu }
            .distinctUntilChanged()
            .bind(to: self.openMenuBtn.rx.isHidden)
            .disposed(by: self.disposeBag)
        
   

        reactor.state
            .map { $0.image }
            .bind(to: self.preview.rx.image)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.color }
            .filter({ [weak self] (_) -> Bool in
                guard let `self` = self else { return false }
                return self.isViewLoaded
            })
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] (color) in
                guard let `self` = self else { return }
                self.view.backgroundColor = color
                
            })
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.sections }
            .bind(to: self.colorCollectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        
        
        
        
    }
    
    private func setupGARequest() {
        self.bannerView.rootViewController = self
        self.bannerView.delegate = self
        self.interstitial = self.createAndLoadInterstitial()
        let request = GADRequest()

        if PACConsentInformation.sharedInstance.consentStatus == .nonPersonalized {
            let extras = GADExtras()
            extras.additionalParameters = ["npa": "1"]
            request.register(extras)
        }

        self.bannerView.load(request)
    }
    
    private func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: GoogleAdMobInfo.AdUnitId.colorSelectAction.rawValue)
        interstitial.delegate = self
        let request = GADRequest()
        
        if PACConsentInformation.sharedInstance.consentStatus == .nonPersonalized {
            let extras = GADExtras()
            extras.additionalParameters = ["npa": "1"]
            request.register(extras)
        }
        interstitial.load(request)
        return interstitial
    }
    
    private func showMenu() {
        self.contentView.isHidden = false
        self.colorCollectionView.alpha = 0.0
        self.contentView.alpha = 0.0
        self.colorPaletteView.alpha = 0
        self.lineView.alpha = 0

        self.setNeedsStatusBarAppearanceUpdate()

        

        UIView.animate(withDuration: 0.25, animations: {
            self.contentView.alpha = 1.0
        }) { [weak self](_) in
            guard let `self` = self else { return }
            self.showColorSelectAnimation()
        }
      
    }
    
    private func hideMenu() {
        self.contentView.alpha = 1.0
        self.setNeedsStatusBarAppearanceUpdate()

        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.alpha = 0.0
        }) { (_) in
            self.contentView.isHidden = true
        }
        logger.verbose("hideMenu")


    }
    
    private func showColorSelectAnimation() {
        self.colorCollectionView.alpha = 1.0

        let indexs = self.colorCollectionView.indexPathsForVisibleItems.map { $0.item }.sorted()
        let start = indexs.first ?? 0
        let end = indexs.last ?? 0
        
        
        self.colorPaletteView.transform = CGAffineTransform(translationX: 0, y: Metric.colorListHeight)
        self.colorPaletteView.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.05,
                       delay: 0.0,
                       options: [],
                       animations: {
                        self.lineView.alpha = 1
                        self.colorPaletteView.alpha = 1
                        self.colorPaletteView.transform = CGAffineTransform(translationX: 0, y: 0)
                        
        })
        
        
        for index in start..<end + 1 {
            let cell = self.colorCollectionView.cellForItem(at: IndexPath(item: index, section: 0))
            cell?.transform = CGAffineTransform(translationX: 0, y: Metric.colorListHeight)
            cell?.alpha = 0
            cell?.layer.removeAllAnimations()
            UIView.animate(withDuration: 0.05,
                           delay: TimeInterval(index - start + 1) * 0.02,
                           options: [],
                           animations: {
                            cell?.alpha = 1
                            cell?.transform = CGAffineTransform(translationX: 0, y: 0)
                            
            })
            
        }
    }
    
}
extension SparklerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Metric.colorListItemSize, height: Metric.colorListItemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Metric.colorListItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Metric.colorListSectioninset
    }
    
}
extension SparklerViewController: GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        logger.verbose("adViewDidReceiveAd")
    }
    
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        logger.verbose("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        logger.verbose("adViewWillPresentScreen")
    }
    
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        logger.verbose("adViewWillDismissScreen")
    }
    
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        logger.verbose("adViewDidDismissScreen")
    }
    
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        logger.verbose("adViewWillLeaveApplication")
    }
}


extension SparklerViewController: GADInterstitialDelegate {

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        logger.verbose("interstitialDidDismissScreen")
        interstitial = createAndLoadInterstitial()
        
        self.setNeedsStatusBarAppearanceUpdate()

    }
   
}


extension SparklerViewController : RightViewProtocol {
    func infoTouched() {
        self.navigationController?.pushViewController(InfoViewController(), animated: true)
    }
    
    func tutorialTouched() {
        let reactor = TutorialViewReactor(colorCellReactorFactory: SparklerColorCellReactor.init)
        self.navigationController?.pushViewController(TutorialViewController(reactor: reactor), animated: true)
    }
    
    func licensesTouched() {
        self.navigationController?.pushViewController(LicenseViewController(), animated: true)

    }
}

extension SparklerViewController: ColorPickerAlertViewProtocl {
    func selectColor(color: Color) {
        reactor?.action.onNext(.appendColor(color))
    }
}
