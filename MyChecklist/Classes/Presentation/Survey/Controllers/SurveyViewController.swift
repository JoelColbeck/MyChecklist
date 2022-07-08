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
            collectionView.register(class: RelativeOncologyCell.self)
            collectionView.register(
                TitleCell.self,
                forCellWithReuseIdentifier: String(describing: ProstateCancerDetails.self)
            )
            collectionView.register(
                TitleCell.self,
                forCellWithReuseIdentifier: String(describing: StomachCancerDetails.self)
            )
            collectionView.register(
                TitleCell.self,
                forCellWithReuseIdentifier: String(describing: ColonCancerDetails.self)
            )
        }
    }
    weak var tapGesture: UITapGestureRecognizer!
    
    // MARK: - Public Properties
    typealias DataSource = UICollectionViewDiffableDataSource<Int, SurveyItemModel>
    
    
    
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
    
    // MARK: - Private Properties
    
    private lazy var dataSource = generateDataSource()
    
    private lazy var prostateCancerRadio = RadioListView<ProstateCancerDetails?>()
    private lazy var stomachCancerRadio = RadioListView<StomachCancerDetails?>()
    private lazy var colonCancerRadio = RadioListView<ColonCancerDetails?>()
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
        
        view.endEditing(true)
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
                            withReuseIdentifier: GenderQuestionCell.identifier,
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
                            withReuseIdentifier: BodyMetricsCell.identifier,
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
                            withReuseIdentifier: SmokeAlcoholCell.identifier,
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
                            withReuseIdentifier: BloodPressureCell.identifier,
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
                            withReuseIdentifier: AdditionalQuestionsCell.identifier,
                            for: indexPath
                        ) as? AdditionalQuestionsCell
                else { return nil }
                
                cell.cholesterolSelectedObservable
                    .bind(to: dataContext.highCholesterolInput)
                    .disposed(by: cell.bag)
                
                cell.diabetesSelectedObservable
                    .bind(to: dataContext.diabetesInput)
                    .disposed(by: cell.bag)
                
                cell.brokenBonesSelectedObservable
                    .bind(to: dataContext.brokenBonesInput)
                    .disposed(by: cell.bag)
                
                return cell
                
            case .familyDiseases:
                guard let cell = collectionView
                        .dequeueReusableCell(
                            withReuseIdentifier: FamilyDiseasesCell.identifier,
                            for: indexPath
                        ) as? FamilyDiseasesCell
                else { return nil }
                
                cell.heartAttackSelected
                    .bind(to: dataContext.familyHeartAttackInput)
                    .disposed(by: cell.bag)
                
                cell.strokeSelected
                    .bind(to: dataContext.familyStrokeInput)
                    .disposed(by: cell.bag)
                
                cell.hipFractureSelected
                    .bind(to: dataContext.familyHipFractureInput)
                    .disposed(by: cell.bag)
                
                cell.diabetesSelected
                    .bind(to: dataContext.familyDiabetesInput)
                    .disposed(by: cell.bag)
                
                return cell
            case .chronicDiseases:
                guard let cell = collectionView
                        .dequeueReusableCell(
                            withReuseIdentifier: ChronicDiseasesCell.identifier,
                            for: indexPath
                        ) as? ChronicDiseasesCell
                else { return nil }
                
                cell.lungsSelected
                    .bind(to: dataContext.chronicLungsInput)
                    .disposed(by: cell.bag)
                
                cell.cardioSelected
                    .bind(to: dataContext.chronicCardioInput)
                    .disposed(by: cell.bag)
                
                cell.liverSelected
                    .bind(to: dataContext.chronicLiverInput)
                    .disposed(by: cell.bag)
                
                cell.stomachSelected
                    .bind(to: dataContext.chronicStomachInput)
                    .disposed(by: cell.bag)
                
                cell.kidneysSelected
                    .bind(to: dataContext.chronicKidneysInput)
                    .disposed(by: cell.bag)
                
                cell.hivSelected
                    .bind(to: dataContext.chronicHivInput)
                    .disposed(by: cell.bag)
                
                return cell
            case let .relativeOncology(gender):
                guard let cell = collectionView
                        .dequeueReusableCell(
                            withReuseIdentifier: RelativeOncologyCell.identifier,
                            for: indexPath
                        ) as? RelativeOncologyCell
                else { return nil }
                
                cell.setup(with: gender)
                
                cell.prostateSelected
                    .bind(to: dataContext.relativeProstateInput)
                    .disposed(by: cell.bag)
                
                cell.cervicalSelected
                    .bind(to: dataContext.relativeCervicalInput)
                    .disposed(by: cell.bag)
                
                cell.colonSelected
                    .bind(to: dataContext.relativeColonInput)
                    .disposed(by: cell.bag)
                
                cell.stomachSelected
                    .bind(to: dataContext.relativeStomachInput)
                    .disposed(by: cell.bag)
                
                cell.lungsSelected
                    .bind(to: dataContext.relativeLungsInput)
                    .disposed(by: cell.bag)
                
                cell.melanomaSelected
                    .bind(to: dataContext.relativeMelanomaInput)
                    .disposed(by: cell.bag)

                return cell
            case .prostateCancerDetails, .colonCancerDetails, .stomachCancerDetails:
                guard let cell = collectionView
                    .dequeueReusableCell(
                        withReuseIdentifier: String(describing: ProstateCancerDetails.self),
                        for: indexPath
                    ) as? TitleCell
                else { return nil }
                
                let title: String
                let radioView: UIView
                
                switch itemIdentifier {
                case .prostateCancerDetails:
                    title = "простаты"
                    radioView = prostateCancerRadio
                case .colonCancerDetails:
                    title = "прямой кишки"
                    radioView = colonCancerRadio
                case .stomachCancerDetails:
                    title = "желудка"
                    radioView = stomachCancerRadio
                default:
                    assertionFailure("Should not be called here")
                    title = ""
                    radioView = UIView()
                    break
                }
                
                cell.setup(
                    title: "Пожалуйста, расскажите подробнее про рак \(title) у родственников",
                    view: radioView
                )
                
                return cell
            }
        }
    }
}
