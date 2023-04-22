//
//  SurveyController.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 22.04.2023.
//

import UIKit

import RxSwift

typealias SurveyDataSource = UICollectionViewDiffableDataSource<Int, SurveyQuestion>

extension SurveyDataSource {
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>
}

final class SurveyController: UIViewController {
    init(surveyService: SurveyService) {
        self.surveyService = surveyService
        self.viewModel = SurveyViewModel(surveyService: surveyService)
        super.init(nibName: nil, bundle: nil)
        
        viewModel.snapshot
            .subscribe(onNext: { [weak dataSource] snapshot in dataSource?.apply(snapshot) })
            .disposed(by: bag)
    }

    required init?(coder: NSCoder) {
        fatalError("Should not use init(coder:)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        configureViews()
        setupConstraints()
    }
    
    private func configureViews() {
        collectionView.dataSource = dataSource
        collectionView.delegate = collectionViewDelegate
        view.addSubview(collectionView)

        view.addSubview(navigationBar)
        view.backgroundColor = .white
        navigationBar.set(title: surveyService.title)
    }

    @ConstraintActivator
    private func setupConstraints() {
        navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        navigationBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 10)

        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        collectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 30)
    }


    // MARK: Views
    private let navigationBar = SurveyNavigationBar()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(QuestionCell<Gender>.self, forCellWithReuseIdentifier: QuestionCell<Gender>.reuseId)
        return collectionView
    }()
    
    // MARK: Models
    private let viewModel: SurveyViewModel
    private let surveyService: SurveyService
    private lazy var dataSource: SurveyDataSource = generateDataSource()
    private let collectionViewDelegate = Delegate()
    private let bag = DisposeBag()
}

extension SurveyController {
    private func generateDataSource() -> SurveyDataSource {
        SurveyDataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuestionCell<Gender>.reuseId, for: indexPath) as? QuestionCell<Gender> else { return nil }
            return cell
        }
    }
}

extension SurveyController {
    private final class Delegate: NSObject, UICollectionViewDelegateFlowLayout {
        func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
            CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
}
