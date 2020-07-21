//
//  PhotoDetailViewController.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 21/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit
import RxSwift

final class PhotoDetailViewController: BaseViewController {
    
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    var viewModel: PhotoDetailViewModelProtocol!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        self.title = "Flickr Search"
        titleLabel.font = UIFont(.avenirDemiBold, size: .standard(.h1))
        titleLabel.textAlignment = .center
    }
    
    private func setupBindings() {
        
        viewModel.fillUISubject.subscribe(onNext: { [weak self] (data) in
            self?.fillUI(with: data)
            }).disposed(by: disposeBag)
        
        viewModel.viewDidLoadSubject.onNext(nil)
    }
    
    func fillUI(with data: PhotoDetailData) {
        titleLabel.text = data.title
        photoImageView.sd_setImage(with: data.imageURL,
                                   placeholderImage: UIImage(named: data.placeholderImage), completed: nil)
    }
    
}
