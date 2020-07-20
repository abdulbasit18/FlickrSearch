//
//  PhotosRepository.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 19/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Protocols
protocol PhotosRepositoryInputs: class {
    var getPhotosSubject: PublishSubject<PhotoRequestModel> { get }
}

protocol PhotosRepositoryOutputs: class {
    var fetchPhotosSubject: PublishSubject<PhotoResponseModel> { get }
    var FailWithErrorSubject: PublishSubject<FailedPhotosErrorType> { get }
}

protocol PhotosRepositoryProtocol: PhotosRepositoryInputs, PhotosRepositoryOutputs {
    var inputs: PhotosRepositoryInputs { get }
    var outputs: PhotosRepositoryOutputs { get }
}

// MARK: - PhotosRepository Implementation
final class PhotosRepository: PhotosRepositoryProtocol {
    
    var outputs: PhotosRepositoryOutputs { self}
    var inputs: PhotosRepositoryInputs { self }
    
    // MARK: - Inputs
    var fetchPhotosSubject = PublishSubject<PhotoResponseModel>()
    var FailWithErrorSubject = PublishSubject<FailedPhotosErrorType>()
    
    // MARK: - Outputs
    var getPhotosSubject = PublishSubject<PhotoRequestModel>()
    
    // MARK: - Properties
    private let remotePhotosDataSource: PhotosRemoteDataStoreProtocol
    private let localPhotosDataSource: PhotosLocalDataSourceProtocol
    private var tag = ""
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialisers
    init(remotePhotosDataSource: PhotosRemoteDataStoreProtocol, localPhotosDataSource: PhotosLocalDataSourceProtocol) {
        self.remotePhotosDataSource = remotePhotosDataSource
        self.localPhotosDataSource = localPhotosDataSource
        
        // MARK: - Setup Rx Bindings
        setupBindings()
    }
    
    // MARK: - Bindingas
    private func setupBindings() {
        /*Shared Subject of photos which will
         be shared between local data store and to output the fetched photos*/
        let sharedPhotosSubject = self.remotePhotosDataSource.outputs.fetchPhotoSubject
            .share()
//        PublishSubject
        //Update local database when photos are fetched
//        sharedPhotosSubject
//            .compactMap { PublishSubject.just((tag: self.tag, photos: $0.photos.photo ?? [])) }
//            .bind(to: self.localPhotosDataSource.savePhotosSubject)
//            .disposed(by: disposeBag)
        
        sharedPhotosSubject.subscribe(onNext: { (responseModel) in
            let saveModel = (tag: self.tag, photos: responseModel.photos.photo ?? [])
            self.localPhotosDataSource.savePhotosSubject.onNext(saveModel)
        }).disposed(by: disposeBag)
        
        //Output the fetched photos data
        sharedPhotosSubject
            .bind(to: outputs.fetchPhotosSubject).disposed(by: disposeBag)
        
        //Trigger the local database fetch in case of error
        self.remotePhotosDataSource.outputs.failWithErrorSubject
            .map {(error: $0, tag: self.tag)}
            .bind(to: localPhotosDataSource.inputs.getPhotosWithIdSubject)
            .disposed(by: disposeBag)
        
        //Fetch photos data from local database in case of error
        self.localPhotosDataSource.outputs.getPhotosSubject
            .bind(to: outputs.FailWithErrorSubject)
            .disposed(by: disposeBag)
        
        //Call fetch photos when triggered
        self.inputs.getPhotosSubject
            .bind(to: remotePhotosDataSource.inputs.getPhotosSubject)
            .disposed(by: disposeBag)
        
        remotePhotosDataSource.inputs.getPhotosSubject.subscribe(onNext: { [weak self] (request) in
            self?.tag = request.tags
            }).disposed(by: disposeBag)
    }
}
