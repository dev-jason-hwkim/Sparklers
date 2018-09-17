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
        $0.backgroundColor = .clear
    }
    
    private let imgView = UIImageView()
    
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
        
        self.bannerView.rootViewController = self
        self.bannerView.delegate = self
        self.bannerView.load(GADRequest())
        
        self.view.window?.screen.brightness = 0.1
        logger.verbose()
        
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
        logger.verbose(self.safeAreaInsets)
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(self.colorList.snp.top)
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            let naviHeight = self.navigationController?.navigationBar.bounds.size.height ?? 0
            make.centerY.equalToSuperview().offset(naviHeight)
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
                logger.verbose("guide")
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
        
        
        self.colorList.rx.itemSelected(dataSource: self.dataSource)
            .map { (item) -> UIColor in
                switch item {
                case .setItem(let reactor):
                    return reactor.currentState.color.color
                }
            }
            .subscribe(onNext: {[weak self] (color) in
                guard let `self` = self else { return }
                self.view.backgroundColor = color
            })
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


