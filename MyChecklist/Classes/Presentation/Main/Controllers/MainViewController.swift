//
//  MainViewController.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 26.09.2021.
//

import UIKit

class MainViewController: BaseViewController<MainViewModel> {
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func applyBinding() {
        signInButton.rx.tap
            .subscribe(onNext: {
                
            })
            .disposed(by: bag)
    }
}
