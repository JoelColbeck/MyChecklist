//
//  MainViewModel.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 26.09.2021.
//

import Foundation
import RxSwift
import RxRelay

class MainViewModel: BaseViewModel {
    let signInPublisher = PublishRelay<Void>()
}
