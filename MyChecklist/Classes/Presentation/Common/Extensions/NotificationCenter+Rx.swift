//
//  NotificationCenter+Rx.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 09.07.2022.
//

import Foundation

import RxCocoa
import RxSwift

extension NotificationCenter {
    static func notification(
        _ name: Notification.Name,
        object: AnyObject? = nil
    ) -> Observable<Notification> {
        Self.default.rx.notification(name, object: object)
    }
    
    static var keyboardWillShow: Observable<Notification> {
        Self.default.rx.notification(UIResponder.keyboardWillShowNotification)
    }
    
    static var keyboardWillHide: Observable<Notification> {
        Self.default.rx.notification(UIResponder.keyboardWillHideNotification)
    }
}
