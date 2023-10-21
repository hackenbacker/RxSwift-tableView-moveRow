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

final class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var editButton =
        if #available(iOS 17.0, *) {
            UIBarButtonItem(title: nil,
                            image: UIImage(systemName: "hand.point.up.left.and.text"),
                            target: nil, action: nil)
        } else {
            UIBarButtonItem(systemItem: .edit)
        }
    private var doneButton = UIBarButtonItem(systemItem: .done)
    private var refreshButton = UIBarButtonItem(systemItem: .refresh)
    
    let disposeBag = DisposeBag()
    var viewModel = TableViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = nil // 明示的にnilをセットしないとFatalErrorが発生する
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(CustomCell.nib, forCellReuseIdentifier: CustomCell.identifier)
        let isEditing = viewModel.editingMode.value.isEditing
        tableView.isEditing = isEditing
        updateEditButton(isEditing)
        setupBindings()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.downloadData()
    }
    
    private func setupBindings() {
        // itemsが更新された時の処理
        // 自前でセルを生成する場合
//        viewModel.items
//            .bind(to: tableView.rx.items) { (tableView, row, item) in
//                let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
//                                                         for: IndexPath(row: row, section: 0))
//                // iOS14 or later
//                var content = UIListContentConfiguration.valueCell()
//                content.text = item.title
//                content.secondaryText = item.subtitle
//                cell.contentConfiguration = content
//
//                // iOS13
//                //cell.textLabel?.text = item.title
//                //cell.detailTextLabel?.text = item.subtitle
//                return cell
//            }
//            .disposed(by: disposeBag)

        // itemsが更新された時の処理
        // カスタムセルを使わない場合
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

        // itemsが更新された時の処理
        // カスタムセルを扱う場合
//        viewModel.items
//            .bind(to: tableView.rx.items(cellIdentifier: CustomCell.identifier,
//                                         cellType: CustomCell.self)) { (row, element, cell) in
//                cell.configure(item: element)
//            }
//            .disposed(by: disposeBag)
        
        // itemsが更新された時の処理
        // カスタムDataSourceを使う場合
        viewModel.items
            .bind(to: tableView.rx.items(dataSource: MyDataSource()))
            .disposed(by: disposeBag)
        
        // cellを移動した時の処理
        tableView.rx.itemMoved
            .subscribe(onNext: { indexPaths in
                self.viewModel.moveItem(from: indexPaths.sourceIndex.row,
                                        to: indexPaths.destinationIndex.row)
            })
            .disposed(by: disposeBag)

        // editButtonがtapされた時の処理
        editButton.rx.tap.asDriver()
            .drive(onNext: { _ in
                self.viewModel.toggleEditingMode()
            })
            .disposed(by: disposeBag)

        // doneButtonがtapされた時の処理
        doneButton.rx.tap.asDriver()
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
        
        refreshButton.rx.tap.asDriver()
            .drive(onNext: { _ in
                self.viewModel.downloadData()
            })
            .disposed(by: disposeBag)
    }

    private func updateEditButton(_ isEditing: Bool) {
        if isEditing {
            self.navigationItem.rightBarButtonItems = [refreshButton, doneButton].reversed()
        } else {
            self.navigationItem.rightBarButtonItems = [refreshButton, editButton].reversed()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
