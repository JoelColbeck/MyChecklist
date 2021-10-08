//
//  AuthViewController.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 26.09.2021.
//

import UIKit
import Hero

class AuthViewController: BaseViewController<AuthViewModel> {
    // MARK: - Outlets
    @IBOutlet weak var navigationBar: NavigationBarView!
    @IBOutlet weak var textField: SeparatedTextField!
    @IBOutlet weak var newTestButton: UIButton!
    @IBOutlet weak var helpButton: UIButton! {
        didSet {
            let attributes: [NSAttributedString.Key : Any] = [
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
            
            helpButton.setAttributedTitle(
                NSAttributedString(
                    string: "Что такое «Мой чеклист»?",
                    attributes: attributes),
                for: .normal)
        }
    }
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - LC
    override func viewDidLoad() {
        super.viewDidLoad()
        isHeroEnabled = true
        configureNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.clear()
    }
    
    override func applyBinding() {
        guard let dataContext = dataContext else { return }
        
        helpButton.rx.tap
            .bind(to: dataContext.closed)
            .disposed(by: bag)
        
        textField.codeObservable
            .bind(to: dataContext.sendCodePublisher)
            .disposed(by: bag)
        
        dataContext.errorPublisher
            .subscribe(onNext: { [unowned self] error in
                showAlert(title: "Упс...", message: error, style: .alert)
                    .subscribe()
                    .disposed(by: bag)
            })
            .disposed(by: bag)
    }
    
    override func handleKeyboardDidShown(_ keyboardBounds: CGRect) {
        bottomConstraint.constant = -30 - keyboardBounds.height
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func handleKeyboardDidHidden(_ keyboardBounds: CGRect) {
        bottomConstraint.constant = -30
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
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
