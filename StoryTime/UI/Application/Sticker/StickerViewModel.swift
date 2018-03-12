//
// Created by Akito Nozaki on 3/11/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation
import RxSwift

public class StickerViewModel {
    public let stickers = Variable([StickerItemViewModel]())
    
    let printerService: PrinterService
    
    init() {
        printerService = try! AppDelegate.container.resolve() as PrinterService
        
        let stickers = ["Bear", "Brother", "Chameleon", "Peace", "Penguin", "Robot", "Samurai", "terminator"].map { (title: String) -> StickerItemViewModel in
            let sticker = Sticker(coverImage: UIImage(named: title)!, referenceImage: UIImage(named: title)!, assetKey: title)
            return StickerItemViewModel(sticker)
        }
        
        self.stickers.value = stickers
    }
    
    public func onPrint(sticker: Sticker) {
        guard let printer = printerService.printers.value.first else {
            return
        }
        
//        let size = CGSize(width: sticker.referenceImage.size.width, height: sticker.referenceImage.size.height)
//        UIGraphicsBeginImageContext(size)
//        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//        sticker.referenceImage.draw(in: rect, blendMode: .normal, alpha: 1.0)
//        let context = UIGraphicsGetCurrentContext()
//        context?.setStrokeColor(red: 0, green: 0, blue: 0, alpha: 1)
//        context?.stroke(rect)
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        
        _ = printerService.printContent(image: sticker.referenceImage, printer: printer)
            .subscribe(
                onSuccess: { _ in
                },
                onError: { _ in
                })
    }
}
