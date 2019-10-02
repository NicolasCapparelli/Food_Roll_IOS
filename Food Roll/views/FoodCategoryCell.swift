//
// Created by Nicolas Capparelli on 2019-01-02.
// Copyright (c) 2019 Adalligo. All rights reserved.
//

import Foundation
import UIKit

protocol FoodCategoryCellDelegate {
    func didSwipeDown(indexPath: IndexPath)
    func didSwipeUp(indexPath: IndexPath)
}

class FoodCategoryCell : UITableViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource  {

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

        if (gestureRecognizer == self.downRecognizer){
            return !self.correspondingData!.isExpanded
        } else {
            return self.correspondingData!.isExpanded
        }
    }

    var correspondingData : PresentableCategory?
    var isChosenFromList = false
    var isGroupCategory = false
    var indexPath : Any = ""

    var isPulledDown = false
    var downRecognizer : UISwipeGestureRecognizer?
    var upRecognizer : UISwipeGestureRecognizer?
    var foodCategoryCellDelegate : FoodCategoryCellDelegate?

    var mainLabelConstraintLeading : NSLayoutConstraint!
    var mainLabelConstraintTop: NSLayoutConstraint!
    var mainLabelConstraintCenterY : NSLayoutConstraint!
    var largestStringCategory = ""

    let cellID : String = "groupCategoryCell"
    let mainLabel: UILabel = {
        let newLabel = UILabel()
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.isHidden = false
        newLabel.textColor = .white
        return newLabel
    }()

    var categoryCollection : UICollectionView?

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.mainLabelConstraintLeading = mainLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        self.mainLabelConstraintCenterY = mainLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        self.mainLabelConstraintTop = mainLabel.topAnchor.constraint(equalTo: self.topAnchor)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // After the subviews have been laid out
        self.mainLabelConstraintLeading.constant = 15
        self.mainLabelConstraintTop.constant = self.frame.size.height * 0.08
    }


    func setupCell(){
        self.addSubview(mainLabel)

        self.mainLabelConstraintLeading.isActive = true
        mainLabel.sizeToFit()

        // Only add recognizers to the cell it's PresentableCategory is a group
        if (self.correspondingData!.isGroup) {
            setupGestureRecognizers()
        }

        // Aligns the mainLabel and sets up categoryCollection depending on whether the cell is expanded or not
        if (self.correspondingData!.isExpanded){
            self.mainLabelConstraintCenterY.isActive = false
            self.mainLabelConstraintTop.isActive = true
            setupCollectionView()
        } else {
            self.mainLabelConstraintTop.isActive = false
            self.mainLabelConstraintCenterY.isActive = true
        }
    }

    func setupGestureRecognizers(){
        let pullDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(launchPullDown))
        pullDownRecognizer.delegate = self
        pullDownRecognizer.direction = .down
        pullDownRecognizer.numberOfTouchesRequired = 2
        self.addGestureRecognizer(pullDownRecognizer)
        self.downRecognizer = pullDownRecognizer

        let pullUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(launchPullUp))
        pullUpRecognizer.delegate = self
        pullUpRecognizer.direction = .up
        pullUpRecognizer.numberOfTouchesRequired = 2
        self.addGestureRecognizer(pullUpRecognizer)
        self.upRecognizer = pullUpRecognizer
    }

    func setupCollectionView(){

        // Find the longest string in the categories array, this will be the size of each collection view cell
        if let max = self.correspondingData!.categories.max(by: {$1.count > $0.count}) {
            self.largestStringCategory = max
        }

        // Layout and Preferences
        let newLayout = UICollectionViewFlowLayout()
        newLayout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: newLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LabelCollectionViewCell.self, forCellWithReuseIdentifier: cellID)

        // Laying the collection view out in the cell
        self.addSubview(collectionView)
        collectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.90).isActive = true
        collectionView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }


    @objc func launchPullDown(){
        self.foodCategoryCellDelegate?.didSwipeDown(indexPath: self.indexPath as! IndexPath)
    }

    @objc func launchPullUp(){
        self.foodCategoryCellDelegate?.didSwipeUp(indexPath: self.indexPath as! IndexPath)
    }


    // MARK: CollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        // TODO: Left off here. CollectionViewCells don't look aligned because the size of the cells is dependent on their
        // TODO: string length. Make the size of the cells be dependent on the longest string instead

        let sizeRect : CGSize = self.largestStringCategory.size(withAttributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)
        ])

        return sizeRect
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.correspondingData?.isGroup != nil){
            return self.correspondingData!.categories.count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (self.correspondingData?.isGroup != nil){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! LabelCollectionViewCell
            cell.textLabel.text = self.correspondingData?.categories[indexPath.item]
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

    // Determines Insets
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }

    // Determines margin between cell on vertical axis
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }


}