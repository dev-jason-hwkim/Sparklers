//
//  ColorPickerCollectionViewSection.swift
//  Sparklers
//
//  Created by HyunWoo on 20/11/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import Foundation
import RxDataSources
enum ColorPickerCollectionViewSection {
    case setItems([ColorPickerCollectionViewSectionItem])
}

extension ColorPickerCollectionViewSection: SectionModelType {
    var items: [ColorPickerCollectionViewSectionItem] {
        switch self {
        case .setItems(let items): return items
        }
    }
    
    init(original: ColorPickerCollectionViewSection, items: [ColorPickerCollectionViewSectionItem]) {
        switch original {
        case .setItems: self = .setItems(items)
        }
    }
}

enum ColorPickerCollectionViewSectionItem {
    case setItem(ColorPickerCellReactor)
}
