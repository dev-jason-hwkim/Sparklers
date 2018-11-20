//
//  TutorialViewReactor.swift
//  Sparklers
//
//  Created by HyunWoo on 18/11/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
final class TutorialViewReactor: Reactor {
    
    enum Action {
        case loadColors
        case increaseIndex
    }
    
    
    enum Mutation {
        case setColorList([Color])
        case increase
    }
    
    struct State {
        var tutorialIndex = 0
        var color: UIColor = .white
        var sections: [SparklerColorCollectionViewSection] = [.setItems([])]
        var isShowMenu: Bool = false
        
    }
    
    private(set) lazy var colorList: [Color] = {
        self.createColorList()
    }()
    
    
    
    private let colorCellReactorFactory: (Color) -> SparklerColorCellReactor

    
    let initialState = State()

    init(
        colorCellReactorFactory: @escaping (Color) -> SparklerColorCellReactor
        ) {
        self.colorCellReactorFactory = colorCellReactorFactory
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .loadColors:
            return Observable.just(Mutation.setColorList(self.colorList))
        case .increaseIndex:
            return Observable.just(Mutation.increase)

        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setColorList(let colors):
            let sectionItmes = self.colorCollectionViewSectionItems(with: colors)
            state.sections = [.setItems(sectionItmes)]
        case .increase:
            state.tutorialIndex += 1
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
            Color(color: UIColor.color(red: 137, green: 255, blue: 0), name: "G"),
            Color(color: UIColor.color(red: 255, green: 244, blue: 0), name: "Y")
        ]
    }
    
    private func colorCollectionViewSectionItems(with filters: [Color]) -> [SparklerColorCollectionViewSectionItem] {
        return filters
            .map(self.colorCellReactorFactory)
            .map(SparklerColorCollectionViewSectionItem.setItem)
    }
    
    
}
