//
//  SparclerViewController.swift
//  Sparclers
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

import SideMenu






final class SparclerViewController: BaseViewController, ReactorKit.View {
    
    
    private struct Metric {
        
        
        static let paletteLeft: CGFloat = 10.0
        
        static let lineHeight: CGFloat = 15.0
        static let colorListHeight: CGFloat = 60.0
        static let colorListItemSize: CGFloat = 44.0
        static let colorListItemSpacing: CGFloat = 10.0
        static let colorListSectioninset = UIEdgeInsetsMake(0, 10, 0, 10)
        
        
    }
    
    
    private struct Reusable {
        static let colorCell = ReusableCell<SparclerColorCell>()
        static let emptyView = ReusableView<UICollectionReusableView>()

    }
    
    
    private let infoBtn = UIButton(type: .infoLight)
    
    
    private let contentView = UIView().then {
        $0.backgroundColor = .black
    }
    
    private let imgView = UIImageView().then {
        $0.backgroundColor = .clear
    }
    
    private let paletteView = ColorPaletteView().then {
        $0.layer.cornerRadius = Metric.colorListItemSize / 2.0
        $0.clipsToBounds = true
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = .black
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
    
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<SparclerColorCollectionViewSection>(
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
    
    
    private var interstitial: GADInterstitial!


    

    init(
        reactor: SparclerViewReactor
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
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .black
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.infoBtn)
        

        self.setupGARequest()
    }
    
    override func addViews() {
        super.addViews()
        self.contentView.addSubview(self.imgView)
        
        self.view.addSubview(self.contentView)
        self.view.addSubview(self.paletteView)
        self.view.addSubview(self.lineView)

        self.view.addSubview(self.colorList)
        self.view.addSubview(self.bannerView)
        
        
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        self.contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
          
            make.centerY.equalToSuperview().offset(-Metric.colorListHeight/2.0)
            make.height.equalTo(self.contentView.snp.width)
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            guard let size = self.imgView.image?.size else { return }
            make.height.equalTo(self.imgView.snp.width).dividedBy(size.width/size.height)
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
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-self.safeAreaInsets.bottom)
        }
    }
    

    func bind(reactor: SparclerViewReactor) {
        self.rx.viewDidLoad
            .map { Reactor.Action.loadColors }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.infoBtn.rx
            .tap
            .subscribe(onNext: { (_) in
                let menu = UISideMenuNavigationController(rootViewController: UIViewController())
                SideMenuManager.default.menuRightNavigationController = menu
                SideMenuManager.default.menuPresentMode = .viewSlideInOut
                SideMenuManager.default.menuShadowColor = .black
                SideMenuManager.default.menuShadowOpacity = 0.5
            
                SideMenuManager.default.menuWidth = SCREEN_SIZE.width * 3.0 / 4.0
                self.present(menu, animated: true, completion: nil)
            })
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
            .map { $0.image }
            .bind(to: self.imgView.rx.image)
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

    
    
    
    func shwoAlert() {
        let alert = UIAlertController(title: "Select a Color", message: nil, preferredStyle: .alert)

        
        alert.setValue(self.creatCustomVC(), forKey: "contentViewController")
        
        let okAction = UIAlertAction(title: "Custom", style: .default) { (_) in
            logger.verbose("Custom")
        }
        let select = UIAlertAction(title: "Select", style: .default) { (action) in
            
            action.setValue("Custom", forKey: "title")
        }
     
        alert.addAction(okAction)
        alert.addAction(select)
        self.present(alert, animated: false)
        
    }
    
    
    
    func creatCustomVC() -> UIViewController {
        
        let customVC = UIViewController()
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        customVC.view = containerView
        
        customVC.preferredContentSize.width = self.view.frame.width
        
        customVC.preferredContentSize.height = 300
        
        containerView.backgroundColor = UIColor.red
        
        return customVC
        
    }
    
    
    
}
extension SparclerViewController: UICollectionViewDelegateFlowLayout {
    
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
extension SparclerViewController: GADBannerViewDelegate {
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


extension SparclerViewController: GADInterstitialDelegate {

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


