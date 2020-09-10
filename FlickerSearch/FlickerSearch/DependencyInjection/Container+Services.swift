//
//  Container+Services.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 29/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Swinject
import SwinjectAutoregistration

extension Container {
    
    func registerServices() {
        self.autoregister(PhotosServiceProtocol.self,
                          initializer: PhotosService.init).inObjectScope(.container)
        self.autoregister(PhotosRepositoryProtocol.self,
                          initializer: PhotosRepository.init).inObjectScope(.container)
        self.autoregister(Networking.self,
                          initializer: NetworkManager.init).inObjectScope(.container)
        self.autoregister(PhotosRemoteDataStoreProtocol.self,
                          initializer: PhotosRemoteDataStore.init).inObjectScope(.container)
        self.autoregister(PhotosLocalDataSourceProtocol.self,
                          initializer: PhotosLocalDataSource.init).inObjectScope(.container)
        self.register(CoreDataManger.self) { _ in
            let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
            let coreDataManager = CoreDataManger(context: context!)
            return coreDataManager
        }
    }
}
