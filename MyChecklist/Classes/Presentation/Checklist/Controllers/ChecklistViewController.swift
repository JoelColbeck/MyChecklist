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
    @IBOutlet weak var navigationBar: NavigationBarView! {
        didSet {
            
            let logoImageView = UIImageView()
            logoImageView.widthAnchor.constraint(equalToConstant: 115).isActive = true
            logoImageView.contentMode = .scaleAspectFit
            logoImageView.image = UIImage(named: "iconLogo")
            logoImageView.heroID = "logoImage"
            
            let pinCodeView = PinCodeView()
            pinCodeView.configure(code: "7271")
            
            let shareButton = UIButton()
            shareButton.setTitle("", for: .normal)
            shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
            shareButton.tintColor = .label
            self.shareButton = shareButton
            
            let closeButton = UIButton()
            closeButton.setTitle("", for: .normal)
            closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            closeButton.tintColor = .label
            self.closeButton = closeButton
            
            navigationBar.leftBarItems = [logoImageView, pinCodeView, shareButton]
            navigationBar.rightBarItems = [closeButton]
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.allowsSelection = false
            tableView.register(nib: YearViewCell.self)
        }
    }
    
    weak var shareButton: UIButton!
    weak var closeButton: UIButton!
    
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
        
        closeButton.rx.tap
            .bind(to: dataContext.closed)
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
