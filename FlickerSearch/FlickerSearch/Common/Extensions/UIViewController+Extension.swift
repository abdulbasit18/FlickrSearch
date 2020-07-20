//
//  UIViewController+Extension.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 17/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit

extension UIViewController {
    var topBarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}
