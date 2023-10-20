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
    
    /// Retrieves a view with its object type.
   /// - Parameters:
   ///   - clazz: Type of the view.
   ///   - fromNib: The name of the nib file.
   /// - Returns: Retrieved view.
//   static func retrieveView<T: UIView>(_ clazz: T.Type, fromNib: String? = nil) -> T? {
//       let nibName: String = fromNib ?? clazz.className
//       let nib = UINib(nibName: nibName, bundle: nil)
//
//       if let view = nib.instantiate(withOwner: nil, options: nil)
//           .first(where: { ($0 as AnyObject).isKind(of: clazz) }) {
//           return (view as! T)
//       }
//
//       return nil
//   }
}

//extension NSObject {
//    
//    /// Tells a class name for a class type.
//    /// - returns: a simple name.
//    /// - note: Class.className => "Class"
//    class var className: String {
//        return String(describing: self)
//    }
//    
//    /// Tells a class name for an instance.
//    /// - returns: a simple name.
//    /// - note: Instance.className => "Instance"
//    var className: String {
//        return type(of: self).className
//    }
//}
