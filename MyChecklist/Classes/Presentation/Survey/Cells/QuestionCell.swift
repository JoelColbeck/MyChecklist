//
//  QuestionCell.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 22.04.2023.
//

import UIKit

typealias Question = Questionable & TitleConvertible & CaseIterable & Hashable

final class QuestionCell<T: Question>: UICollectionViewCell where T.AllCases.Index == Int {
    static var reuseId: String { T.surveyQuestion.id }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Should not use init(coder:)")
    }
    
    private func setupContent() {
        switch T.surveyQuestion.questionType {
        case .checkbox, .radio, .checkboxesCollection:
            let picker = PickerView<T>()
            content = picker
        default:
            break
        }
        content.forEach(addSubview)
        content.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @ConstraintActivator
    private func setupConstraints() {
        content?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: sideInset)
        content?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -sideInset)
        content?.topAnchor.constraint(equalTo: topAnchor)
        content?.bottomAnchor.constraint(equalTo: bottomAnchor)
    }
    
    private var content: UIView!
    private let title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22)
        return label
    }()
}

private let sideInset: CGFloat = 30
