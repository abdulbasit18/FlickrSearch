//
//  PhotoDetailViewController.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 21/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit

class PhotoDetailViewController: BaseViewController {
    
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        self.title = "Flickr Search"
        titleLabel.font = UIFont(.avenirDemiBold, size: .standard(.h1))
        titleLabel.textAlignment = .center
    }
    
    func fillUI(with data: PhotoDTO) {
        titleLabel.text = data.title
        
    }
    
}
