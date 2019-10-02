//
// Created by Nicolas Capparelli on 2018-12-28.
// Copyright (c) 2018 Adalligo. All rights reserved.
//

import Foundation
import UIKit

protocol AD_TagCellDelegate {
    func removeCellAt(index: Int)
}

class AD_TagCell : UICollectionViewCell {

    var indexAt : Int = -1
    var tagCellDelegate : AD_TagCellDelegate?

    let tagLabel : UILabel = {
        let newLabel = UILabel()
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.textAlignment = .center
        newLabel.textColor = ProjectConstants.FOOD_ROLL_COLOR_LIGHT_BLACK
        newLabel.font = .systemFont(ofSize: 14)
        newLabel.text = "Teeter"
        return newLabel
    }()

    let removeButton : UIButton = {
        let newButton = UIButton()
        var newImage = UIImage(named: "clear")
        newImage = newImage?.withRenderingMode(.alwaysTemplate)
        newButton.translatesAutoresizingMaskIntoConstraints = false
        newButton.setImage(newImage, for: .normal)
        newButton.imageView?.contentMode = .scaleAspectFit
        newButton.imageView?.tintColor = ProjectConstants.FOOD_ROLL_COLOR_LIGHT_BLACK
        return newButton

    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        // self.contentView.isUserInteractionEnabled = false
        self.backgroundColor = .white

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.removeButton.addTarget(self, action: #selector(removeClicked), for: .touchUpInside)
    }

    func setupLayout(){

        self.addSubview(tagLabel)
        self.addSubview(removeButton)

        tagLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 2).isActive = true
        tagLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        tagLabel.sizeToFit()

        removeButton.leadingAnchor.constraint(equalTo: tagLabel.trailingAnchor, constant: -5).isActive = true
        removeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        removeButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.60).isActive = true
        removeButton.sizeToFit()
    }

    func roundButtonCorners(buttonHeight: CGFloat){
        self.layer.cornerRadius =  (buttonHeight / 2)
    }

    @objc func removeClicked(){
        self.tagCellDelegate?.removeCellAt(index: self.indexAt)
    }

}