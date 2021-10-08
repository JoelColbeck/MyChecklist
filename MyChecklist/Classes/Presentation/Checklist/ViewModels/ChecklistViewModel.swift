//
//  ChecklistViewModel.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 08.10.2021.
//

import Foundation
import RxRelay
import RxSwift

class ChecklistViewModel: BaseViewModel {
    let closed = PublishRelay<Void>()
    
    // MARK: - Private Properties
    private let testService = TestService.shared
}
