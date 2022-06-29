//
//  PickerCellViewModel.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 05.06.2022.
//

import Foundation
import RxRelay

final class PickerCellViewModel<T: CaseIterable & TitleConvertible>: BaseViewModel {
    // MARK: - Input
    var rowInput = PublishRelay<Int>()
    
}

