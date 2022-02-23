//
//  SurveyViewController.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 14.11.2021.
//

import UIKit
import RxCocoa
import RxSwift

typealias SurveySnapshot = NSDiffableDataSourceSnapshot<Int, SurveyItemModel>

final class SurveyViewController: BaseViewController<SurveyViewModel> {
    // MARK: - Outlets
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            
            collectionView.isPagingEnabled = true
            collectionView.showsHorizontalScrollIndicator = false
            
            collectionView.collectionViewLayout = layout
            
            collectionView.dataSource = dataSource
            collectionView.delegate = self
            
            collectionView.register(nib: GenderQuestionCell.self)
            collectionView.register(nib: BodyMetricsCell.self)
            collectionView.register(nib: SmokeAlcoholCell.self)
            collectionView.register(nib: BloodPressureCell.self)
            collectionView.register(nib: AdditionalQuestionsCell.self)
            collectionView.register(nib: FamilyDiseasesCell.self)
            collectionView.register(class: ChronicDiseasesCell.self)
        }
    }
    weak var tapGesture: UITapGestureRecognizer!
    
    // MARK: - Public Properties
    typealias DataSource = UICollectionViewDiffableDataSource<Int, SurveyItemModel>
    
    // MARK: - Private Properties
    private lazy var dataSource = generateDataSource()
    
    // MARK: - LC
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHidingKeyboard()
    }
    
    override func applyBinding() {
        guard let dataContext = dataContext else { return }
        
        dataContext.snapshotOutput
            .subscribe(onNext: { [unowned self] snapshot in
                dataSource.apply(snapshot)
            })
            .disposed(by: bag)
        
        dataContext.numberOfQuestionsOutput
            .bind(to: pageControl.rx.numberOfPages)
            .disposed(by: bag)
    }
    
    deinit {
        dataContext?.closed.accept(())
    }
    
    // MARK: - Private Methods
    private func configureHidingKeyboard() {
        let tap = UITapGestureRecognizer()
        view.addGestureRecognizer(tap)
        
        tap.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: bag)
        
        self.tapGesture = tap
    }
}

extension SurveyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = collectionView.contentOffset.x
        let cellWidth = collectionView.frame.width
        
        let cellNumber = Int((offset / cellWidth).rounded(.toNearestOrEven))
        
        pageControl.currentPage = cellNumber
    }
}

// MARK: - Generate DataSource
private extension SurveyViewController {
    func generateDataSource() -> DataSource {
        .init(collectionView: collectionView) { [unowned self] collectionView, indexPath, itemIdentifier in
            guard let dataContext = dataContext else { return nil }
            
            switch itemIdentifier {
            case .gender:
                guard let cell = collectionView
                        .dequeueReusableCell(
                            withReuseIdentifier: "GenderQuestionCell",
                            for: indexPath
                        ) as? GenderQuestionCell
                else { return nil }
                
                let genderViewModel = GenderQuestionViewModel()
                cell.viewModel = genderViewModel
                
                genderViewModel.genderOutput
                    .bind(to: dataContext.genderInput)
                    .disposed(by: cell.bag)
                
                return cell
                
            case .bodyMetrics:
                guard let cell = collectionView
                        .dequeueReusableCell(
                            withReuseIdentifier: "BodyMetricsCell",
                            for: indexPath
                        ) as? BodyMetricsCell
                else { return nil }
                
                cell.ageValue
                    .bind(to: dataContext.ageInput)
                    .disposed(by: cell.bag)
                
                cell.heightValue
                    .bind(to: dataContext.heightInput)
                    .disposed(by: cell.bag)
                
                cell.weightValue
                    .bind(to: dataContext.weightInput)
                    .disposed(by: cell.bag)
                
                return cell
                
            case .smokeAlcohol:
                guard let cell = collectionView
                        .dequeueReusableCell(
                            withReuseIdentifier: "SmokeAlcoholCell",
                            for: indexPath
                        ) as? SmokeAlcoholCell
                else { return nil }
                
                let smokeAlcoholViewModel = SmokeAlcoholViewModel()
                cell.viewModel = smokeAlcoholViewModel
                
                smokeAlcoholViewModel.selectedSmoke
                    .bind(to: dataContext.smokeInput)
                    .disposed(by: cell.bag)
                
                smokeAlcoholViewModel.selectedAlcohol
                    .bind(to: dataContext.alcoholInput)
                    .disposed(by: cell.bag)
                
                return cell
                
            case .bloodPressure:
                guard let cell = collectionView
                        .dequeueReusableCell(
                            withReuseIdentifier: "BloodPressureCell",
                            for: indexPath
                        ) as? BloodPressureCell
                else { return nil }
                
                let bloodViewModel = BloodPressureViewModel()
                cell.viewModel = bloodViewModel
                
                bloodViewModel.bloodPressureOutput
                    .bind(to: dataContext.bloodPressureInput)
                    .disposed(by: cell.bag)
                
                return cell
            case .additionalQuestions:
                guard let cell = collectionView
                        .dequeueReusableCell(
                            withReuseIdentifier: "AdditionalQuestionsCell",
                            for: indexPath
                        ) as? AdditionalQuestionsCell
                else { return nil }
                
                cell.cholesterolSelectedObservable
                    .bind(to: dataContext.highCholesterolInput)
                    .disposed(by: cell.bag)
                
                cell.diabetesSelectedObservable
                    .bind(to: dataContext.diabetesInput)
                    .disposed(by: bag)
                
                cell.brokenBonesSelectedObservable
                    .bind(to: dataContext.brokenBonesInput)
                    .disposed(by: bag)
                
                return cell
                
            case .familyDiseases:
                guard let cell = collectionView
                        .dequeueReusableCell(
                            withReuseIdentifier: "FamilyDiseasesCell",
                            for: indexPath
                        ) as? FamilyDiseasesCell
                else { return nil }
                
                cell.heartAttackSelected
                    .bind(to: dataContext.familyHeartAttackInput)
                    .disposed(by: cell.bag)
                
                cell.strokeSelected
                    .bind(to: dataContext.familyStrokeInput)
                    .disposed(by: bag)
                
                cell.hipFractureSelected
                    .bind(to: dataContext.familyHipFractureInput)
                    .disposed(by: bag)
                
                cell.diabetesSelected
                    .bind(to: dataContext.familyDiabetesInput)
                    .disposed(by: bag)
                
                return cell
            case .chronicDiseases:
                guard let cell = collectionView
                        .dequeueReusableCell(
                            withReuseIdentifier: "ChronicDiseasesCell",
                            for: indexPath
                        ) as? ChronicDiseasesCell
                else { return nil }
                
                cell.lungsSelected
                    .bind(to: dataContext.chronicLungsInput)
                    .disposed(by: cell.bag)
                
                cell.cardioSelected
                    .bind(to: dataContext.chronicCardioInput)
                    .disposed(by: bag)
                
                cell.liverSelected
                    .bind(to: dataContext.chronicLiverInput)
                    .disposed(by: cell.bag)
                
                cell.stomachSelected
                    .bind(to: dataContext.chronicStomachInput)
                    .disposed(by: bag)
                
                cell.kidneysSelected
                    .bind(to: dataContext.chronicKidneysInput)
                    .disposed(by: bag)
                
                cell.hivSelected
                    .bind(to: dataContext.chronicHivInput)
                    .disposed(by: bag)
                
                return cell
            }
        }
    }
}
