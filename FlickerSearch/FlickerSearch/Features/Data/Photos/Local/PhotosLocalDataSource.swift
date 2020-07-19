//
//  PhotosLocalDataSource.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 19/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - Types
internal typealias FailedErrorType = (error: Error, id: String?)
internal typealias FailedPhotosErrorType = (error: Error, photos: [PhotoDTO])

// MARK: - Protocols
protocol PhotosLocalDataSourceInputs: class {
    var savePhotosSubject: PublishSubject<[PhotoDTO]> { get }
    var deletePhotosSubject: PublishSubject<[PhotoDTO]> { get }
    var updatePhotosSubject: PublishSubject<[PhotoDTO]> { get }
    var deleteAllPhotosSubject: PublishSubject<Void> { get }
    var getPhotosWithIdSubject: PublishSubject<FailedErrorType> { get }
}

protocol PhotosLocalDataSourceOutputs: class {
    var getPhotosSubject: PublishSubject<FailedPhotosErrorType> { get }
}

protocol PhotosLocalDataSourceProtocol: PhotosLocalDataSourceInputs, PhotosLocalDataSourceOutputs {
    var inputs: PhotosLocalDataSourceInputs { get }
    var outputs: PhotosLocalDataSourceOutputs { get }
}

// MARK: - PhotosLocalDataSource Implementation
final class PhotosLocalDataSource: PhotosLocalDataSourceProtocol {
    
    var inputs: PhotosLocalDataSourceInputs { self}
    var outputs: PhotosLocalDataSourceOutputs { self }
    
    // MARK: - Inputs
    var savePhotosSubject = PublishSubject<[PhotoDTO]>()
    var deletePhotosSubject = PublishSubject<[PhotoDTO]>()
    var updatePhotosSubject = PublishSubject<[PhotoDTO]>()
    var deleteAllPhotosSubject = PublishSubject<Void>()
    var getPhotosWithIdSubject = PublishSubject<FailedErrorType>()
    
    // MARK: - Outputs
    var getPhotosSubject = PublishSubject<FailedPhotosErrorType>()
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let localDBManager: CoreDataManger
    private let entity = "Photo"
    
    // MARK: - Initilizers
    init(localDBManager: CoreDataManger) {
        self.localDBManager = localDBManager
        
        //Setup Rx Binings
        setupBindings()
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        
        //Save Photos on Invocation
        inputs.savePhotosSubject.subscribe(onNext: { [weak self] (photos) in
            guard let self = self else { return }
            _ = photos.compactMap(self.convertPhotoDTOToPhoto)
            self.localDBManager.save(entity: self.entity)
        }).disposed(by: disposeBag)
        
        //Delete All Photos on Invocation
        inputs.deleteAllPhotosSubject.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.localDBManager.deleteObjects(self.entity)
        }).disposed(by: disposeBag)
        
        //Delete Photos on Invocation
        inputs.deletePhotosSubject.subscribe(onNext: { [weak self] (photos) in
            guard let self = self else { return }
            photos.forEach(self.delete)
        }).disposed(by: disposeBag)
        
        //Update Photos on Invocation
        inputs.updatePhotosSubject.subscribe(onNext: { [weak self] (photos) in
            guard let self = self else { return }
            photos.forEach(self.update)
        }).disposed(by: disposeBag)
        
        //Get Photos with ID on Invocation
        // swiftlint:disable force_cast
        inputs.getPhotosWithIdSubject.subscribe(onNext: { [weak self] (request) in
            guard let self = self else { return }
            let predicate = (request.id != nil) ?
                Predicate(format: "%k == %@", arguments: ["id", request.id ?? ""])
                : nil
            let result = self.localDBManager.fetchObject(self.entity, predicate: predicate) as! [Photo]
            let compactResults = result.compactMap(self.convertPhotoToPhotoDTO)
            self.outputs.getPhotosSubject.onNext((error: request.error, photos: compactResults))
            
        }).disposed(by: disposeBag)
        // swiftlint:enable force_cast
    }
}

// MARK: - Database CRUD Functionality

extension PhotosLocalDataSource {
    
    // MARK: - Internal Utility methods
    
    private func delete(photo: PhotoDTO) {
        let predicate = Predicate(format: "%k == %@", arguments: ["id", String(photo.id)])
        localDBManager.deleteObjects(entity, predicate: predicate )
    }
    
    private func update(photo: PhotoDTO) {
        let predicate = Predicate(format: "%k == %@", arguments: ["id", String(photo.id)])
        guard let data = localDBManager.doesThisObjectExist(entity, predicate: predicate) as? Photo
            else { return }
        
        data.id = photo.id
        data.owner = photo.owner
        data.secret = photo.secret
        data.server = photo.server
        data.title = photo.title

        localDBManager.save(entity: entity)
        
    }
    
    private func convertPhotoToPhotoDTO(photo: Photo) -> PhotoDTO {
        PhotoDTO(id: photo.id ?? "",
                        owner: photo.owner,
                        secret: photo.secret,
                        server: photo.server,
                        title: photo.title
        )
    }
    
    private func convertPhotoDTOToPhoto(photoDTO: PhotoDTO) -> Photo {
        return Photo(photoDTO: photoDTO, context: localDBManager.context)
    }
}
