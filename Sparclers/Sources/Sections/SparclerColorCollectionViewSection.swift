//
//  SparclerColorCollectionViewSection.swift
//  Sparclers
//
//  Created by HyunWoo on 03/09/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import Foundation
import RxDataSources


enum SparclerColorCollectionViewSection {
    case setItems([SparclerColorCollectionViewSectionItem])
}

extension SparclerColorCollectionViewSection: SectionModelType {
    var items: [SparclerColorCollectionViewSectionItem] {
        switch self {
        case .setItems(let items): return items
        }
    }
    
    init(original: SparclerColorCollectionViewSection, items: [SparclerColorCollectionViewSectionItem]) {
        switch original {
        case .setItems: self = .setItems(items)
        }
    }
}

enum SparclerColorCollectionViewSectionItem {
    case setItem(SparclerColorCellReactor)
}
