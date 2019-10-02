//
// Created by Nicolas Capparelli on 2018-12-26.
// Copyright (c) 2018 Adalligo. All rights reserved.
//

import Foundation
import UIKit

// TODO: Refactor to AD_ImageCheckButton
class AD_ImageCheckButton: UIControl {

    private var selectedVar = false

    let imageView: UIImageView = {
        let newIV = UIImageView()
        newIV.contentMode = .scaleAspectFit
        return newIV
    }()

    required init(withImageNamed: String, frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.tintColor = ProjectConstants.FOOD_ROLL_COLOR_LIGHT

        setupImage(withImageNamed: withImageNamed)
        setupLayout()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupImage(withImageNamed: String){
        var newImage = UIImage(named: withImageNamed)
        newImage = newImage?.withRenderingMode(.alwaysTemplate)
        self.imageView.image = newImage
    }

    func setupLayout() {

        self.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    override var isTouchInside: Bool {

        if (selectedVar) {
            self.imageView.tintColor  = ProjectConstants.FOOD_ROLL_COLOR_LIGHT
        } else {
            self.imageView.tintColor  = .white
        }

        selectedVar = !selectedVar
        return super.isTouchInside
    }
}