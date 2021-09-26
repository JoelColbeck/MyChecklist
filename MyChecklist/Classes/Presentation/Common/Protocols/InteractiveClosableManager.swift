//
//  InteractiveClosableManager.swift
//  mercury-ios
//
//  Created by Данил Коротаев on 07.07.2021.
//  Copyright © 2021 Trinity Monsters. All rights reserved.
//

import RxSwift

protocol InteractiveClosableManager {
    var closed: PublishSubject<Void> { get }
    func close()
}

extension InteractiveClosableManager {
    func close() {
        closed.onNext(())
    }
}
