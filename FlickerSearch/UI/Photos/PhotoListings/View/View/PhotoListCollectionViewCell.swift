//
//  PhotoListCollectionViewCell.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 19/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit
import SDWebImage

final class PhotoListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var photoTitleLabel: UILabel!
    
    var viewModel: PhotoListCellViewModel! {
        didSet {
            setupUI()
            configureCell(viewModel: viewModel)
        }
    }
    
    private func setupUI() {
        photoImageView.contentMode = .scaleToFill
        photoTitleLabel.textColor = .white
        photoTitleLabel.backgroundColor = .black
        photoTitleLabel.font = UIFont(.avenirDemiBold, size: .standard(.h5))
    }
    
    private func configureCell(viewModel: PhotoListCellViewModel) {
        photoImageView.sd_setImage(with: viewModel.photoImageUrl,
                                   placeholderImage: UIImage(named: viewModel.placeHolderImage),
                                   completed: nil)
        photoTitleLabel.text = viewModel.title
    }
}
