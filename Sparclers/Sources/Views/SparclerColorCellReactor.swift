//
//  SparclerColorCellReactor.swift
//  Sparclers
//
//  Created by HyunWoo on 03/09/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import RxSwift
import RxCocoa
import ReactorKit

final class SparclerColorCellReactor: Reactor {
    typealias Action = NoAction
    
    struct State {
        var color: Color
    }
    
    let initialState: State
    
    init (color:Color) {
        self.initialState = State(color: color)
        _ = self.state
    }
    
    
}
