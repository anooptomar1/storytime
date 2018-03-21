//
// Created by Akito Nozaki on 3/20/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ScrapBookViewController: StoryTimeViewController<ScrapBookViewModel>, UICollectionViewDataSource, UICollectionViewDelegate {
    static let defaultRestorationId = "DefaultCell"
    
    private let flowLayout = EffectGridFlowLayout()
    private let disposeBag = DisposeBag()
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var createButton: UIBarButtonItem!
    @IBOutlet var imageView: UIImageView!
    
    deinit {
        viewModel.onClose()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
        Observable.combineLatest(viewModel.effects.asObservable(), viewModel.selection.asObservable())
            .observeOn(MainScheduler.instance)
            .map { [weak self] _ in self?.collectionView.reloadData() }
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel.selectedImage.asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        
        createButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.onCreate()
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: { context in
        })
    }
    
    func onCreate() {
    
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.effects.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScrapBookViewController.defaultRestorationId, for: indexPath) as? StickerEffectViewCell else { return UICollectionViewCell() }
        
        cell.update(effect: viewModel.effects.value[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let effect = viewModel.effects.value[indexPath.item]
        viewModel.onSelectEffect(effect: effect.effect)
    }
}
