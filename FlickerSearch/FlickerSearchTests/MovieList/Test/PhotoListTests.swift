//
//  PhotoListTests.swift
//  FlickerSearchTests
//
//  Created by Abdul Basit on 22/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest
import RxBlocking

@testable import FlickerSearch

final class PhotoListTests: XCTestCase {
    
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var viewModel: PhotosListViewModelProtocol!
    var photoListController: PhotoListViewController!
    
    override func setUp() {
        
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        
        let storyboard = UIStoryboard(storyboard: .photos)
        photoListController = storyboard.initialViewController()
        let rootController = AppNavigationController(rootViewController: photoListController)
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let coreDataManager = CoreDataManger(context: context)
            //View Model create & setup
            let remoteDataSource = MockPhotosRemoteDataStore()
            let localDataSource = PhotosLocalDataSource(localDBManager: coreDataManager)
            let repository = PhotosRepository(remotePhotosDataSource: remoteDataSource,
                                              localPhotosDataSource: localDataSource)
            let service = PhotosService(photosRepository: repository)
            let navigator = PhotoListNavigator(navigationController: rootController)
            viewModel = PhotosListViewModel(photosService: service,
                                            navigator: navigator)
            
            photoListController.viewModel = viewModel
        }
        
    }
    
    func testViewModelInitialState() {
        XCTAssertTrue(viewModel.outputs.dataSubject.value.isEmpty)
        XCTAssertEqual(viewModel.outputs.title, "Flickr Search")
    }
    
    func testFetchWithSearch() {
        
        let photoObserver = scheduler.createObserver([PhotoSection].self)
        
        viewModel.outputs
            .dataSubject.bind(to: photoObserver)
            .disposed(by: disposeBag)
        
        var request = "Kitten"
        
        scheduler.createColdObservable([.next(10, request)])
            .bind(to: viewModel.inputs.searchSubject)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // Test Model Conversion
        let kittenElement = photoObserver.events.last?.value.element
        XCTAssertEqual(kittenElement?.first?.items.count, 100)
        
        // Test Pagination
        
        scheduler.createColdObservable([.next(10, request)])
            .bind(to: viewModel.inputs.searchSubject)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let kittenPageElement = photoObserver.events.last?.value.element
        XCTAssertEqual(kittenPageElement?.first?.items.count, 200)
        
        // Test Tag Change
        
        request = "Cake"
        
        scheduler.createColdObservable([.next(10, request)])
            .bind(to: viewModel.inputs.searchSubject)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let cakeElement = photoObserver.events.last?.value.element
        XCTAssertEqual(cakeElement?.first?.items.count, 100)
        
    }
    
}
