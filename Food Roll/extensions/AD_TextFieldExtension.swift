//
// Created by Nicolas Capparelli on 2018-12-28.
// Copyright (c) 2018 Adalligo. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {

    enum TextFieldSide {
        case LEFT
        case RIGHT
    }

    func addImage(imageName: String, side: TextFieldSide){


        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        switch (side){
            case .LEFT:
                self.leftViewMode = .always
                self.leftView = imageView
                self.setNeedsLayout()
                self.layoutIfNeeded()
                leftView!.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
                leftView!.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
                leftView!.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.85).isActive = true
                leftView!.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.85).isActive = true

            case .RIGHT:
                self.rightViewMode = .always
                self.rightView = imageView
                self.setNeedsLayout()
                self.layoutIfNeeded()
                rightView!.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
                rightView!.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
                rightView!.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.85).isActive = true
                rightView!.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.85).isActive = true
        }

    }

}