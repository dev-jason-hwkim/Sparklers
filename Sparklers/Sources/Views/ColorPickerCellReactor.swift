//
//  ColorPickerCellReactor.swift
//  Sparklers
//
//  Created by HyunWoo on 20/11/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import Foundation
import ReactorKit

final class ColorPickerCellReactor: Reactor {
    typealias Action = NoAction
    
    struct State {
        var color: UIColor
    }
    
    let initialState: State
    
    init (color:UIColor) {
        self.initialState = State(color: color)
        _ = self.state
    }
    
}
