//
//  UIKitReuseIdentifier+Extension.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 17/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UICollectionViewCell: ReuseIdentifying {}
