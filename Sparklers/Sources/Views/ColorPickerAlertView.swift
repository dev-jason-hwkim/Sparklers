//
//  ColorPickerAlertView.swift
//  Sparklers
//
//  Created by HyunWoo on 20/11/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import Foundation
import UIKit
import ReactorKit
import ReusableKit
import RxSwift
import RxOptional
import RxDataSources


protocol ColorPickerAlertViewProtocl : class {
    func selectColor(color:Color)
}

final class ColorPickerAlertView: UIView, View {
    
    private struct Metric {
        static let alertLeftRight: CGFloat = 20
        static let titleTop: CGFloat = 8.0
        static let segmentControlTop: CGFloat = 18.0

        static let mainColorCollectionTop: CGFloat = 8.0
        static let mainColorCollectionHeight: CGFloat = 60.0
        static let mainColorCollectionItemSize: CGFloat = 44.0
        static let mainColorCollectionItemSpacing: CGFloat = 10.0
        static let mainColorCollectionLineSpacing: CGFloat = 10.0

        static let mainColorCollectionSectioninset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        static let colorShadeCollectionSectioninset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        static let shadeColorCollectionViewHeight:CGFloat = 64

        static let buttonTop: CGFloat = 10.0
        static let buttonHeight: CGFloat = 44.0
        
        static let colorViewLeftRight: CGFloat = 25.0
        
        static let colorViewHeight: CGFloat = 30.0


    }
    private struct Font {
        static let title = UIFont.boldSystemFont(ofSize: 20.0)
    }
    
    
    private struct Color {
        static let bgColor = UIColor.color(red: 0, green: 0, blue: 0, alpha: 0.5)
        static let alert = UIColor.color(red: 29, green: 34, blue: 83, alpha: 0.73)

    }
    
    
    private struct Reusable {
        static let colorPickerCell = ReusableCell<ColorPickerCell>()
        static let emptyView = ReusableView<UICollectionReusableView>()
    }

 
    private let alert = UIView().then {
        $0.backgroundColor = Color.alert
        $0.layer.cornerRadius = 5.0
    }
    
    private let title = UILabel().then {
        $0.text = "Select a Color"
        $0.textColor = .white
        $0.backgroundColor = .clear
        $0.font = Font.title
        $0.textAlignment = .center

    }
    
    private let segmentControl = UISegmentedControl(items: ["  PRESENTS  ", "  CUSTOM  "]).then {
        $0.selectedSegmentIndex = 0
        $0.tintColor = .white
    }
    
    
    private let mainColorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false

        $0.register(Reusable.colorPickerCell)
        $0.register(Reusable.emptyView, kind: "emptyView")
    }
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<ColorPickerCollectionViewSection>(
        configureCell: { (datasource, collectionView, indexPath, sectionItem)  in
            switch sectionItem {
            case .setItem(let reactor):
                let cell = collectionView.dequeue(Reusable.colorPickerCell, for: indexPath)
                cell.reactor = reactor
                return cell
            }
    },
        configureSupplementaryView: {  dataSource, collectionView, kind, indexPath in
            return collectionView.dequeue(Reusable.emptyView, kind: "empty", for: indexPath)
    }
    )
    
    
    private let colorShadeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        
        let layout  = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        
        $0.register(Reusable.colorPickerCell)
        $0.register(Reusable.emptyView, kind: "emptyView")
    }
    
    private let shadeDataSource = RxCollectionViewSectionedReloadDataSource<ColorPickerCollectionViewSection>(
        configureCell: { (datasource, collectionView, indexPath, sectionItem)  in
            switch sectionItem {
            case .setItem(let reactor):
                let cell = collectionView.dequeue(Reusable.colorPickerCell, for: indexPath)
                cell.reactor = reactor
                return cell
            }
    },
        configureSupplementaryView: {  dataSource, collectionView, kind, indexPath in
            return collectionView.dequeue(Reusable.emptyView, kind: "empty", for: indexPath)
    }
    )
    
    private let lineView = UIView().then {
        $0.backgroundColor = UIColor.lightGray
    }
    
    
    private let hsvColorView = HSVColorView()
    
    
    private let cancel = UIButton().then {
        $0.setTitle(NSLocalizedString("cancel", comment: "Cancel"), for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }

    private let select = UIButton().then {
        $0.setTitle(NSLocalizedString("select", comment: "Select"), for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }

    
    private let oldColorView = UIView().then {
        $0.layer.borderWidth = 1.5
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private let arrow = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "outline_arrow_right_alt_white")
    }
    
    private let currentColorView = UIView().then {
        $0.layer.borderWidth = 1.5
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    var disposeBag = DisposeBag()

    weak var delegate: ColorPickerAlertViewProtocl?
    
    init(currentColor:UIColor = .white) {
        defer {
            self.reactor  = ColorPickerAlertViewReactor(currentColor: currentColor,
                                                            colorPickerCellReactorFactory: ColorPickerCellReactor.init)
            self.oldColorView.backgroundColor = self.reactor?.originalColor
            self.reactor?.action.onNext(.loadMainColors)
            self.reactor?.action.onNext(.selectMainColor(0))


        }
        super.init(frame: .zero)
    
        self.backgroundColor = Color.bgColor
        self.hsvColorView.delegate = self
        self.addSubview(self.alert)
        self.alert.addSubview(self.title)
        self.alert.addSubview(self.segmentControl)
        self.alert.addSubview(self.mainColorCollectionView)
        self.alert.addSubview(self.lineView)
        self.alert.addSubview(self.colorShadeCollectionView)
        self.alert.addSubview(self.hsvColorView)

        self.alert.addSubview(self.cancel)
        self.alert.addSubview(self.select)

        self.alert.addSubview(self.oldColorView)
        self.alert.addSubview(self.arrow)
        self.alert.addSubview(self.currentColorView)
        

    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.alert.center = self.center
        self.alert.width = Metric.mainColorCollectionItemSize * 5
            + Metric.mainColorCollectionItemSpacing * 4
            + Metric.mainColorCollectionSectioninset.left
            + Metric.mainColorCollectionSectioninset.right
        
        self.title.top = Metric.titleTop
        self.title.sizeToFit()
        self.title.centerX = self.alert.width / 2.0
        
        self.segmentControl.top = self.title.bottom + Metric.segmentControlTop
        self.segmentControl.centerX = self.alert.width / 2.0
        
        
        
        self.mainColorCollectionView.top = self.segmentControl.bottom + Metric.mainColorCollectionTop
        self.mainColorCollectionView.left2 = 0
        self.mainColorCollectionView.right2 = self.alert.width
        self.mainColorCollectionView.height = Metric.mainColorCollectionItemSize * 4
            + Metric.mainColorCollectionLineSpacing * 3
            + Metric.mainColorCollectionSectioninset.top
            + Metric.mainColorCollectionSectioninset.bottom


        self.lineView.top = self.mainColorCollectionView.bottom
        self.lineView.left2 = Metric.mainColorCollectionSectioninset.left
        self.lineView.right2 = self.mainColorCollectionView.width - Metric.mainColorCollectionSectioninset.right
        self.lineView.height = 1.0
        
        self.colorShadeCollectionView.top = self.lineView.bottom
        self.colorShadeCollectionView.left2 = 0
        self.colorShadeCollectionView.right2 = self.alert.width
        self.colorShadeCollectionView.height = Metric.shadeColorCollectionViewHeight
        
        self.hsvColorView.top = self.mainColorCollectionView.top
        self.hsvColorView.left2 = self.mainColorCollectionView.left2
        self.hsvColorView.right2 = self.mainColorCollectionView.right2
        self.hsvColorView.height = self.mainColorCollectionView.height
        
        
        self.cancel.top = self.colorShadeCollectionView.bottom + Metric.buttonTop
        self.cancel.left = 0
        self.cancel.width = self.alert.width / 2.0
        self.cancel.height = Metric.buttonHeight
        
        
        self.select.top = self.cancel.top
        self.select.left = self.cancel.right
        self.select.width = self.alert.width / 2.0
        self.select.height = Metric.buttonHeight
        
        
        self.oldColorView.centerX = self.cancel.centerX
        self.oldColorView.centerY = self.hsvColorView.bottom + (self.cancel.top - self.hsvColorView.bottom) / 2
        self.oldColorView.width = self.cancel.width - Metric.colorViewLeftRight * 2
        self.oldColorView.height = Metric.colorViewHeight

        self.arrow.sizeToFit()
        self.arrow.centerX = self.cancel.right
        self.arrow.centerY = self.oldColorView.centerY
        
        self.currentColorView.centerX = self.select.centerX
        self.currentColorView.centerY = self.hsvColorView.bottom + (self.select.top - self.hsvColorView.bottom) / 2
        self.currentColorView.width = self.select.width - Metric.colorViewLeftRight * 2
        self.currentColorView.height = Metric.colorViewHeight
        
        self.alert.height = self.cancel.bottom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func bind(reactor: ColorPickerAlertViewReactor) {
        
        self.segmentControl.rx
            .selectedSegmentIndex
            .map { (index) -> Reactor.Action in
                if index == 0 {
                    return Reactor.Action.selectSegment(true)
                } else {
                    return Reactor.Action.selectSegment(false)
                }
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        
        self.mainColorCollectionView
            .rx
            .itemSelected
            .map { Reactor.Action.selectMainColor($0.item) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        
        self.colorShadeCollectionView
            .rx
            .itemSelected
            .map { Reactor.Action.selectShadeColor($0.item) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.cancel.rx
            .tap
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                self.removeFromSuperview()
            }).disposed(by: self.disposeBag)
        
        self.select.rx
            .tap
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                self.delegate?.selectColor(color: reactor.currentState.currentColor)
                self.removeFromSuperview()
            }).disposed(by: self.disposeBag)
        
        

        self.mainColorCollectionView.rx.setDelegate(self).disposed(by: self.disposeBag)
        self.colorShadeCollectionView.rx.setDelegate(self).disposed(by: self.disposeBag)

        reactor.state
            .map { $0.mainColorSection }
            .bind(to: self.mainColorCollectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.shadeColorSection }
            .bind(to: self.colorShadeCollectionView.rx.items(dataSource: self.shadeDataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.mainColorIndex }
            .subscribe(onNext: { [weak self] (index) in
                guard let `self` = self else { return }
                if index < 0 {
                  
                } else {
                    self.mainColorCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .centeredVertically)
                    if let indexPath = self.colorShadeCollectionView.indexPathsForSelectedItems?.first {
                        self.colorShadeCollectionView.deselectItem(at: indexPath, animated: true)
                    }
                }
            })
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.shadeColorIndex }
            .subscribe(onNext: { [weak self] (index) in
                guard let `self` = self else { return }
                if index < 0 {
                    if let indexPath = self.colorShadeCollectionView.indexPathsForSelectedItems?.first {
                        self.colorShadeCollectionView.deselectItem(at: indexPath, animated: true)
                    }
                } else {
                    self.colorShadeCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .centeredVertically)
                    
                    if let indexPath = self.mainColorCollectionView.indexPathsForSelectedItems?.first {
                        self.mainColorCollectionView.deselectItem(at: indexPath, animated: true)
                    }
                }
                
            })
            .disposed(by: self.disposeBag)
        
        
        
        reactor.state
            .map { $0.isShowCollection }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] (isShowCollection) in
                guard let `self` = self else { return }

                if isShowCollection {
                    self.showCollection()
                } else {
                    self.showHSVColorView()
                }
            })
            .disposed(by: self.disposeBag)

        reactor.state
            .map { $0.currentColor }
            .subscribe(onNext: { [weak self](color) in
                guard let `self` = self else { return }
                self.currentColorView.backgroundColor = color.color
            })
            .disposed(by: self.disposeBag)
        
        
    }
    
    private func showCollection() {
        self.mainColorCollectionView.isHidden = false
        self.colorShadeCollectionView.isHidden = false
        self.hsvColorView.isHidden = true
        self.lineView.isHidden = false
        self.oldColorView.isHidden = true
        self.arrow.isHidden = true
        self.currentColorView.isHidden = true
        
    }
    
    private func showHSVColorView() {
        self.mainColorCollectionView.isHidden = true
        self.colorShadeCollectionView.isHidden = true
        self.hsvColorView.isHidden = false
        self.lineView.isHidden = true
        self.oldColorView.isHidden = false
        self.arrow.isHidden = false
        self.currentColorView.isHidden = false
        self.hsvColorView.setViewColor(reactor?.currentState.currentColor.color ?? .white)
    }
}

extension ColorPickerAlertView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Metric.mainColorCollectionItemSize, height: Metric.mainColorCollectionItemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Metric.mainColorCollectionItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Metric.mainColorCollectionLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.mainColorCollectionView {
            return Metric.mainColorCollectionSectioninset
        } else {
            return Metric.colorShadeCollectionSectioninset
        }
    }
    
}
extension ColorPickerAlertView: HSVColorViewProtocol {

    func selectColor(color: UIColor) {
        self.reactor?.action.onNext(.replaceFirstColor(color))
    }
}
