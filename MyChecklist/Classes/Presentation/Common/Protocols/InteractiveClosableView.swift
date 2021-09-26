//
//  InteractiveClosableView.swift
//  mercury-ios
//
//  Created by Данил Коротаев on 07.07.2021.
//  Copyright © 2021 Trinity Monsters. All rights reserved.
//

import Foundation

protocol InteractiveClosableView {
    var interactionEnabled: Bool { get }
    func closeExecute()
}
