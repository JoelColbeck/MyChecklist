//
//  NavigationBarView.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 26.09.2021.
//

import UIKit

class NavigationBarView: XibView {
    // MARK: - Outlets
    @IBOutlet weak var itemsStack: UIStackView!
    @IBOutlet private weak var leftItemsStack: UIStackView!
    @IBOutlet private weak var rightItemsStack: UIStackView!
    @IBOutlet private weak var leftBarItemView: UIView!
    @IBOutlet private weak var rightBarItemView: UIView!
    
    enum ItemPosition {
        case left, right
    }
    
    // MARK: - Public Properties
    var leftBarItems: [UIView]? {
        didSet {
            updateStacks()
        }
    }
    
    var rightBarItems: [UIView]? {
        didSet {
            updateStacks()
        }
    }
    
    var leftBarItem: UIView? {
        didSet {
            updateStacks()
        }
    }
    
    var rightBarItem: UIView? {
        didSet {
            updateStacks()
        }
    }
    
    // MARK: - Private Properties
    private var placeholderView: UIView {
        let view = UIView()
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return view
    }
    
    // MARK: - Private Methods
    private func updateStacks() {
        clearView()
        
        if let leftBarItem = leftBarItem {
            itemsStack.addArrangedSubview(leftBarItem)
            itemsStack.addArrangedSubview(placeholderView)
        }
        
        if let rightBarItem = rightBarItem {
            itemsStack.addArrangedSubview(placeholderView)
            if leftBarItem == nil {
                placeholderView.removeFromSuperview()
            }
            itemsStack.addArrangedSubview(rightBarItem)
        }
        
        if let leftBarItems = leftBarItems {
            leftBarItem?.removeFromSuperview()
            leftBarItems.forEach { item in
                leftItemsStack.addArrangedSubview(item)
            }
            leftItemsStack.addArrangedSubview(placeholderView)
            leftItemsStack.isHidden = false
        } else {
            leftItemsStack.isHidden = true
        }
        
        if let rightBarItems = rightBarItems {
            rightBarItem?.removeFromSuperview()
            rightBarItems.forEach { item in
                rightItemsStack.addArrangedSubview(item)
            }
            rightItemsStack.addArrangedSubview(placeholderView)
            rightItemsStack.isHidden = false
        } else {
            rightItemsStack.isHidden = true
        }
        configureConstraints()
    }
    
    private func configureConstraints() {
        leftBarItem?.heightAnchor.constraint(equalToConstant: 35).isActive = true
        rightBarItem?.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    private func clearView() {
        leftBarItem?.removeFromSuperview()
        rightBarItem?.removeFromSuperview()
        leftItemsStack.clear()
        rightItemsStack.clear()
    }
}
