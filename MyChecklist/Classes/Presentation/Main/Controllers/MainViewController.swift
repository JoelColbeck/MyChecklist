//
//  MainViewController.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 26.09.2021.
//

import UIKit

class MainViewController: BaseViewController<MainViewModel> {
    // MARK: - Outlets
    @IBOutlet private weak var signInButton: UIButton!
    
    // MARK: - LC
    override func viewDidLoad() {
        super.viewDidLoad()
        isHeroEnabled = true
    }
    
    override func applyBinding() {
        guard let dataContext = dataContext else { return }
        
        signInButton.rx.tap
            .bind(to: dataContext.signInPublisher)
            .disposed(by: bag)
    }
}
