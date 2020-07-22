//
//  MockRemoteDataStore.swift
//  FlickerSearchTests
//
//  Created by Abdul Basit on 22/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import RxSwift

@testable import FlickerSearch

final class MockPhotosRemoteDataStore: PhotosRemoteDataStoreProtocol {
    var inputs: PhotosRemoteDataInputs { self }
    var outputs: PhotosRemoteDataOutputs { self }
    
    var getPhotosSubject = PublishSubject<PhotoRequestModel>()
    var fetchPhotoSubject = PublishSubject<PhotoResponseModel>()
    var failWithErrorSubject = PublishSubject<Error>()
    
    private var disposeBag = DisposeBag()
    
    init() {
        self.setUpBindings()
        self.setupData()
    }
    
    private func setupData() {
        let testBundle = Bundle(for: PhotoListTests.self)
        
        if let urlBar = testBundle.url(forResource: "PhotoList", withExtension: "geojson") {
            do {
                let jsonData = try Data(contentsOf: urlBar)
                let response = try? JSONDecoder().decode(PhotoResponseModel.self, from: jsonData)
                if let response = response {
                    outputs.fetchPhotoSubject.onNext(response)
                }
            } catch { print("Error while parsing: \(error)") }
        }
    }
    
    private func setUpBindings() {
        inputs.getPhotosSubject.subscribe(onNext: { [weak self] (_) in
            self?.setupData()
        }).disposed(by: disposeBag)
    }
    
}
