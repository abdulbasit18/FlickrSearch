//
//  AppNavigationController.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 17/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit

class AppNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        navigationBar.barTintColor = .black
        navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(.avenirCondensedDemiBold, size: .standard(.h1))]
        navigationBar.backgroundColor = .black
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        viewController.navigationItem.backBarButtonItem = .init(title: "", style: .plain, target: nil, action: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

