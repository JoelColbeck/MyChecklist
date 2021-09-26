//
//  AuthViewController.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 26.09.2021.
//

import UIKit
import Hero

class AuthViewController: BaseViewController<BaseViewModel> {
    @IBOutlet weak var navigationBar: NavigationBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isHeroEnabled = true
        configureNavigationBar()
    }
    
    // MARK: - Private Methods
    private func configureNavigationBar() {
        let logoImageView = UIImageView()
        logoImageView.widthAnchor.constraint(equalToConstant: 115).isActive = true
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = UIImage(named: "iconLogo")
        logoImageView.heroID = "logoImage"
        
        navigationBar.leftBarItem = logoImageView
    }
}
