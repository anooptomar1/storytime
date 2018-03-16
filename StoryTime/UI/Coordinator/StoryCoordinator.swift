//
// Created by Akito Nozaki on 3/12/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation

// 1. Select/Take photo to be used as reference
// 2. Select Story/Sticker mode
//
// 3. StoryCoordinator
//    ScrapBookCoordinator
// 4. List of story

import Foundation
import RxSwift
import CocoaLumberjackSwift

class StoryCoordinator: Coordinator {
    public enum Action {
        case close
    }
    
    public enum Mode {
        case photo
        case library
    }
    
    private let _action = PublishSubject<Action>()
    public var action: Observable<Action> {
        get {
            return _action.asObservable()
        }
    }
    
    
    private let router: Router
    private weak var topVC: UIViewController! = nil
    private var storyPickerDisposeBag: DisposeBag! = nil
    private var storyPrintDisposeBag: DisposeBag! = nil
    
    public var child: [Coordinator] = []
    
    public init(router: Router) {
        self.router = router
    }
    
    deinit {
        DDLogDebug("DEINIT: \(type(of: self))")
    }
    
    open func start() {
        topVC = router.top()
        self.showStoryPicker()
    }
    
    open func dismiss() {
        router.pop(to: topVC)
    }
}

extension StoryCoordinator {
    func showStoryPicker() {
        let controller = UIStoryboard.story.instantiateViewController(withIdentifier: "StoryViewController") as! StoryViewController
        let model = StoryViewModel()
        storyPickerDisposeBag = DisposeBag()
        
        controller.start(with: model)
        model.action
            .do(
                onSubscribe: { [weak self] in self?.router.push(controller) }
//                onDispose: { [weak self] in self?.router.pop() }
            )
            .subscribe(onNext: { [weak self] action in
                switch action {
                    case .close:
                        self?.storyPickerDisposeBag = nil
                        self?._action.onNext(.close)
                    case .story(let story):
                        self?.showStoryPrint(for: story)
                }
                
            })
            .disposed(by: storyPickerDisposeBag)
    }
    
    func showStoryPrint(for story: Story) {
        let controller = UIStoryboard.story.instantiateViewController(withIdentifier: "StoryPrintViewController") as! StoryPrintViewController
        let model = StoryPrintViewModel(story: story)
        storyPrintDisposeBag = DisposeBag()
        
        controller.start(with: model)
        model.action
            .do(
                onSubscribe: { [weak self] in self?.router.push(controller) }
//                onDispose: { [weak self] in self?.router.pop() }
            )
            .subscribe(onNext: { [weak self] action in
                switch action {
                    case .close:
                        self?.storyPrintDisposeBag = nil
                }
                
            })
            .disposed(by: storyPrintDisposeBag)
    }
}
