//
//  ChecklistViewController.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 08.10.2021.
//

import UIKit
import RxDataSources

final class ChecklistViewController: BaseViewController<ChecklistViewModel> {
    // MARK: - Outlets
    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.allowsSelection = false
            tableView.register(nib: YearViewCell.self)
        }
    }
    
    // MARK: - Public Properties
    typealias Section = ChecklistViewModel.SectionModel
    typealias Item = ChecklistViewModel.ItemModel
    typealias DataSource = RxTableViewSectionedReloadDataSource<Section>
    
    // MARK: - Private Properties
    private lazy var dataSource = generateDataSource()
    
    // MARK: - LC
    override func applyBinding() {
        guard let dataContext = dataContext else { return }
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: bag)
        
        dataContext.sections
            .debug("ChecklistYearModel", trimOutput: true)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
}

extension ChecklistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

private extension ChecklistViewController {
    func generateDataSource() -> DataSource {
        .init { dataSource, tableView, indexPath, item in
            switch item {
            case .year(let model):
                guard
                    let cell = tableView.dequeueReusableCell(withIdentifier: YearViewCell.identifier) as? YearViewCell
                else { return .init() }
                
                cell.configure(model: model)
                
                return cell
            }
        }
    }
}
