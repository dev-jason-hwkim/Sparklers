//
//  ColorPickerAlertViewReactor.swift
//  Sparklers
//
//  Created by HyunWoo on 20/11/2018.
//  Copyright © 2018 HyunWoo. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

final class ColorPickerAlertViewReactor: Reactor  {
    enum Action {
        case selectSegment(Bool)
        case loadMainColors
        case selectMainColor(Int)
        case selectShadeColor(Int)
        case replaceFirstColor(UIColor)

    }
    
    
    enum Mutation {
        case setMainColorList([UIColor])
        case setShadeColorList([UIColor])
        case setMainColorIndex(Int)
        case setShadeColorIndex(Int)
        case setIsShowCollection(Bool)

    }
    
    
    struct State {
        var isShowCollection = true
        var mainColorSection: [ColorPickerCollectionViewSection] = [.setItems([])]
        var mainColorIndex = -1
        var shadeColorSection: [ColorPickerCollectionViewSection] = [.setItems([])]
        var shadeColorIndex = -1
        
        var currentColor: Color = Color(color: .white, name: "C")


    }
   
    let initialState = State()

    private let colorPickerCellReactorFactory: (UIColor) -> ColorPickerCellReactor
    
     let originalColor: UIColor
    private(set) lazy var mainColorList: [UIColor] = {
        self.createColorList()
    }()
    
    
    init(currentColor:UIColor,
          colorPickerCellReactorFactory: @escaping(UIColor) -> ColorPickerCellReactor) {
        self.colorPickerCellReactorFactory = colorPickerCellReactorFactory
        self.originalColor = currentColor
        self.mainColorList.insert(currentColor, at: 0)
    }
    

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadMainColors:
            return Observable.concat([
                Observable.just(Mutation.setMainColorList(self.mainColorList)),
                self.mutate(action:.selectMainColor(0))
                ])
        case .selectMainColor(let index):
            let color = self.mainColorList[index]
            
            return Observable.concat([
                Observable.just(Mutation.setShadeColorIndex(-1)),
                Observable.just(Mutation.setMainColorIndex(index)),
                Observable.just(Mutation.setShadeColorList(self.getColorShadeList(color: color)))
                ])
        case .selectShadeColor(let index):
            return Observable.just(Mutation.setShadeColorIndex(index))
        case .selectSegment(let isShowCollection):
            return Observable.just(Mutation.setIsShowCollection(isShowCollection))
        case .replaceFirstColor(let color):
            self.mainColorList[0] = color
                 return Observable.concat([
                    self.mutate(action:.loadMainColors),
                    self.mutate(action:.selectMainColor(0))
                    ])
        }
        
        
    }
 
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setMainColorList(let colorList):
            let sectionItmes = self.colorCollectionViewSectionItems(colors: colorList)
            state.mainColorSection = [.setItems(sectionItmes)]
        case .setShadeColorList(let shadeColorList):
            let sectionItmes = self.colorCollectionViewSectionItems(colors: shadeColorList)
            state.shadeColorSection = [.setItems(sectionItmes)]
        case .setMainColorIndex(let index):
            state.mainColorIndex = index
            let mainColor = self.mainColorList[index]
            state.currentColor = Color(color: mainColor, name: "C")
        case .setShadeColorIndex(let index):
            state.shadeColorIndex = index
            if state .shadeColorIndex >= 0 {
                let mainColor = self.mainColorList[state.mainColorIndex]
                let color = self.getColorShadeList(color: mainColor)[index]
                state.currentColor = Color(color: color, name: "C")
            }
        case .setIsShowCollection(let isShowCollection):
            state.isShowCollection = isShowCollection
        }
        

        
        return state
    }
    
    
    
    
    
    private func createColorList() -> [UIColor] {
        return [
            UIColor.color(red:244, green:67, blue:54),
            UIColor.color(red:233, green:30, blue:99),
            UIColor.color(red:255, green:44, blue:147),
            UIColor.color(red:156, green:39, blue:176),
            UIColor.color(red:103, green:58, blue:183),
            UIColor.color(red:63, green:81, blue:181),
            UIColor.color(red:33, green:150, blue:243),
            UIColor.color(red:3, green:169, blue:244),
            UIColor.color(red:0, green:188, blue:212),
            UIColor.color(red:0, green:150, blue:136),
            UIColor.color(red:76, green:175, blue:80),
            UIColor.color(red:139, green:195, blue:74),
            UIColor.color(red:205, green:220, blue:57),
            UIColor.color(red:255, green:235, blue:59),
            UIColor.color(red:255, green:193, blue:7),
            UIColor.color(red:255, green:152, blue:0),
            UIColor.color(red:121, green:85, blue:72),
            UIColor.color(red:96, green:125, blue:139),
            UIColor.color(red:158, green:158, blue:158)
        ]
    }
    
    

    
    private func colorCollectionViewSectionItems(colors: [UIColor]) -> [ColorPickerCollectionViewSectionItem] {
        return colors
            .map(self.colorPickerCellReactorFactory)
            .map(ColorPickerCollectionViewSectionItem.setItem)
    }
    
    private func getColorShadeList(color:UIColor) -> [UIColor] {
        return [
            self.shadeColor(color: color, percent: 0.9),
            self.shadeColor(color: color, percent: 0.7),
            self.shadeColor(color: color, percent: 0.5),
            self.shadeColor(color: color, percent: 0.333),
            self.shadeColor(color: color, percent: 0.166),
            self.shadeColor(color: color, percent: -0.125),
            self.shadeColor(color: color, percent: -0.25),
            self.shadeColor(color: color, percent: -0.375),
            self.shadeColor(color: color, percent: -0.5),
            self.shadeColor(color: color, percent: -0.675),
            self.shadeColor(color: color, percent: -0.7),
            self.shadeColor(color: color, percent: -0.775)
        ]
    }
    
    private func shadeColor (color:UIColor, percent:CGFloat) -> UIColor {
        guard let colorComponents = color.colorComponents else { return .clear }
        let t: CGFloat = percent < 0 ? 0 : 255
        let p: CGFloat = percent < 0 ? -percent : percent
        
        let r = colorComponents.red * 255
        let g = colorComponents.green * 255
        let b = colorComponents.blue * 255
        
        let red = round((t - r) * p) + r
        let green = round((t - g) * p) + g
        let blue = round((t - b) * p) + b
        let alpha = colorComponents.alpha

        return UIColor.color(red: red, green: green, blue: blue, alpha: alpha)
    }
}
