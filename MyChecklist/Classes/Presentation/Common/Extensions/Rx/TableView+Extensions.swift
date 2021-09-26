//
//  TableView+Extensions.swift
//  mercury-ios
//
//  Created by Данил Коротаев on 05.07.2021.
//  Copyright © 2021 Trinity Monsters. All rights reserved.
//

import RxSwift
import UIKit

extension Reactive where Base: UITableView {
    func items<Sequence: Swift.Sequence, Cell: UITableViewCell, Source: ObservableType>
    (_ cellType: Cell.Type)
    -> (_ source: Source)
    -> (_ configureCell: @escaping (Int, Sequence.Element, Cell) -> Void)
    -> Disposable
    where Source.Element == Sequence {
        return items(cellIdentifier: cellType.identifier, cellType: cellType)
    }
}
