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
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let coreDataManager = CoreDataManger(context: context)
            //View Model create & setup
            let remoteDataSource = PhotosRemoteDataStore()
            let localDataSource = PhotosLocalDataSource(localDBManager: coreDataManager)
            let repository = PhotosRepository(remotePhotosDataSource: remoteDataSource,
                                              localPhotosDataSource: localDataSource)
            let service = PhotosService(photosRepository: repository)
            let navigator = PhotoListNavigator(navigationController: rootController)
            let viewModel = PhotosListViewModel(photosService: service,
                                                navigator: navigator)
            
            photoListController.viewModel = viewModel
        }
        window.rootViewController = rootController
    }
}
