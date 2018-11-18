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

import MaterialComponents.MaterialNavigationDrawer





final class SparklerViewController: BaseViewController, ReactorKit.View {
    
    
    private struct Metric {
        
        
        static let paletteLeft: CGFloat = 10.0
        
        static let topButtonWidth: CGFloat = 44.0
        static let buttonWidth: CGFloat = 35.0
        
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
    
    private let imgView = UIImageView().then {
        $0.backgroundColor = .clear
    }
    
    private let paletteView = ColorPaletteView().then {
        $0.layer.cornerRadius = Metric.colorListItemSize / 2.0
        $0.clipsToBounds = true
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = .white
    }
    
    
    private let colorList = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        
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
            logger.verbose(reactor.currentState.isShowMenu)
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
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.isNavigationBarHidden = true

        self.setupGARequest()
    }
    
    override func addViews() {
        super.addViews()
      
        
        
        
        
        self.view.addSubview(self.openMenuBtn)
        self.view.addSubview(self.contentView)
        
        
        self.contentView.addSubview(self.backBtn)
        self.contentView.addSubview(self.infoBtn)
        
        self.contentView.addSubview(self.imgView)
        self.contentView.addSubview(self.paletteView)
        self.contentView.addSubview(self.lineView)
        self.contentView.addSubview(self.colorList)
        self.contentView.addSubview(self.bannerView)
        
        
        
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.openMenuBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(-safeAreaInsets.bottom)
            make.width.equalTo(Metric.buttonWidth)
            make.height.equalTo(self.openMenuBtn.snp.width)
            make.centerX.equalToSuperview()
        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        self.backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaInsets.top)
            make.left.equalToSuperview()
            make.width.equalTo(Metric.topButtonWidth)
            make.height.equalTo(self.backBtn.snp.width)
        }
        
        
        self.infoBtn.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaInsets.top)
            make.right.equalToSuperview()
            make.width.equalTo(Metric.topButtonWidth)
            make.height.equalTo(self.backBtn.snp.width)
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            if let image = self.imgView.image {
                make.height.equalTo(self.imgView.snp.width).dividedBy(image.size.width/image.size.height)
            }
        }
        
        self.paletteView.snp.makeConstraints { (make) in
            make.left.equalTo(Metric.paletteLeft)
            make.bottom.equalTo(self.bannerView.snp.top).offset(-(Metric.colorListHeight - Metric.colorListItemSize) / 2.0)
            make.width.equalTo(Metric.colorListItemSize)
            make.height.equalTo(Metric.colorListItemSize)
        }
        
        self.lineView.snp.makeConstraints { (make) in
            make.left.equalTo(self.paletteView.snp.right).offset(Metric.colorListItemSpacing)
            make.centerY.equalTo(self.paletteView.snp.centerY)
            make.width.equalTo(1.0)
            make.height.equalTo(Metric.lineHeight)
        }
        
        
        self.colorList.snp.makeConstraints { (make) in
            make.left.equalTo(self.lineView.snp.right)
            make.right.equalToSuperview()
            make.bottom.equalTo(self.bannerView.snp.top)
            make.height.equalTo(Metric.colorListHeight)
        }
        
        self.bannerView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-safeAreaInsets.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
 
    }
    

    func bind(reactor: SparklerViewReactor) {
        self.rx.viewDidLoad
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
            .subscribe(onNext: { (_) in
  
                logger.verbose(self.backBtn.frame)
            })
            .disposed(by: self.disposeBag)
        
        
        self.openMenuBtn.rx
            .tap
            .map { Reactor.Action.showMenu }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)


        
        
        self.paletteView.rx
            .tapGesture()
            .when(.ended)
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
      
                if self.interstitial.isReady {
                    self.interstitial.present(fromRootViewController: self)
                }
            })
            .disposed(by: self.disposeBag)
        
        self.colorList.rx.itemSelected(dataSource: self.dataSource)
            .map { (item) -> UIColor in
                switch item {
                case .setItem(let reactor):
                    return reactor.currentState.color.color
                }
            }
            .map { Reactor.Action.selectColor($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        
        
        self.colorList.rx.setDelegate(self).disposed(by: self.disposeBag)
        
        
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
            .bind(to: self.imgView.rx.image)
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
            .bind(to: self.colorList.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        
        
        
        
    }
    
    private func setupGARequest() {
        self.bannerView.rootViewController = self
        self.bannerView.delegate = self
        self.interstitial = self.createAndLoadInterstitial()
        let request = GADRequest()
        self.bannerView.load(request)
    }
    
    private func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: GoogleAdMobInfo.AdUnitId.selectColorPage.rawValue)
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    private func showMenu() {
        self.contentView.isHidden = false
        self.contentView.alpha = 0.0
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.alpha = 1.0
        }) { (_) in
            self.setNeedsStatusBarAppearanceUpdate()

        }

        logger.verbose("showMenu")
    }
    
    private func hideMenu() {
        self.contentView.alpha = 1.0
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.alpha = 0.0
        }) { (_) in
            self.contentView.isHidden = true
            self.setNeedsStatusBarAppearanceUpdate()
        }
        logger.verbose("hideMenu")


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
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        logger.verbose("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        logger.verbose("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        logger.verbose("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        logger.verbose("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        logger.verbose("adViewWillLeaveApplication")
    }
}


extension SparklerViewController: GADInterstitialDelegate {

    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        logger.verbose("interstitialDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        logger.verbose("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        logger.verbose("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        logger.verbose("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        logger.verbose("interstitialDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        logger.verbose("interstitialWillLeaveApplication")
    }
    
}


extension SparklerViewController : UIViewControllerTransitioningDelegate {
    
}
