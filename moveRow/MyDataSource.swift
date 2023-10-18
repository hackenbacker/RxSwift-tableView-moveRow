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

final class MyDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType {
    typealias Element = [Item]
    var items = [Item]()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier,
                                                 for: indexPath) as! CustomCell
        let item = items[indexPath.row]
        cell.configure(item: item)
        return cell
    }

    func tableView(_ tableView: UITableView, observedEvent: Event<[Item]>) {
        Binder(self) { dataSource, element in
            guard let items = element.element else { return }
            dataSource.items = items
            tableView.reloadData()
        }
        .onNext(observedEvent)
    }
}
