//
//  MainViewController.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 13.03.2023.
//

import UIKit

final class MainViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Should not use init(coder:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let navigationBar = NavigationBarView()
        navigationBar.setup(title: Localization.mainTitle)
        view.addSubview(navigationBar)
        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        present(SurveyController(surveyService: CommonSurveyService()), animated: true)
    }
}

enum Page: CaseIterable {
    case currentYear
    case futureYear
    case checklists
}
