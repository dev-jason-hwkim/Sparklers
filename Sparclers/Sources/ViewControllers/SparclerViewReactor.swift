//
//  SparclerViewReactor.swift
//  Sparclers
//
//  Created by HyunWoo on 03/09/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit


final class SparclerViewReactor: Reactor {
    
    
    
    enum Action {
        case loadColors
        
    }
    
    enum Mutation {
        case setColorList([Color])
        
        
    }
    
    struct State {
        var sections: [SparclerColorCollectionViewSection] = [.setItems([])]
        
    }
    
    let initialState = State()

    private(set) lazy var colorList: [Color] = {
        self.createColorList()
    }()
    
    private let colorCellReactorFactory: (Color) -> SparclerColorCellReactor
    
    
    init(
        colorCellReactorFactory: @escaping (Color) -> SparclerColorCellReactor
        ) {
        
        
        self.colorCellReactorFactory = colorCellReactorFactory
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .loadColors:
            logger.verbose(self.colorList)
            return Observable.just(Mutation.setColorList(self.colorList))

        }
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setColorList(let colors):
            let sectionItmes = self.colorListViewSectionItems(with: colors)
            state.sections = [.setItems(sectionItmes)]
        }
        
        return state
    }
    
    private func createColorList() -> [Color] {
        return [
            Color(color: .white, name: "W"),
            Color(color: UIColor.color(red: 253, green: 252, blue: 201), name: "I"),
            Color(color: .red, name: "R"),
            Color(color: UIColor.color(red: 240, green: 0, blue: 255), name: "P"),
            Color(color: UIColor.color(red: 0, green: 236, blue: 255), name: "C"),
            Color(color: UIColor.color(red: 137, green: 255, blue: 255), name: "G"),
            Color(color: UIColor.color(red: 255, green: 244, blue: 0), name: "Y")
        ]
    }
    
    private func colorListViewSectionItems(with filters: [Color]) -> [SparclerColorCollectionViewSectionItem] {
        return filters
            .map(self.colorCellReactorFactory)
            .map(SparclerColorCollectionViewSectionItem.setItem)
    }
}
