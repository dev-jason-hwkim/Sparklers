//
//  SparklerViewReactor.swift
//  Sparklers
//
//  Created by HyunWoo on 03/09/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit


final class SparklerViewReactor: Reactor {
    
    
    
    enum Action {
        case loadColors
        case showMenu
        case hideMenu
        case selectColor(UIColor)
        
    }
    
    enum Mutation {
        case setIsShowMenu(Bool)
        case setColorList([Color])
        case setColorFilter(UIColor)
     
    }
    
    struct State {
        var image: UIImage? = #imageLiteral(resourceName: "preview_sample")
        var color: UIColor = .white
        var sections: [SparklerColorCollectionViewSection] = [.setItems([])]
        var isShowMenu: Bool = false
    }
    
    let initialState = State()

    private(set) lazy var colorList: [Color] = {
        self.createColorList()
    }()
    
    private let colorCellReactorFactory: (Color) -> SparklerColorCellReactor
    
    
    private let originalImage = #imageLiteral(resourceName: "preview_sample")
    
    
    init(
        colorCellReactorFactory: @escaping (Color) -> SparklerColorCellReactor
        ) {
        self.colorCellReactorFactory = colorCellReactorFactory
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .loadColors:
            return Observable.just(Mutation.setColorList(self.colorList))
        case .showMenu:
            return Observable.just(Mutation.setIsShowMenu(true))
        case .hideMenu:
            return Observable.just(Mutation.setIsShowMenu(false))
        case .selectColor(let color):
            return Observable.just(Mutation.setColorFilter(color))

        }
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setIsShowMenu(let isShowMenu):
            state.isShowMenu = isShowMenu
        case .setColorList(let colors):
            let sectionItmes = self.colorListViewSectionItems(with: colors)
            state.sections = [.setItems(sectionItmes)]
            
        case .setColorFilter(let color):
            state.image = originalImage.tint(color: color)
            state.color = color
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
    
    private func colorListViewSectionItems(with filters: [Color]) -> [SparklerColorCollectionViewSectionItem] {
        return filters
            .map(self.colorCellReactorFactory)
            .map(SparklerColorCollectionViewSectionItem.setItem)
    }
}
