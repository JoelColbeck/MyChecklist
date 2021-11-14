//
//  AuthViewController.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 26.09.2021.
//

import UIKit
import Hero
import ProgressHUD

class AuthViewController: BaseViewController<AuthViewModel> {
    // MARK: - Outlets
    @IBOutlet weak var navigationBar: NavigationBarView! {
        didSet {
            let logoImageView = UIImageView()
            logoImageView.widthAnchor.constraint(equalToConstant: 115).isActive = true
            logoImageView.contentMode = .scaleAspectFit
            logoImageView.image = UIImage(named: "iconLogo")
            logoImageView.heroID = "logoImage"
            
            navigationBar.leftBarItem = logoImageView
            
            self.logoImageView = logoImageView
        }
    }
    
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
    weak var logoImageView: UIImageView!
    
    // MARK: - LC
    override func viewDidLoad() {
        super.viewDidLoad()
        isHeroEnabled = true
        ProgressHUD.animationType = .circleStrokeSpin
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
        
        newTestButton.rx.tap
            .bind(to: dataContext.passNewTestPublisher)
            .disposed(by: bag)
        
        dataContext.errorPublisher
            .subscribe(onNext: { [unowned self] error in
                textField.clear()
                showAlert(title: "Упс...", message: error, style: .alert)
                    .subscribe()
                    .disposed(by: bag)
            })
            .disposed(by: bag)
        
        dataContext.isLoading
            .subscribe(onNext: { isLoading in
                if isLoading {
                    ProgressHUD.show()
                } else {
                    ProgressHUD.dismiss()
                }
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
}
