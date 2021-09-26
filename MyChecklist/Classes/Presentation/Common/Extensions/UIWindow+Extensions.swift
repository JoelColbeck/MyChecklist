//
//  UIWindow+Extensions.swift
//  mercury-ios
//
//  Created by Данил Коротаев on 05.07.2021.
//  Copyright © 2021 Trinity Monsters. All rights reserved.
//

import UIKit

extension UIWindow {
    func setRoot(viewController: UIViewController, withAnimation: Bool) {
        if !withAnimation {
            self.rootViewController = viewController
            self.makeKeyAndVisible()
            return
        }

        if let snapshot = self.snapshotView(afterScreenUpdates: true) {
            viewController.view.addSubview(snapshot)
            self.rootViewController = viewController
            self.makeKeyAndVisible()
            
            UIView.animate(withDuration: 0.4, animations: {
                snapshot.layer.opacity = 0
            }, completion: { _ in
                snapshot.removeFromSuperview()
            })
        }
    }
}
