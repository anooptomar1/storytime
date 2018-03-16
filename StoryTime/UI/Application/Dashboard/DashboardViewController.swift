//
// Created by Akito Nozaki on 3/7/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DashboardViewController: StoryTimeViewController<DashboardViewModel> {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var arButton: UIButton!
    @IBOutlet weak var stickerButton: UIButton!
    @IBOutlet weak var storyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stickerButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.onStickerSelection()
            })
            .disposed(by: disposeBag)
        
        arButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.onAr()
            })
            .disposed(by: disposeBag)
        
        storyButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.onStory()
            })
            .disposed(by: disposeBag)
    }
}
