//
//  PhotosService.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 19/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import RxSwift

//MARK: - Protocols
protocol PhotosServiceInputs: class {
    var getPhotosSubject: PublishSubject<Void?> { get }
}

protocol PhotosServiceOutputs: class {
    var fetchPhotosSubject: PublishSubject<[PhotoDTO]> { get }
    var failWithErrorSubject: PublishSubject<FailedPhotosErrorType> { get }
    var cantFetchPhotosSubject: PublishSubject<Void?> { get }
}

protocol PhotosServiceProtocol: PhotosServiceInputs, PhotosServiceOutputs {
    var inputs: PhotosServiceInputs { get }
    var outputs: PhotosServiceOutputs { get }
}

//MARK: - PhotosService Implementation
final class PhotosService: PhotosServiceProtocol {
    
    var inputs: PhotosServiceInputs { self }
    var outputs: PhotosServiceOutputs { self }
    
    //MARK: - Inputs
    var getPhotosSubject = PublishSubject<Void?>()
    
    //MARK: - Outputs
    var fetchPhotosSubject = PublishSubject<[PhotoDTO]>()
    var failWithErrorSubject = PublishSubject<FailedPhotosErrorType>()
    var cantFetchPhotosSubject = PublishSubject<Void?>()
    
    //MARK: - Properties
    private var photoResponse: PhotoResponseModel?
    private let photosRepository: PhotosRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    //MARK: - Initilizers
    init(photosRepository: PhotosRepositoryProtocol) {
        self.photosRepository = photosRepository
        
        //Setup Rx Bindings
        setupBindings()
    }
    
    //MARK: - Bindings
    private func setupBindings() {
        /*Shared Subject of photos which will
         be shared between local local photos object and to output the fetched photos*/
        let sharedPhotoSubject = self.photosRepository.outputs.fetchPhotosSubject.share(replay: 1, scope: .whileConnected)
        
        //Output Photos Data
        sharedPhotoSubject
            .compactMap{$0.photos.photo}
            .bind(to: outputs.fetchPhotosSubject)
            .disposed(by: disposeBag)
        
        //Save Data locally
        sharedPhotoSubject.subscribe(onNext: { [weak self] (photos) in
            self?.photoResponse = photos
        }).disposed(by: disposeBag)
        
        //Output Data in case of an error
        self.photosRepository.outputs.FailWithErrorSubject
            .bind(to: outputs.failWithErrorSubject)
            .disposed(by: disposeBag)
        
        //Get Photos input call
        inputs.getPhotosSubject.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.getPhotosData()
        }).disposed(by: disposeBag)
    }
}

//MARK: - Extensions
extension PhotosService {
    
    //Outputs photos data
    private func getPhotosData() {
        (canFetchPhotos()) ?
            fetchPhotos(page: (photoResponse?.photos.page ?? 0) + 1, apiKey: Constants.Keys.api) :
            cantFetchPhotos()
    }
    
    // Check if photos data can be fetched
    private func canFetchPhotos() -> Bool {
        guard let photoResponse = photoResponse,
            (photoResponse.photos.page != nil),
            (photoResponse.photos.total != nil) else { return true }
        return (photoResponse.photos.page! == photoResponse.photos.total!) ? false : true
    }
    
    //Get photos
    private func fetchPhotos(page: Int, apiKey: String) {
        let photosRequestModel = PhotoRequestModel(page: page, api_key: apiKey)
        self.photosRepository.inputs.getPhotosSubject.onNext(photosRequestModel)
    }
    
    //Output photos can not be fetched
    private func cantFetchPhotos() {
        outputs.cantFetchPhotosSubject.onNext(nil)
    }
    
}

