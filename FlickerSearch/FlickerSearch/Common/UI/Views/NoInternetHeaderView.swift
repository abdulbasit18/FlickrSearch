//
//  NoInternetHeaderView.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 17/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit

class NoInternetHeaderView: UIView, NibLoadableView {
    
    @IBOutlet weak var noInternetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .red
        noInternetLabel.font = UIFont(.avenirDemiBold, size: .standard(.h6))
        noInternetLabel.textColor = .white
        noInternetLabel.text = "No internet connection"
        noInternetLabel.textAlignment = .center
    }
}

