//
//  UICollectionView-Rx.swift
//  Sparklers
//
//  Created by HyunWoo on 03/09/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift

extension Reactive where Base: UICollectionView {
    func itemSelected<S>(dataSource: CollectionViewSectionedDataSource<S>) -> ControlEvent<S.Item> {
        let source = self.itemSelected.map { indexPath in
            dataSource[indexPath]
        }
        return ControlEvent(events: source)
    }
}
