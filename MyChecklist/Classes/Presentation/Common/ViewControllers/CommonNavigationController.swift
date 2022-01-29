//
//  CommonNavigationController.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 10.01.2022.
//

import UIKit

final class CommonNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        interactivePopGestureRecognizer?.delegate = nil
    }
}
