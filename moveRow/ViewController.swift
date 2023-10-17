//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
// Copyright (c) 2023 Hackenbacker.
//
// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php
//
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    let disposeBag = DisposeBag()
    var viewModel = TableViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isEditing = false
        updateEditButton(to: .done)
        setupBindings()
    }

    private func setupBindings() {
        viewModel.editingState.asObservable()
            .subscribe(onNext: { editingState in
                if case .edit = editingState {
                    self.tableView.isEditing = true
                } else {
                    self.tableView.isEditing = false
                }
                self.updateEditButton(to: editingState)
            })
            .disposed(by: disposeBag)
    }

    private func updateEditButton(to editingState: TableViewModel.EditingState) {
        if case .edit = editingState {
            editButton.image = UIImage(systemName: "hand.point.up.left.and.text")
        } else {
            editButton.image = UIImage(systemName: "list.bullet")
        }
    }

    @IBAction func editButtonTapped(_ sender: Any) {
        viewModel.toggleEditingState()
    }
}

extension ViewController: UITableViewDelegate {
    // 並び替えのみ有効にする (ここから)
    // 赤丸(-)や緑丸(+)を表示しない
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    // インデントを付けない
    func tableView(_ tableView: UITableView,
                   shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    // 並び替えのみ有効にする (ここまで)
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.getItem(at: row).title
        cell.detailTextLabel?.text = viewModel.getItem(at: row).subtitle
        return cell
    }

    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        viewModel.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}
