//
//  ObserverType+Extension.swift
//  mercury-ios
//
//  Created by Данил Коротаев on 07.07.2021.
//  Copyright © 2021 Trinity Monsters. All rights reserved.
//

import RxSwift

extension ObserverType where Element == Void {
    func onNext() {
        self.onNext(())
    }
}
