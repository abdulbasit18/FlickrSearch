//
//  AppNavigator.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 19/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit

// swiftlint:disable force_cast
protocol AppNavigatorProtocol {
    func installRoot(in window: UIWindow)
}

struct AppNavigator { //: AppNavigatorProtocol {
    
    func installRoot(into window: UIWindow) {
        // controller create & setup
        let storyboard = UIStoryboard(storyboard: .photos)
        let photoListController: PhotoListViewController = storyboard.initialViewController()
        let rootController = AppNavigationController(rootViewController: photoListController)
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let coreDataManager = CoreDataManger(context: context)
        
        window.rootViewController = rootController
    }
}
// swiftlint:enable force_cast
