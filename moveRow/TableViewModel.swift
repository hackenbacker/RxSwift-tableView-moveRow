//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
// Copyright (c) 2023 Hackenbacker.
//
// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php
//
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

import Foundation
import RxSwift
import RxRelay

class TableViewModel {
    enum EditingState {
        case edit
        case done
    }

    var editingState = BehaviorRelay(value: EditingState.done)
    lazy var items = BehaviorRelay(value: makeData())

    /// アイテム数を返す.
    var numberOfItems: Int {
        items.value.count
    }

    /// 編集状態をトグルする.
    func toggleEditingState() {
        switch editingState.value {
        case .edit:
            editingState.accept(.done)
        case .done:
            editingState.accept(.edit)
        }
    }
    
    ///  Itemを移動する.
    /// - Parameters:
    ///   - sourceIndex: 移動元のindex.
    ///   - destinationIndex:  移動先のindex.
    func moveItem(from sourceIndex: Int, to destinationIndex: Int) {
        var mutableItems = items.value
        let item = mutableItems.remove(at: sourceIndex)
        mutableItems.insert(item, at: destinationIndex)
        items.accept(mutableItems)
    }
    
    /// 指定したindexのItemを取得する.
    /// - Parameter index: 所得したいデータのindex.
    /// - Returns: 取得したItem.
    func getItem(at index: Int) -> Item {
        items.value[index]
    }
    
    /// 初期データを作成する.
    private func makeData() -> [Item] {
        (1...100).map { n in
            Item(id: n, title: "\(n)番目", subtitle: "\(String(format: "%04x", n))")
        }
    }
}
