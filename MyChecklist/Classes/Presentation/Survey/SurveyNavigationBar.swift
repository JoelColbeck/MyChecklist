//
//  SurveyNavigationBar.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 22.04.2023.
//

import UIKit

import RxCocoa
import RxSwift

final class SurveyNavigationBar: UIView {
    var backButtonTapped: Observable<Void> {
        backButton.rx.tap
            .asObservable()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Should not use init(coder:)")
    }

    func set(title: String) {
        self.title.text = title
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 30, weight: .semibold)
        addSubview(title)
        
        var config = UIButton.Configuration.plain()
        config.title = nil
        config.image = UIImage(systemDescriptor: .surveyBackButton)
        config.baseForegroundColor = .black
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.configuration = config
        addSubview(backButton)
    }

    @ConstraintActivator
    private func setupConstraints() {
        backButton.leadingAnchor.constraint(equalTo: leadingAnchor)
        backButton.widthAnchor.constraint(equalToConstant: 20)
        backButton.heightAnchor.constraint(equalTo: title.heightAnchor)
        backButton.centerYAnchor.constraint(equalTo: title.centerYAnchor)
        
        title.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 15)
        title.trailingAnchor.constraint(equalTo: trailingAnchor)
        title.topAnchor.constraint(equalTo: topAnchor)
        title.bottomAnchor.constraint(equalTo: bottomAnchor)
    }

    private let backButton = UIButton()
    private let title = UILabel()
}
