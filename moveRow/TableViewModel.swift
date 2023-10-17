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

final class TableViewModel {
    enum EditingMode {
        case edit
        case done
        
        var isEditing: Bool {
            self == .edit
        }
    }

    var editingMode = BehaviorRelay<EditingMode>(value: .done)
    lazy var items = BehaviorRelay<[Item]>(value: makeData())

    /// 編集状態をトグルする.
    func toggleEditingMode() {
        switch editingMode.value {
        case .edit:
            editingMode.accept(.done)
        case .done:
            editingMode.accept(.edit)
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
    
    /// 初期データを作成する.
    private func makeData() -> [Item] {
        (1...100).map { n in
            Item(id: n, title: "\(n)番目", subtitle: "\(String(format: "%04x", n))")
        }
    }
}