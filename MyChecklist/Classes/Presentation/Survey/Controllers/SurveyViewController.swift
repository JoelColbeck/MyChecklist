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
            
            collectionView.isPagingEnabled = true
            collectionView.showsHorizontalScrollIndicator = false
            
            collectionView.collectionViewLayout = layout
            
            collectionView.dataSource = dataSource
            collectionView.delegate = self
            
            collectionView.register(nib: GenderQuestionCell.self)
            collectionView.register(nib: BodyMetricsCell.self)
        }
    }
    
    // MARK: - Public Properties
    typealias DataSource = UICollectionViewDiffableDataSource<Int, SurveyItemModel>
    
    // MARK: - Private Properties
    private lazy var dataSource = generateDataSource()
    
    // MARK: - LC
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}

extension SurveyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = collectionView.indexPathsForVisibleItems.first?.row ?? 0
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
                
                cell.selectedItem
                    .bind(to: dataContext.genderInput)
                    .disposed(by: bag)
                
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
                    .disposed(by: bag)
                
                return cell
                
            default:
                return nil
            }
        }
    }
}
