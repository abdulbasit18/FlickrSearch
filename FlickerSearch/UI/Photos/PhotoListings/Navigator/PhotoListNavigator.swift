//
//  PhotoListNavigator.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 19/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit

protocol PhotoListNavigatorProtocol {
    func navigateToDetail(with photo: PhotoDTO)
}

final class PhotoListNavigator: PhotoListNavigatorProtocol {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateToDetail(with photo: PhotoDTO) {
        
        // controller create & setup
        let storyboard = UIStoryboard(storyboard: .photos)
        let photoDetailController: PhotoDetailViewController = storyboard.instantiateViewController()
        //View Model create & setup
        let viewModel = PhotoDetailViewModel(photo: photo)
        photoDetailController.viewModel = viewModel
        navigationController?.pushViewController(photoDetailController, animated: true)

    }
}
