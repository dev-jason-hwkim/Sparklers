//
//  SparclerViewReactor.swift
//  Sparclers
//
//  Created by HyunWoo on 03/09/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import Foundation



final class SparclerViewReactor: Reactor {
    
    
    
    enum Action {
        case loadFilter
        case filterTouched
    }
    
    enum Mutation {
        case setFilters(items:[Color])
        
        
    }
    
    struct State {
        var filter:Int = 0
//        var sections: [FilterListViewSection] = [.setItems([])]
        
        
    }
    
    let initialState = State()
    
    private let filterCellReactorFactory: (Filter) -> FilterViewCellReactor
    
    
    init(
        filterCellReactorFactory: @escaping (Filter) -> FilterViewCellReactor
        ) {
        self.filterCellReactorFactory = filterCellReactorFactory
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        //
        //        switch action {
        //        case .loadFilter:
        //
        //
        //            return Observable.empty()
        //
        //
        //        default:
        //        }
        
        return .empty()
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        //        switch mutation {
        //        case let .setFilters(items: items):
        //            let sectionItmes = self.filterListViewSectionItems(with: items)
        //            state.sections = [.setItems(sectionItmes)]
        //            return state
        //        }
        
        return state
    }
    
    
    private func filterListViewSectionItems(with filters: [Filter]) -> [FilterListViewSectionItem] {
        return filters
            .map(self.filterCellReactorFactory)
            .map(FilterListViewSectionItem.setItem)
    }
}
