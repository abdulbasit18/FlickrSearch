//
//  PhotoListViewController.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 19/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import RxSwift
import RxDataSources

final class PhotoListViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak private var collectionView: UICollectionView!
    
    // MARK: - Properties
    var viewModel: PhotosListViewModelProtocol!
    private let searchController = UISearchController(searchResultsController: nil)
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup UI
        setCollectionView()
        setupUI()
        
        //Setup RX Bindings
        setupBindings()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.view.backgroundColor = .black
        self.title = viewModel.outputs.title
        viewModel.inputs.viewDidLoadSubject.onNext(nil)
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Photos"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setCollectionView() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.backgroundColor = .clear
    }
    
    // MARK: - Setup Bindings
    private func setupBindings() {
        
        searchController.searchBar.rx.searchButtonClicked.subscribe {[weak self] (_) in
            guard let self = self else { return }
            let tag = self.searchController.searchBar.text ?? ""
            self.viewModel.inputs.searchSubject.onNext(tag)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.animateLoaderSubject.subscribe(onNext: { [weak self] (shouldLoad) in
            guard let self = self, let shouldLoad = shouldLoad else { return}
            shouldLoad ? self.startAnimating() : self.stopAnimating()
        }).disposed(by: disposeBag)
        
        viewModel.outputs.alertSubject.subscribe(onNext: { [weak self] (alertResponse) in
            self?.showAlert(with: alertResponse.title, and: alertResponse.message)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.dataSubject.subscribe(onNext: { (_) in
            self.collectionView.reloadData()
        }).disposed(by: disposeBag)
        
        collectionView.rx.reachedBottom.asObservable()
            .bind(to: viewModel.inputs.reachedBottomSubject)
            .disposed(by: disposeBag)
        
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<PhotoSection>(
            configureCell: { [weak self] _, _, indexPath, _ in
                let cell: PhotoListCollectionViewCell = (self?.collectionView.dequeueReusableCell(for: indexPath))!
                cell.viewModel = self?.viewModel.inputs.getPhotoListCellViewModel(for: indexPath.row)
                return cell
        })
        
        dataSource.canMoveItemAtIndexPath = { dataSource, indexPath in
            return true
        }
        
        viewModel.dataSubject
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension PhotoListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        viewModel.inputs.tapOnCellSubject.onNext(indexPath.row)
    }
}

extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.sizeForItem(numberOfCellsInRow: 2,
                                          collectionViewLayout: collectionViewLayout
        )
    }
}
