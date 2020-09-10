//
//  Container+Coordinators.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 29/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Swinject

extension Container {
    
    func registerCoordinators() {
        self.autoregister(PhotoListNavigatorProtocol.self, initializer: PhotoListNavigator.init)
        self.autoregister(AppNavigator.self, initializer: AppNavigator.init)
    }
}
