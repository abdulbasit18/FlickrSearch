//
//  PhotosListViewModel.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 19/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Types
typealias AlertType = (title: String, message: String)

// MARK: - Protocols
protocol PhotosListViewModelInputs: class {
    var viewDidLoadSubject: PublishSubject<Void?> { get }
    var tapOnCellSubject: PublishSubject<Int> { get }
    var reachedBottomSubject: PublishSubject<Void?> { get }
    var searchSubject: PublishSubject<String> { get }
    func getPhotoListCellViewModel(for index: Int) -> PhotoListCellViewModel
}

protocol PhotosListViewModelOutputs: class {
    var animateLoaderSubject: PublishSubject<Bool?> { get }
    var alertSubject: PublishSubject<AlertType> { get }
    var dataSubject: BehaviorRelay<[PhotoSection]> { get }
    var title: String { get }
}

protocol PhotosListViewModelProtocol: PhotosListViewModelInputs, PhotosListViewModelOutputs {
    var inputs: PhotosListViewModelInputs { get }
    var outputs: PhotosListViewModelOutputs { get }
}

// MARK: - PhotosListViewModel Implementation
final class PhotosListViewModel: PhotosListViewModelProtocol {
    
    var inputs: PhotosListViewModelInputs { self }
    var outputs: PhotosListViewModelOutputs { self }
    
    // MARK: - Inputs
    var viewDidLoadSubject = PublishSubject<Void?>()
    var tapOnCellSubject = PublishSubject<Int>()
    var reachedBottomSubject = PublishSubject<Void?>()
    var searchSubject = PublishSubject<String>()
    
    // MARK: - Outputs
    var alertSubject =  PublishSubject<AlertType>()
    var animateLoaderSubject = PublishSubject<Bool?>()
    var dataSubject = BehaviorRelay<[PhotoSection]>(value: [])
    var title: String { "Flickr Search" }
    
    // MARK: - Properties
    private let photosService: PhotosServiceProtocol
    private let navigator: PhotoListNavigatorProtocol
    private let numberOfSections = 1
    private var fetchedFromLocalStorage = false
    private let disposeBag = DisposeBag()
    private var tag = ""
    
    // MARK: - Initilizers
    init(photosService: PhotosServiceProtocol, navigator: PhotoListNavigatorProtocol) {
        self.photosService = photosService
        self.navigator = navigator
        
        //Setup Rx Bindings
        setupBindings()
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        
        //Bind Inputs
        inputBindings()
        
        //Bind Outputs
        outputBindings()
        
    }
    
    //*************** Inputs *************** //
    
    private func inputBindings() {
        
        //Load initial calls on viewDidLoad
        inputs.searchSubject.subscribe(onNext: { (tag) in
            self.loadView(tag: tag)
        }).disposed(by: disposeBag)
        
        //Call services on reaching collection view scroll bottom
        inputs.reachedBottomSubject
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe { [weak self] (_) in
                guard let self = self else { return }
                self.loadView(tag: self.tag)
        }.disposed(by: disposeBag)
        
        //Call tap handle
        inputs.tapOnCellSubject.subscribe(onNext: { [weak self] (index) in
            self?.didTapOnCell(index: index)
        }).disposed(by: disposeBag)
        
        //Handle loader view
        photosService.outputs.cantFetchPhotosSubject
            .map {_ in false}
            .bind(to: outputs.animateLoaderSubject).disposed(by: disposeBag)
        
    }
    
    //*************** End *************** //
    
    //*************** Outputs *************** //
    
    private func outputBindings() {
        
        // Shared Photo Subject
        let sharedPhotoSubject =  photosService.outputs.fetchPhotosSubject.share()
        
        // Get photos from remote and add the results with previous data
        sharedPhotoSubject
            .flatMap {PublishSubject
                .just([PhotoSection(header: "", items: self.getPhotos() + $0)])}
            .bind(to: dataSubject)
            .disposed(by: disposeBag)
        
        // Update loader
        sharedPhotoSubject.flatMap {_ in PublishSubject.just(false)}
            .bind(to: self.outputs.animateLoaderSubject)
            .disposed(by: disposeBag)
        
        // Set check
        sharedPhotoSubject.subscribe(onNext: { (_) in
            self.fetchedFromLocalStorage = false
        }).disposed(by: disposeBag)
        
        sharedPhotoSubject.subscribe(onNext: { (photos) in
            if photos.isEmpty {
                self.outputs.alertSubject
                    .onNext((title:"Nothing Found",
                             message: "We couldn't found any photos, please try later"))
                return
            }
        }).disposed(by: disposeBag)
        
        // Get data from service in case of an error
        let shareFailSubject =  photosService.outputs.failWithErrorSubject.share()
        
        //Get Data from Local
        shareFailSubject
            .flatMap {PublishSubject
                .just([PhotoSection(header: "", items: $0.photos)])}
            .bind(to: dataSubject)
            .disposed(by: disposeBag)
        //Upload loader
        shareFailSubject.flatMap {_ in PublishSubject.just(false)}
            .bind(to: self.outputs.animateLoaderSubject)
            .disposed(by: disposeBag)
        // Set check
        shareFailSubject.subscribe { [weak self] (_) in
            self?.fetchedFromLocalStorage = true
        }.disposed(by: disposeBag)
        
    }
    
    //*************** End *************** //
    
    // MARK: - Actions
    func getPhotoListCellViewModel(for index: Int) -> PhotoListCellViewModel {
        let photo = getPhotos()[index]
        let title = photo.title ?? ""
        let photoImageURL =  FlickerPhoto.getImageUrl(model: photo, size: .largeSquare)
        return createPhotoListCellViewModel(photoImageURL: photoImageURL, title: title)
    }
    
    private func createPhotoListCellViewModel(photoImageURL: String, title: String) -> PhotoListCellViewModel {
        let imgUrl = URL(string: photoImageURL)
        return PhotoListCellViewModel(photoImageUrl: imgUrl,
                                      title: title,
                                      placeHolderImage: "placeholder")
    }
    
    private func loadView(tag: String) {
        if !fetchedFromLocalStorage {
            if self.tag != tag {
                self.dataSubject.accept([])
            }
            self.tag = tag
            self.outputs.animateLoaderSubject.onNext(true)
            photosService.inputs.getPhotosSubject.onNext(tag)
        }
    }
    
    private func didTapOnCell(index: Int) {
        navigator.navigateToDetail(with: getPhotos()[index])
    }
    
    private func getPhotos() -> [PhotoDTO] {
        let data = self.dataSubject.value.first?.items ?? []
        return data
    }
}
