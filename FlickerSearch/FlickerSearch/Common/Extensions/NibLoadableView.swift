//
//  NibLoadableView.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 17/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit

protocol NibLoadableView: class { static var nibName: String { get } }
// swiftlint:disable force_cast
extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    static func loadNib() -> Self {
        let bundle = Bundle(for: Self.self)
        let nib = UINib(nibName: Self.nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }
}

// swiftlint:enable force_cast
