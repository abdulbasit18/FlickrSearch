//
//  Container+RegisterDependencies.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 29/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Swinject

extension Container {
    
    func registerDependencies() {
        self.registerServices()
        self.registerCoordinators()
        self.registerViewModels()
    }
}
