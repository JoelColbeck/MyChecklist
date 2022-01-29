//
//  BaseViewController.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 10.01.2022.
//

import UIKit
import RxSwift

class BaseViewController<TViewModel>: UIViewController, UIGestureRecognizerDelegate, UINavigationControllerDelegate
    where TViewModel: BaseViewModel {
    
    // MARK: - Private properties
    private(set) var bag = DisposeBag()
    private var throbber: UIThrobber!
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
    }()
    
    // MARK: - Public properties
    var needToHideNavBar: Bool = true
    
    weak var dataContext: TViewModel? {
        didSet {
            guard isViewLoaded else { return }
            bag = DisposeBag()
            applyBinding()
        }
    }
    
    var window: UIWindow {
        UIApplication.shared.windows[0]
    }
    
    var safeAreaInsets: UIEdgeInsets {
        return window.safeAreaInsets
    }
    
    var isAutoHideKeyboard: Bool {
        return false
    }
        
    // MARK: - Initializer
    convenience init() {
        self.init(nibName: Self.identifier)
    }
    
    convenience init(nibName nibNameOrNil: String?) {
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        throbber = UIThrobber(container: view, isBlurredBackground: true)
        
        dataContext?.initialize()
        dataContext?.viewCreated()
        completeUi()
        applyBinding()
        
        dataContext?.isLoading
            .bind(to: throbber.rx.isActive)
            .disposed(by: bag)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(needToHideNavBar, animated: animated)
        
        dataContext?.viewWillAppear()
        subscribeToKeyboardNotifications()
        subcribeToApplicationStateNotification()
        setupReachabilityListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataContext?.viewWillDisappear()
        unsubscribeFromKeyboardNotifications()
//        reachabilityManager?.stopListening()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataContext?.viewDidAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dataContext?.viewDidDisappear()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        #if DEBUG
        print("deinit of " + String(describing: self))
        #endif
    }
    
    func completeUi() { }
    
    func applyBinding() { }
    
    func handleKeyboardDidShown(_ keyboardBounds: CGRect) { }
    
    func handleKeyboardDidHidden(_ keyboardBounds: CGRect) { }
    
    func showAlert(title: String?, message: String?, style: UIAlertController.Style) -> Single<Void> {
        return .create { [weak self] obs in
            let alert = UIAlertController(title: title, message: message, preferredStyle: style)
            
            let okAction = UIAlertAction(title: "Ок", style: .default) { _ in
                obs(.success(()))
            }
            
            alert.addAction(okAction)
            
            self?.present(alert, animated: true)
            
            return Disposables.create()
        }
    }
    
    // MARK: - Private methods
    private func subscribeToKeyboardNotifications() {
        subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardShown))
        subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardHidden))
    }
    
    private func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unsubcribeToApplicationStateNotification() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    private func subcribeToApplicationStateNotification() {
        subscribeToNotification(UIApplication.didBecomeActiveNotification, selector: #selector(applicationDidBecomeActive))
        subscribeToNotification(UIApplication.willResignActiveNotification, selector: #selector(applicationWillResignActive))
    }
    
    private func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    private func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addTapRecognizerToHideKeyboard(_ target: UIView? = nil) {
        let target = target ?? view
        target?.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func removeTapRecognizerToHideKeyboard(_ target: UIView? = nil) {
        let target = target ?? view
        target?.removeGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupReachabilityListener() {
//        self.reachabilityManager?.startListening(onUpdatePerforming: { [weak self ] networkStatusListener in
//            guard let self = self else { return }
//            if networkStatusListener == .notReachable
//                || networkStatusListener == .unknown {
//                self.view.addSubview(self.noConnectionView)
//                UIView.animate(withDuration: 0.3) {
//                    self.noConnectionView.alpha = 1
//                }
//            } else {
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.noConnectionView.alpha = 0
//                }, completion: { _ in
//                    self.noConnectionView.removeFromSuperview()
//                })
//            }
//        })
    }
    
    // MARK: - Event handlers
    @objc
    private func keyboardShown(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] else {
            return
        }
        
        if isAutoHideKeyboard {
            addTapRecognizerToHideKeyboard()
        }
        
        let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
        handleKeyboardDidShown(endRect)
    }
    
    @objc
    private func keyboardHidden(notification: NSNotification) {
        guard  let userInfo = notification.userInfo,
               let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] else {
            return
        }
        
        if isAutoHideKeyboard {
            removeTapRecognizerToHideKeyboard()
        }
        
        let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
        handleKeyboardDidHidden(endRect)
        
    }
    
    @objc
    private func applicationDidBecomeActive() {
        setupReachabilityListener()
    }
    
    
    @objc
    private func applicationWillResignActive() {
//        reachabilityManager?.stopListening()
    }
    
    @objc
    private func handleTap(sender: UITapGestureRecognizer? = nil) {
        window.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard
            let navigationVC = navigationController,
            gestureRecognizer == navigationVC.interactivePopGestureRecognizer
        else {
            return true
        }
        
        return navigationVC.viewControllers.count > 1
    }
}
