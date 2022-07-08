//
//  TitleCell.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 03.07.2022.
//

import UIKit

final class TitleCell: BaseCollectionViewCell {
    
    override func initialize() {
        super.initialize()
        addSubview(titleLabel)
    }
    
    func setup(title: String, view: UIView) {
        titleLabel.text = title
        oldView?.removeFromSuperview()
        oldView = view
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: spacing),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingMargin),
        ])
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .gilroyBold(ofSize: UIConstants.headerFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var oldView: UIView?
    private var wasSet = false
}

private let leadingMargin: CGFloat = 20
private let spacing: CGFloat = -16
