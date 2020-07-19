//
//  PhtosRemoteDataStore.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 19/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - Protocols

protocol PhotosRemoteDataOutputs: class {
    var fetchPhotoSubject: PublishSubject<PhotoResponseModel> { get }
    var failWithErrorSubject: PublishSubject<Error> { get }
}

protocol PhotosRemoteDataInputs: class {
    var getPhotosSubject: PublishSubject<PhotoRequestModel> { get }
}

protocol PhotosRemoteDataStoreProtocol: PhotosRemoteDataInputs, PhotosRemoteDataOutputs {
    var inputs: PhotosRemoteDataInputs { get }
    var outputs: PhotosRemoteDataOutputs { get }
}

// MARK: - PhotosRemoteDataStore Implementation

final class PhotosRemoteDataStore: PhotosRemoteDataStoreProtocol {
    
    var outputs: PhotosRemoteDataOutputs { self }
    var inputs: PhotosRemoteDataInputs { self }
    
    // MARK: - Inputs
    var getPhotosSubject = PublishSubject<PhotoRequestModel>()
    var failWithErrorSubject = PublishSubject<Error>()
    // MARK: - OutPuts
    var fetchPhotoSubject = PublishSubject<PhotoResponseModel>()
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let networkManager: Networking
    private let endpoint = ""
    
    // MARK: - Initilizers
    init(networkManager: Networking = NetworkManager()) {
        self.networkManager = networkManager
        
        //Setup Rx Bindings
        setupBindings()
    }
    
    // MARK: - Bindings
    
    private func setupBindings() {
        // Calling photos service on invocation
        inputs.getPhotosSubject.subscribe(onNext: { [weak self] (parameters) in
            self?.getPhotos(parameters: parameters)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Networking
    private func getPhotos(parameters: PhotoRequestModel) {
        
        let path = APIPathBuilder(baseURL: Constants.API.baseURL, endPoint: endpoint)
        let request = RequestBuilder(path: path, parameters: parameters, encoder: .queryString)

        networkManager.get(request: request) { [weak self] (response: APIResponse<PhotoResponseModel>)  in
            guard let self = self else { return }
            switch response.result {
            case .success(let data):
                    self.outputs.fetchPhotoSubject.onNext(data)
            case .failure(let error):
                    self.outputs.failWithErrorSubject.onNext(error)
            }
        }
    }
}
