//
//  SparklerColorCollectionViewSection.swift
//  Sparklers
//
//  Created by HyunWoo on 03/09/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import Foundation
import RxDataSources


enum SparklerColorCollectionViewSection {
    case setItems([SparklerColorCollectionViewSectionItem])
}

extension SparklerColorCollectionViewSection: SectionModelType {
    var items: [SparklerColorCollectionViewSectionItem] {
        switch self {
        case .setItems(let items): return items
        }
    }
    
    init(original: SparklerColorCollectionViewSection, items: [SparklerColorCollectionViewSectionItem]) {
        switch original {
        case .setItems: self = .setItems(items)
        }
    }
}

enum SparklerColorCollectionViewSectionItem {
    case setItem(SparklerColorCellReactor)
}
