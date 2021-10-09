//
//  ChecklistViewController.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 08.10.2021.
//

import UIKit

class ChecklistViewController: BaseViewController<ChecklistViewModel> {
    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.allowsSelection = false
            tableView.register(nib: YearViewCell.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
