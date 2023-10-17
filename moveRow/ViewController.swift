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
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    let disposeBag = DisposeBag()
    var viewModel = TableViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = nil // 明示的にnilをセットしないとFatalErrorが発生する
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let isEditing = viewModel.editingMode.value.isEditing
        tableView.isEditing = isEditing
        updateEditButton(isEditing)
        setupBindings()
    }

    private func setupBindings() {
        // itemsが更新された時の処理
        viewModel.items
            .bind(to: tableView.rx.items) { (tableView, row, item) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                         for: IndexPath(row: row, section: 0))
                // iOS14 or later
                var content = UIListContentConfiguration.valueCell()
                content.text = item.title
                content.secondaryText = item.subtitle
                cell.contentConfiguration = content

                // iOS13
                //cell.textLabel?.text = item.title
                //cell.detailTextLabel?.text = item.subtitle
                return cell
            }
            .disposed(by: disposeBag)

        // itemsが更新された時の処理
//        viewModel.items
//            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { row, item, cell in
//                // iOS14 or later
//                var content = UIListContentConfiguration.valueCell()
//                content.text = item.title
//                content.secondaryText = item.subtitle
//                cell.contentConfiguration = content
//
//                // iOS13
//                //cell.textLabel?.text = item.title
//                //cell.detailTextLabel?.text = item.subtitle
//            }
//            .disposed(by: disposeBag)
        
        // cellを移動した時の処理
        tableView.rx.itemMoved
            .subscribe(onNext: { indexPaths in
                self.viewModel.moveItem(from: indexPaths.sourceIndex.row,
                                        to: indexPaths.destinationIndex.row)
            })
            .disposed(by:disposeBag)

        // editButtonがtapされた時の処理
        editButton.rx.tap.asDriver()
            .drive(onNext: { _ in
                self.viewModel.toggleEditingMode()
            })
            .disposed(by: disposeBag)

        // editModeが更新された時の処理
        viewModel.editingMode
            .subscribe(onNext: { editingMode in
                let isEditing = editingMode.isEditing
                self.tableView.isEditing = isEditing
                self.updateEditButton(isEditing)
            })
            .disposed(by: disposeBag)
    }

    private func updateEditButton(_ isEditing: Bool) {
        if isEditing {
            editButton.image = UIImage(systemName: "hand.point.up.left.and.text")
        } else {
            editButton.image = UIImage(systemName: "list.bullet")
        }
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

//extension ViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView,
//                   numberOfRowsInSection section: Int) -> Int {
//        viewModel.numberOfItems
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let row = indexPath.row
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = viewModel.getItem(at: row).title
//        cell.detailTextLabel?.text = viewModel.getItem(at: row).subtitle
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView,
//                   moveRowAt sourceIndexPath: IndexPath,
//                   to destinationIndexPath: IndexPath) {
//        viewModel.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
//    }
//}
