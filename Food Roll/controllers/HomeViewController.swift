//
//  HomeViewController.swift
//  Food Roll
//
//  Created by Nicolas Capparelli on 2018-12-26.
//  Copyright © 2018 Adalligo. All rights reserved.
//

import UIKit
import Cosmos


class HomeViewController: UIViewController, AD_DropDownDelegate, UIGestureRecognizerDelegate {

    private let distanceBetweenSections : CGFloat = 0.02
    private let distanceFromLabels : CGFloat = 0.01

    private var foodCategoryStrings = ["Sandwich", "Burger", "Dessert", "Fries"]
    private var dollarButtons = [AD_ImageCheckButton(withImageNamed: "money", frame: .zero),
                                 AD_ImageCheckButton(withImageNamed: "money2", frame: .zero),
                                 AD_ImageCheckButton(withImageNamed: "money3", frame: .zero),
                                 AD_ImageCheckButton(withImageNamed: "money4", frame: .zero)]


    private var distanceDropDownTopConstraint = NSLayoutConstraint()

    private let logoImageView : UIImageView = {
        let newIV = UIImageView()
        newIV.translatesAutoresizingMaskIntoConstraints = false
        newIV.image = UIImage(named: "FoodRoll_Logo")
        newIV.contentMode = .scaleAspectFit
        newIV.backgroundColor = .clear
        return newIV
    }()

    private let logoLabel : UILabel = {
        let newLabel = UILabel()
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.font = .systemFont(ofSize: ProjectConstants.FONTSIZE_LOGO)
        newLabel.textColor = .white
        newLabel.text = "FOOD ROLL"
        return newLabel
    }()

    private let distanceRadiusLabel : UILabel = {
        let newLabel = UILabel()
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.font = .systemFont(ofSize: ProjectConstants.FONTSIZE_LABELS)
        newLabel.textColor = .white
        newLabel.text = "Distance Radius"
        newLabel.textAlignment = .left
        return newLabel
    }()

    private let distanceRadiusTextField : UITextField = {
        let newField = UITextField()
        newField.translatesAutoresizingMaskIntoConstraints = false
        newField.text = "5"
        newField.font = .systemFont(ofSize: ProjectConstants.FONTSIZE_LABELS)
        newField.textColor = .white
        newField.textAlignment = .right
        newField.isEnabled = false
        newField.addImage(imageName: "drop_down", side: .RIGHT)
        return newField
    }()

    private let distanceRadiusMilesLabel : UILabel = {
        let newLabel = UILabel()
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.font = .systemFont(ofSize: ProjectConstants.FONTSIZE_LABELS)
        newLabel.textColor = .white
        newLabel.text = "miles"
        newLabel.textAlignment = .left
        return newLabel
    }()

    private let dropDownControl : UIControl = {
        let newC = UIControl()
        newC.translatesAutoresizingMaskIntoConstraints = false
        newC.backgroundColor = .clear
        newC.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)
        return newC
    }()

    private let distanceRadiusDropDown : AD_DropDownView = {
        let newDD = AD_DropDownView()
        newDD.isHidden = true
        return newDD
    }()

    private let priceRangeLabel : UILabel = {
        let newLabel = UILabel()
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.font = .systemFont(ofSize: ProjectConstants.FONTSIZE_LABELS)
        newLabel.textColor = .white
        newLabel.text = "Price Range (All that apply)"
        newLabel.textAlignment = .left
        return newLabel
    }()

    private let ratingsLabel : UILabel = {
        let newLabel = UILabel()
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.font = .systemFont(ofSize: ProjectConstants.FONTSIZE_LABELS)
        newLabel.textColor = .white
        newLabel.text = "Minimum Review Rating"
        newLabel.textAlignment = .left
        return newLabel
    }()

    private let starsView : CosmosView = {
        let newCos = CosmosView()
        newCos.translatesAutoresizingMaskIntoConstraints = false
        newCos.rating = 3
        newCos.settings.filledColor = UIColor.white
        newCos.settings.emptyBorderColor = UIColor.white
        newCos.settings.starSize = Double(ProjectConstants.FONTSIZE_LOGO)
        return newCos
    }()

    private let categoriesLabel : UILabel = {
        let newLabel = UILabel()
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.font = .systemFont(ofSize: ProjectConstants.FONTSIZE_LABELS)
        newLabel.textColor = .white
        newLabel.text = "Food Categories"
        newLabel.textAlignment = .left
        return newLabel
    }()

    private let infoButton : UIButton = {
        let newButton = UIButton()
        newButton.translatesAutoresizingMaskIntoConstraints = false
        newButton.setImage(UIImage(named: "info"), for: .normal)
        newButton.backgroundColor = .clear
        newButton.imageView?.contentMode = .scaleAspectFit
        return newButton
    }()

    private let categoriesLayout : AlignedCollectionViewFlowLayout = {
        let newLayout = AlignedCollectionViewFlowLayout()
        newLayout.scrollDirection = .vertical
        newLayout.horizontalAlignment = .left
        return newLayout
    }()

    private let categoriesCollection : UICollectionView = {
        let newCollection = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        newCollection.translatesAutoresizingMaskIntoConstraints = false
        newCollection.backgroundColor = UIColor.clear
        return newCollection
    }()

    private let categoriesContainer : UIView = {
        let newView = UIView()
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.backgroundColor = .clear
        return newView
    }()

    private let rollButton : UIButton = {
        let newButton = UIButton()
        newButton.translatesAutoresizingMaskIntoConstraints = false
        newButton.setTitle("Roll", for: .normal)
        newButton.setTitleColor(ProjectConstants.FOOD_ROLL_COLOR_BLACK_ON_WHITE, for: .normal)
        newButton.titleLabel?.font = .systemFont(ofSize: ProjectConstants.FONTSIZE_LOGO)
        newButton.backgroundColor = .white
        return newButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ProjectConstants.FOOD_ROLL_COLOR
        self.navigationController?.isNavigationBarHidden = true
        distanceRadiusDropDown.dropDownDelegate = self
        distanceDropDownTopConstraint = distanceRadiusDropDown.topAnchor.constraint(equalTo: distanceRadiusTextField.bottomAnchor)

        setupMainLayout()
        setupDistanceRadius()
        setupPriceRange()
        setupRatings()
        setupFoodCategories()
        collectionViewSetup()
        setupDropDown()
    }

    // Logo, Menu and Settings Button
    func setupMainLayout(){

        view.addSubview(logoImageView)
        view.addSubview(logoLabel)
        view.addSubview(rollButton)

        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.size.height * 0.05).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.20).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.20).isActive = true

        logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor).isActive = true
        logoLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.20)
        logoLabel.sizeToFit()

        rollButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        rollButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.size.height * -0.06).isActive = true
        rollButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08).isActive = true
        rollButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.60).isActive = true
    }

    func setupDistanceRadius(){

        view.addSubview(distanceRadiusLabel)
        view.addSubview(distanceRadiusTextField)
        view.addSubview(distanceRadiusMilesLabel)
        view.addSubview(dropDownControl)

        distanceRadiusLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: view.frame.size.width * 0.1).isActive = true
        distanceRadiusLabel.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: view.frame.size.height * 0.04).isActive = true
        distanceRadiusLabel.sizeToFit()

        distanceRadiusTextField.leadingAnchor.constraint(equalTo: distanceRadiusLabel.leadingAnchor).isActive = true
        distanceRadiusTextField.topAnchor.constraint(equalTo: distanceRadiusLabel.bottomAnchor, constant: view.frame.size.height * distanceFromLabels).isActive = true
        distanceRadiusTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        distanceRadiusTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.04).isActive = true

        dropDownControl.leadingAnchor.constraint(equalTo: distanceRadiusTextField.leadingAnchor).isActive = true
        dropDownControl.topAnchor.constraint(equalTo: distanceRadiusTextField.topAnchor).isActive = true
        dropDownControl.widthAnchor.constraint(equalTo: distanceRadiusTextField.widthAnchor).isActive = true
        dropDownControl.heightAnchor.constraint(equalTo: distanceRadiusTextField.heightAnchor).isActive = true

        distanceRadiusMilesLabel.leadingAnchor.constraint(equalTo: distanceRadiusTextField.trailingAnchor, constant: view.frame.size.width * 0.02).isActive = true
        distanceRadiusMilesLabel.centerYAnchor.constraint(equalTo: distanceRadiusTextField.centerYAnchor).isActive = true
        distanceRadiusMilesLabel.sizeToFit()
    }

    func setupPriceRange(){

        let dollarButtonHeight : CGFloat = UIScreen.main.bounds.height * 0.02436053593179

        view.addSubview(priceRangeLabel)

        priceRangeLabel.leadingAnchor.constraint(equalTo: distanceRadiusLabel.leadingAnchor).isActive = true
        priceRangeLabel.topAnchor.constraint(equalTo: distanceRadiusTextField.bottomAnchor, constant: view.frame.size.height * distanceBetweenSections).isActive = true
        priceRangeLabel.sizeToFit()

        for dollarButton in dollarButtons {
            view.addSubview(dollarButton)
            dollarButton.topAnchor.constraint(equalTo: priceRangeLabel.bottomAnchor, constant: view.frame.size.height * distanceFromLabels).isActive = true
            dollarButton.heightAnchor.constraint(equalToConstant: dollarButtonHeight).isActive = true
            dollarButton.sizeToFit()

        }


        dollarButtons[0].leadingAnchor.constraint(equalTo: distanceRadiusLabel.leadingAnchor, constant: view.frame.size.width * -0.03).isActive = true
        dollarButtons[1].leadingAnchor.constraint(equalTo: dollarButtons[0].trailingAnchor).isActive = true
        dollarButtons[2].leadingAnchor.constraint(equalTo: dollarButtons[1].trailingAnchor).isActive = true
        dollarButtons[3].leadingAnchor.constraint(equalTo: dollarButtons[2].trailingAnchor, constant: view.frame.size.width * -0.02).isActive = true

    }

    func setupRatings(){

        view.addSubview(ratingsLabel)
        view.addSubview(starsView)

        ratingsLabel.leadingAnchor.constraint(equalTo: distanceRadiusLabel.leadingAnchor).isActive = true
        ratingsLabel.topAnchor.constraint(equalTo: dollarButtons[0].bottomAnchor, constant: view.frame.size.height * distanceBetweenSections).isActive = true
        ratingsLabel.sizeToFit()

        starsView.leadingAnchor.constraint(equalTo: ratingsLabel.leadingAnchor).isActive = true
        starsView.topAnchor.constraint(equalTo: ratingsLabel.bottomAnchor, constant: view.frame.size.height * distanceFromLabels).isActive = true
        starsView.trailingAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        starsView.sizeToFit()

    }

    func setupFoodCategories(){
        view.addSubview(categoriesLabel)
        view.addSubview(infoButton)

        categoriesLabel.leadingAnchor.constraint(equalTo: distanceRadiusLabel.leadingAnchor).isActive = true
        categoriesLabel.topAnchor.constraint(equalTo: starsView.bottomAnchor, constant: view.frame.size.height * distanceBetweenSections).isActive = true
        categoriesLabel.sizeToFit()

        let infoButtonSize = UIScreen.main.bounds.height * 0.024630541871921

        infoButton.leadingAnchor.constraint(equalTo: categoriesLabel.trailingAnchor).isActive = true
        infoButton.centerYAnchor.constraint(equalTo: categoriesLabel.centerYAnchor).isActive = true
        infoButton.heightAnchor.constraint(equalToConstant: infoButtonSize).isActive = true
        infoButton.sizeToFit()

    }

    func collectionViewSetup(){

        view.addSubview(categoriesContainer)
        categoriesContainer.addSubview(categoriesCollection)

        categoriesCollection.delegate = self
        categoriesCollection.dataSource = self
        categoriesCollection.register(AD_TagCell.self, forCellWithReuseIdentifier: "TagCell")
        categoriesCollection.collectionViewLayout = categoriesLayout
        categoriesCollection.isUserInteractionEnabled = true

        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(goToChooseFoods))
        tapGestureRecogniser.delegate = self
        categoriesCollection.addGestureRecognizer(tapGestureRecogniser)

        categoriesContainer.leadingAnchor.constraint(equalTo: distanceRadiusLabel.leadingAnchor).isActive = true
        categoriesContainer.topAnchor.constraint(equalTo: categoriesLabel.bottomAnchor, constant: view.frame.size.height * distanceFromLabels).isActive = true
        categoriesContainer.bottomAnchor.constraint(equalTo: rollButton.topAnchor, constant: view.frame.size.height * -0.02).isActive = true
        categoriesContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80).isActive = true

        categoriesCollection.centerXAnchor.constraint(equalTo: categoriesContainer.centerXAnchor).isActive = true
        categoriesCollection.centerYAnchor.constraint(equalTo: categoriesContainer.centerYAnchor).isActive = true
        categoriesCollection.heightAnchor.constraint(equalTo: categoriesContainer.heightAnchor).isActive = true
        categoriesCollection.widthAnchor.constraint(equalTo: categoriesContainer.widthAnchor, multiplier: 0.95).isActive = true

    }

    func setupDropDown(){
        view.addSubview(distanceRadiusDropDown)

        distanceRadiusDropDown.centerXAnchor.constraint(equalTo: distanceRadiusTextField.centerXAnchor).isActive = true
        distanceDropDownTopConstraint.isActive = true
        distanceRadiusDropDown.widthAnchor.constraint(equalTo: distanceRadiusTextField.widthAnchor).isActive = true
        distanceRadiusDropDown.heightAnchor.constraint(equalTo: distanceRadiusTextField.heightAnchor, multiplier: 4).isActive = true

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.distanceRadiusTextField.layer.masksToBounds = true
        self.distanceRadiusTextField.layer.borderColor = UIColor.white.cgColor
        self.distanceRadiusTextField.layer.borderWidth = 1.0
        self.distanceRadiusTextField.layer.cornerRadius = 8.0


        self.categoriesContainer.layer.masksToBounds = true
        self.categoriesContainer.layer.borderColor = UIColor.white.cgColor
        self.categoriesContainer.layer.borderWidth = 1.0
        self.categoriesContainer.layer.cornerRadius = 8.0

        self.rollButton.layer.masksToBounds = true
        self.rollButton.layer.cornerRadius = self.rollButton.frame.size.height / 2

        self.distanceDropDownTopConstraint.constant = self.distanceRadiusTextField.frame.size.height / 2

    }

    // Allows distanceRadiusDropDown to be modal
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        // If distanceRadiusDropDown is showing and the user clicks anywhere outside of it
        if (!self.distanceRadiusDropDown.isHidden && touches.first?.view != self.distanceRadiusDropDown) {
            self.distanceRadiusDropDown.isHidden = true
        }
    }

    @objc func showDropDown(){
        self.distanceRadiusDropDown.isHidden = false
    }

    @objc func goToChooseFoods(){
        self.navigationController?.pushViewController(ChooseFoodsController(), animated: true)

    }

    // MARK: AD_DropDownDelegate
    func didSelectOption(optionIndex: Int) {
        self.distanceRadiusTextField.text = self.distanceRadiusDropDown.optionsArray[optionIndex]
        self.distanceRadiusDropDown.isHidden = true

    }

    // MARK: UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

        // only handle tapping empty space in collection view (i.e. not a cell) | https://stackoverflow.com/a/37466869/5266445
        let point = gestureRecognizer.location(in: self.categoriesCollection)
        let indexPath = self.categoriesCollection.indexPathForItem(at: point)
        return indexPath == nil
    }
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AD_TagCellDelegate {


    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodCategoryStrings.count
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let sizeRect : CGSize = self.foodCategoryStrings[indexPath.item].size(withAttributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)
        ])

        return CGSize(width: sizeRect.width + 45, height: sizeRect.height + 10)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! AD_TagCell
        cell.tagLabel.text = self.foodCategoryStrings[indexPath.item]
        cell.roundButtonCorners(buttonHeight: cell.frame.size.height)
        cell.tagLabel.sizeToFit()
        cell.indexAt = indexPath.item
        cell.tagCellDelegate = self
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout

    // Determines Insets
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }

    // Determines margin between cell on horizontal axis
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    // Determines margin between cell on vertical axis
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    // MARK: AD_TagCellDelegate
    func removeCellAt(index: Int) {
        self.foodCategoryStrings.remove(at: index)
        self.categoriesCollection.reloadData()
    }
}
