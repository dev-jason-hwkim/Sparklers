//
//  TutorialViewController.swift
//  Sparklers
//
//  Created by HyunWoo on 18/11/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import UIKit
import Foundation
import ReusableKit
import ReactorKit
import RxDataSources
final class TutorialViewController: BaseViewController, ReactorKit.View {
    
    
    private struct Metric {
        static let topButtonMargin: CGFloat = 10.0

        static let topButtonWidth: CGFloat = 24.0

        static let titleLeft: CGFloat = 18.0
        static let titleTop: CGFloat = 18.0
        
        static let menuTutorialBottom: CGFloat = 15.0
        
        static let openMenuWidth: CGFloat = 35.0
        static let openMenuBottom: CGFloat = 10.0

        static let paletteLeft: CGFloat = 10.0
        static let lineHeight: CGFloat = 15.0
        static let colorListHeight: CGFloat = 60.0
        static let colorListItemSize: CGFloat = 44.0
        static let colorListItemSpacing: CGFloat = 10.0
        static let colorListSectioninset = UIEdgeInsetsMake(0, 10, 0, 10)

        static let colorTutorialLeft: CGFloat = 20.0
        static let colorTutorialBottom: CGFloat = 15.0
        
        static let previewTutorialTop: CGFloat = 10.0
        static let previewTutorialLeft: CGFloat = 10.0

        static let lastTutorialTop: CGFloat = 15.0

    }
    
    private struct Color {
        static let titleLabel = UIColor.color(red: 255, green: 255, blue: 255, alpha: 0.4)
        static let circleBorder = UIColor.color(red: 29, green: 34, blue: 83)
        

    }
    
    private struct Font {
        static let titleLabel = UIFont.systemFont(ofSize: 24)
        static let tutorial = UIFont.boldSystemFont(ofSize: 20)

    }
    
    
    private struct Reusable {
        static let colorCell = ReusableCell<SparklerColorCell>()
        static let emptyView = ReusableView<UICollectionReusableView>()
        
    }
    
    
    private let backBtn = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "arrow_back")
        $0.isHidden = true
    }
    
    private let infoBtn = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "info")
        $0.isHidden = true
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = Color.titleLabel
        $0.font = Font.titleLabel
        $0.text = NSLocalizedString("tutorial_title", comment: "Tutorial")
        
    }
    
    
    private let menuTutorial = UILabel().then {
        $0.textColor = .black
        $0.font = Font.tutorial
        $0.text = NSLocalizedString("tutorial_btn_click_des", comment: "Please touch this button")
    }
    
    private let openMenu = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "ic_outline_up.pdf")
    }
    
    private let menuCircle = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = Metric.openMenuWidth / 2.0
        $0.layer.borderWidth = 3.0
        $0.layer.borderColor = Color.circleBorder.cgColor
    }
    
    private let preview = UIImageView().then {
        $0.backgroundColor = .clear
        $0.image = #imageLiteral(resourceName: "preview_sample")
        $0.isHidden = true
    }
    
    
    
    private let colorView = UIView().then {
        $0.backgroundColor = .clear
        $0.isHidden = true
    }
    
    private let colorPaletteView = ColorPaletteView().then {
        $0.layer.cornerRadius = Metric.colorListItemSize / 2.0
        $0.alpha = 0.0
        $0.clipsToBounds = true

    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = .white
        $0.isHidden = true

    }
    
    private let colorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        let layout  = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        
        $0.register(Reusable.colorCell)
        $0.register(Reusable.emptyView, kind: "emptyView")
    }
    
    
    private let previewTutorial = UILabel().then {
        $0.textColor = .white
        $0.font = Font.tutorial
        $0.text = NSLocalizedString("tutorial_color_preview", comment: "Please check the preview")
        $0.isHidden = true

    }
    
    
    
    private let colorTutorial = UILabel().then {
        $0.textColor = .white
        $0.font = Font.tutorial
        
        $0.text = NSLocalizedString("tutorial_select_color_des", comment: "Please touch this button")
        $0.isHidden = true
    }
    
    
    
    private let lastTutorial = UILabel().then {
        $0.textColor = .white
        $0.font = Font.tutorial
        $0.text = NSLocalizedString("tutorial_select_complite", comment: "Please complete your selection")
        $0.isHidden = true
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
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let reactor = self.reactor else { return .lightContent }
        if reactor.currentState.tutorialIndex > 0 {
            return .lightContent
        } else {
            return .default
        }
    }
    
    
    init(
        reactor: TutorialViewReactor
        ) {
        defer { self.reactor = reactor }
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.startCircleAnimation()
    
        
    }
    
    override func addViews() {
        super.addViews()
        self.view.addSubview(self.backBtn)
        self.view.addSubview(self.infoBtn)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.menuTutorial)
        self.view.addSubview(self.openMenu)
        self.view.addSubview(self.menuCircle)
        
        
        
        
        
        
        
        self.view.addSubview(self.colorTutorial)
        
        self.view.addSubview(self.preview)
        self.view.addSubview(self.previewTutorial)
        
        self.view.addSubview(self.colorView)
        self.colorView.addSubview(self.colorPaletteView)
        self.colorView.addSubview(self.lineView)
        self.colorView.addSubview(self.colorCollectionView)
        
        self.view.addSubview(self.lastTutorial)
        
        
        
        

    }
    
    override func setupConstraints() {
        
        super.setupConstraints()
        self.backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaInsets.top + Metric.topButtonMargin)
            make.left.equalTo(Metric.topButtonMargin)
            make.width.equalTo(Metric.topButtonWidth)
            make.height.equalTo(self.backBtn.snp.width)
        }
        
        
        self.infoBtn.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaInsets.top + Metric.topButtonMargin)
            make.right.equalTo(-Metric.topButtonMargin)
            make.width.equalTo(Metric.topButtonWidth)
            make.height.equalTo(self.backBtn.snp.width)
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaInsets.top + Metric.titleTop)
            make.left.equalTo(Metric.titleLeft)
        }
        
        self.menuTutorial.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.openMenu.snp.top).offset(-Metric.menuTutorialBottom)
            make.centerX.equalToSuperview()
        }
        
        
        self.openMenu.snp.makeConstraints { (make) in
            if safeAreaInsets.bottom > 0 {
                make.bottom.equalTo(-safeAreaInsets.bottom)
            } else {
                make.bottom.equalTo(-safeAreaInsets.bottom - Metric.openMenuBottom)
            }
            make.width.equalTo(Metric.openMenuWidth)
            make.height.equalTo(self.openMenu.snp.width)
            make.centerX.equalToSuperview()
        }
        self.menuCircle.snp.makeConstraints { (make) in
            make.edges.equalTo(self.openMenu.snp.edges)
        }
        
        self.preview.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            if let image = self.preview.image {
                make.height.equalTo(self.preview.snp.width).dividedBy(image.size.width/image.size.height)
            }
        }
        
        self.previewTutorial.snp.makeConstraints { (make) in
            make.left.equalTo(self.colorTutorial.snp.left)
            make.top.equalTo(self.preview.snp.bottom).offset(Metric.topButtonMargin + Metric.lastTutorialTop)

        }
        
        self.colorTutorial.snp.makeConstraints { (make) in
            make.left.equalTo(Metric.colorTutorialLeft)
            make.bottom.equalTo(self.colorView.snp.top).offset(-Metric.colorTutorialBottom)
        }
        
        self.colorView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(-safeAreaInsets.bottom)
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
        
        self.lastTutorial.snp.makeConstraints { (make) in
            make.left.equalTo(self.colorTutorial.snp.left)
            make.top.equalTo(self.backBtn.snp.bottom).offset(Metric.topButtonMargin + Metric.lastTutorialTop)
        }
    }
    
    func bind(reactor: TutorialViewReactor) {
        self.rx
            .viewDidLoad
            .map { Reactor.Action.loadColors }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.view.rx
            .tapGesture()
            .filter { $0.state == .ended }
            .map { _ in Reactor.Action.increaseIndex }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        
        self.colorCollectionView.rx.setDelegate(self).disposed(by: self.disposeBag)

        reactor.state
            .map { $0.sections }
            .bind(to: self.colorCollectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.tutorialIndex }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] (index) in
                guard let `self` = self else { return }
                logger.verbose(index)
                switch index {
                case 1:
                    self.menuCircle.layer.removeAllAnimations()
                    self.showColorSelectAnimation()
                case 2:
                    self.colorTutorial.textColor = UIColor.color(red: 255, green: 255, blue: 255, alpha: 0.4)

                    self.showPreviewAnimation()
                case 3:
                    self.showResultAnimation()
                case 4:
                    self.navigationController?.popViewController(animated: true)
                    
                default:
                    break
                }
                
                self.setNeedsStatusBarAppearanceUpdate()
                
            })
            .disposed(by: self.disposeBag)
    }
    
    private func startCircleAnimation() {
        UIView.animate(withDuration: 0.8,
                       delay: 0.0,
                       options: [.repeat, .autoreverse, .allowUserInteraction],
                       animations: {
                        self.menuCircle.alpha = 0.0
                        self.menuCircle.alpha = 1.0
        }, completion: nil)
    }
    
    private func showColorSelectAnimation() {
        self.view.backgroundColor = .black
        self.menuTutorial.isHidden = true
        self.menuCircle.isHidden = true
        self.openMenu.isHidden = true
        
        self.colorTutorial.isHidden = false
        self.colorView.isHidden = false

        self.colorPaletteView.transform = CGAffineTransform(translationX: 0, y: Metric.colorListHeight)
        self.colorPaletteView.layer.removeAllAnimations()

        UIView.animate(withDuration: 0.05,
                       delay: 0.0,
                       options: [],
                       animations: {
                        self.colorPaletteView.alpha = 1
                        self.colorPaletteView.transform = CGAffineTransform(translationX: 0, y: 0)
                        self.lineView.alpha = 1

        })


        self.colorCollectionView.layoutIfNeeded()
        logger.verbose(self.colorCollectionView.visibleCells)
        let indexs = self.colorCollectionView.indexPathsForVisibleItems.map { $0.item }.sorted()
        let start = indexs.first ?? 0
        let end = indexs.last ?? 0
        
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
    private func showPreviewAnimation() {
        self.preview.isHidden = false
        self.previewTutorial.isHidden = false
        self.previewTutorial.alpha = 0.0
        self.preview.alpha = 0.0
        self.colorView.alpha = 1.0
        UIView.animate(withDuration: 0.3, animations: {
            self.preview.alpha = 1.0
            self.previewTutorial.alpha = 1.0
            self.colorView.alpha = 0.6

        })
    }

    private func showResultAnimation() {
        self.titleLabel.isHidden = true

        self.backBtn.isHidden = false
        self.infoBtn.isHidden = false
        self.lastTutorial.isHidden = false
        
        self.backBtn.alpha = 0.0
        self.infoBtn.alpha = 0.0
        self.lastTutorial.alpha = 0.0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backBtn.alpha = 1.0
            self.infoBtn.alpha = 1.0
            self.lastTutorial.alpha = 1.0
        })
    }
}
extension TutorialViewController: UICollectionViewDelegateFlowLayout {
    
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
