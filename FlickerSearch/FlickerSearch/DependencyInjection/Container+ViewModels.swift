//
//  Container+ViewModels.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 29/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import Swinject
import SwinjectAutoregistration

extension Container {
    
    func registerViewModels() {
        self.autoregister(PhotosListViewModelProtocol.self, initializer: PhotosListViewModel.init)
        self.autoregister(PhotoDetailViewModelProtocol.self, initializer: PhotoDetailViewModel.init)    
    }
}
