//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
// Copyright (c) 2023 Hackenbacker.
//
// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php
//
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

import UIKit

final class CustomCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    static var identifier: String {
        String(describing: self)
    }
    static var nib: UINib {
        UINib(nibName: identifier, bundle: nil)
    }

    func configure(item: Item) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
    }
}
