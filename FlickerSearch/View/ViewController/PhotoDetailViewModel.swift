//
//  PhotoDetailViewModel.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 21/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import RxSwift

struct PhotoDetailData {
    let title: String?
    let imageURL: URL?
    let placeholderImage: String
}

protocol PhotoDetailViewModelProtocol {
    var viewDidLoadSubject: PublishSubject<Void?> { get }
    var fillUISubject: PublishSubject<PhotoDetailData> { get}
}

final class PhotoDetailViewModel: PhotoDetailViewModelProtocol {
    
    //Inputs
    var viewDidLoadSubject = PublishSubject<Void?>()
    
    //Outputs
    var fillUISubject = PublishSubject<PhotoDetailData>()
    
    //Properties
    private let disposeBag = DisposeBag()
    
    private let photo: PhotoDTO
    
    init(photo: PhotoDTO) {
        self.photo = photo
        
        //Setup Rx Bindings
        setupBindings()
    }
    
    private func setupBindings() {
        viewDidLoadSubject
            .flatMap {_ in self.prepareDataToSend(photo: self.photo)}
            .bind(to: fillUISubject)
            .disposed(by: disposeBag)
    }
    
    private func prepareDataToSend(photo: PhotoDTO) -> Observable<PhotoDetailData> {
        let title =  photo.title
        let photoImageString =  FlickerPhoto.getImageUrl(model: photo, size: .largeSquare)
        let url = URL(string: photoImageString)!
        
        let model = PhotoDetailData(title: title,
                                    imageURL: url,
                                    placeholderImage: "placeholder")
        return PublishSubject.just(model)
        
    }
}
