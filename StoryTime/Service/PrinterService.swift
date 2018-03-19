//
// Created by Akito Nozaki on 3/7/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation
import RxSwift

public enum PrinterOrientation {
    case portrait
    case landscape
}

protocol PrinterService {
    
    var printers: Variable<[Printer]> { get }
    func availablePrinter() -> Observable<[Printer]>
    func pairPrinter()
    func printContent(image: UIImage, printer: Printer, orientation: PrinterOrientation) -> Single<Bool>
    func searchNetworkPrinter()
}
