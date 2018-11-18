//
//  SplashViewReactor.swift
//  Sparklers
//
//  Created by HyunWoo-Kim on 2018. 9. 2..
//  Copyright © 2018년 HyunWoo. All rights reserved.
//

import Foundation
import ReactorKit
import RxCocoa
import RxSwift

import AVFoundation

final class SplashViewReactor: Reactor {
    
    enum Action {
        case viewDidLoad
        case viewWillAppear
        case viewDidDisappear
    }
    
    enum Mutation {
        case setPlaying(Bool)
        case setAddNotificaiton(Bool)
    }
    
    struct State {
        var isPlaying: Bool = false
        var addNotification: Bool = false
        
        let player = AVPlayer().then {
            $0.isMuted = true
            $0.actionAtItemEnd = .none
        }
    }
    
    
    private var playerItem: AVPlayerItem? {
        didSet {
            self.currentState.player.replaceCurrentItem(with: self.playerItem)
        }
    }
    
    
    
    let initialState: State = State()
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let url = Bundle.main.url(forResource: "sparkler", withExtension: "mp4")!
            self.playerItem = AVPlayerItem(url: url)
            return Observable.just(Mutation.setPlaying(true))
        case .viewWillAppear:
            return Observable.just(Mutation.setAddNotificaiton(true))
        case .viewDidDisappear:
            return Observable.just(Mutation.setAddNotificaiton(false))
        }
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setPlaying(let isPlaying):
            state.player.play()
            state.isPlaying = isPlaying
        case .setAddNotificaiton(let addNotification):
            state.addNotification = addNotification
            if addNotification {
                self.addNotification()
            } else {
                self.removeNotification()
            }
            
        }
        
        return state
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: self.currentState.player.currentItem)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func playerItemDidReachEnd(notification:Notification) {
        if let playerItem: AVPlayerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: kCMTimeZero, completionHandler: nil)
        }
    }
    
}
