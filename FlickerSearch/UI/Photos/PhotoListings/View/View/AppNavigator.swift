//
//  AppNavigator.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 19/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit

protocol AppNavigatorProtocol {
    func installRoot(in window: UIWindow)
}

struct AppNavigator { //: AppNavigatorProtocol {
    
    func installRoot(into window: UIWindow) {
        // controller create & setup
        let storyboard = UIStoryboard(storyboard: .photos)
        let photoListController: PhotoListViewController = storyboard.initialViewController()
        let rootController = AppNavigationController(rootViewController: photoListController)
        let navigator = PhotoListNavigator(navigationController: rootController)
        
        let viewModel = PhotosListViewModel(photosService: AppDelegate.container.resolve(PhotosServiceProtocol.self)!,
                                            navigator: navigator)
        
        photoListController.viewModel = viewModel
        
        window.rootViewController = rootController
    }
}
