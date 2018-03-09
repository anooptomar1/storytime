//
// Created by Akito Nozaki on 3/7/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DashboardViewController: StoryTimeViewController<DashboardViewModel> {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var pairButton: UIButton!
    @IBOutlet weak var arButton: UIButton!
    @IBOutlet weak var printButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pairButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.onPairDevice()
            })
            .disposed(by: disposeBag)
        
        printButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.onPrint()
            })
            .disposed(by: disposeBag)
    
        arButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.onAr()
            })
            .disposed(by: disposeBag)
    }
}
