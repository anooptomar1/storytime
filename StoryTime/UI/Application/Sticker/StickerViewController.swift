//
// Created by Akito Nozaki on 3/11/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class StickerViewController: StoryTimeViewController<StickerViewModel>, UICollectionViewDataSource, UICollectionViewDelegate {
    
    static let defaultRestorationId = "DefaultCell"
    
    private let gridLayout = StickerGridFlowLayout()
    
    private let disposeBag = DisposeBag()
    
    // MARK: Properties - Views
    
    @IBOutlet var collectionView: UICollectionView!
    
    deinit {
        viewModel.onClose()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.setCollectionViewLayout(gridLayout, animated: false)
        
        viewModel.stickers
            .asObservable()
            .observeOn(MainScheduler.instance)
            .map { [weak self] items in self?.collectionView.reloadData() }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: { context in
        })
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.stickers.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StickerViewController.defaultRestorationId, for: indexPath) as? StickerCollectionViewCell else { return UICollectionViewCell() }
        
        cell.update(for: viewModel.stickers.value[indexPath.row])
        
        return cell
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == CVSSwitchingViewController.detailSegue {
//            let cell = collectionView.cellForItem(at: selectIndexPath) as! CVSSwitchingCollectionViewCell
//            let controller = segue.destination as! CVSDetailViewController
//            _ = controller.view // hack
//            controller.image = cell.image
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sticker = viewModel.stickers.value[indexPath.item]
        let alertController = UIAlertController(title: "Print", message: "Print this sticker?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Print", style: .default) { [weak self] action in
            self?.viewModel.onPrint(sticker: sticker.sticker)
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true)
        
    }
}
