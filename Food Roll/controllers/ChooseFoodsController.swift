//
// Created by Nicolas Capparelli on 2018-12-29.
// Copyright (c) 2018 Adalligo. All rights reserved.
//

import Foundation
import UIKit


class ChooseFoodsController : UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FoodCategoryCellDelegate {

    private var foodArray : [PresentableCategory]! = FoodCategories.allCategories
    private var visibleFoodArray:[PresentableCategory]!


    private let searchBar : UISearchBar = {
        let newSearch = UISearchBar()
        newSearch.translatesAutoresizingMaskIntoConstraints = false
        newSearch.barTintColor = ProjectConstants.FOOD_ROLL_COLOR
        newSearch.setBackgroundImage(UIImage(), for: .any, barMetrics: UIBarMetrics.default)
        newSearch.setImage(UIImage(named: "clear_circle"), for: .clear, state: .normal)
        newSearch.isTranslucent = false
        newSearch.autocapitalizationType = .words
        return newSearch
    }()

    private let suggestionLabel : UILabel = {
        let newLabel = UILabel()
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.textAlignment = .center
        newLabel.font = .systemFont(ofSize: 12)
        newLabel.textColor = .white
        newLabel.text = "Select all that apply"
        return newLabel
    }()

    private let foodTableView : SingleFingerScrollTableView = {
        let newTV = SingleFingerScrollTableView(frame: .zero, style: .plain)
        newTV.translatesAutoresizingMaskIntoConstraints = false
        newTV.backgroundColor = ProjectConstants.FOOD_ROLL_COLOR
        newTV.separatorColor = .white
        newTV.separatorInset = UIEdgeInsets.zero;
        newTV.layoutMargins = UIEdgeInsets.zero;
        return newTV
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ProjectConstants.FOOD_ROLL_COLOR

        foodTableView.delegate = self
        foodTableView.dataSource = self
        foodTableView.register(FoodCategoryCell.self, forCellReuseIdentifier: "MyCell")
        searchBar.delegate = self
        // foodTableView.panGestureRecognizer.delegate = self
        
        self.visibleFoodArray = self.foodArray
        
        setupNavBar()
        setupLayout()
    }

    func setupNavBar(){
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = ProjectConstants.FOOD_ROLL_COLOR
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(saveSelection))
        self.title = "Choose Foods"
    }

    func setupLayout(){
        view.addSubview(searchBar)
        view.addSubview(suggestionLabel)
        view.addSubview(foodTableView)

        searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true

        suggestionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        suggestionLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        suggestionLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        suggestionLabel.heightAnchor.constraint(equalTo: searchBar.heightAnchor, multiplier: 0.6).isActive = true
        GlobalHelper.addLineToView(view: suggestionLabel, position: .LINE_POSITION_BOTTOM, color: .white, width: 1)

        foodTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        foodTableView.topAnchor.constraint(equalTo: suggestionLabel.bottomAnchor).isActive = true
        foodTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        foodTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customizeSearchBar()
    }

    func customizeSearchBar(){

        // Change searchBar input subview's background color, add white border, and round corners
        let searchTextField = self.searchBar.value(forKey: "searchField") as? UITextField
        searchTextField?.textColor = UIColor.white
        searchTextField?.backgroundColor = ProjectConstants.FOOD_ROLL_COLOR
        searchTextField?.attributedPlaceholder =  NSAttributedString(string: "Pizza, Burgers, Fries...", attributes: [NSAttributedString.Key.foregroundColor: ProjectConstants.FOOD_ROLL_COLOR_LIGHT])
        searchTextField?.clipsToBounds = true
        searchTextField?.layer.borderWidth = 1
        searchTextField?.layer.cornerRadius = (self.searchBar.frame.size.height / 2) / 2
        searchTextField?.layer.borderColor = UIColor.white.cgColor

        // Change Search Icon in UISearchBar to white
        let glassIconView = searchTextField?.leftView as! UIImageView
        glassIconView.image = glassIconView.image!.withRenderingMode(.alwaysTemplate)
        glassIconView.tintColor = .white

    }

    @objc func saveSelection(){

    }

    // MARK: Search View
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.visibleFoodArray = self.foodArray
        foodTableView.reloadData()
    }

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        // If the search is empty show all students
        if (searchText == ""){
            self.visibleFoodArray = self.foodArray
            foodTableView.reloadData()
        }

        // Else show filtered students
        else {
            self.visibleFoodArray = self.foodArray.filter { (foodString) -> Bool in
                // foodString.hasPrefix(searchText)
                foodString.showString.contains(searchText)
            }
            foodTableView.reloadData()
        }
    }

    // MARK: Table View
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.visibleFoodArray[indexPath.row].isChosen = !self.visibleFoodArray[indexPath.row].isChosen

        self.foodTableView.beginUpdates()
        self.foodTableView.reloadRows(at: [indexPath], with: .automatic) // None no animation, looks as if the check just pops up
        self.foodTableView.endUpdates()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleFoodArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath) as! FoodCategoryCell
        cell.mainLabel.text = self.visibleFoodArray[indexPath.item].showString
        cell.backgroundColor = .clear
        cell.indexPath = indexPath
        cell.foodCategoryCellDelegate = self
        cell.correspondingData = self.visibleFoodArray[indexPath.item]
        cell.setupCell()
        cell.accessoryView = UIImageView(image: UIImage(named: "checkmark"))

        if (self.visibleFoodArray[indexPath.row].isChosen) {
            cell.accessoryView?.isHidden = false
        } else {
            cell.accessoryView?.isHidden = true
        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // print(visibleFoodArray[indexPath.item].isExpanded)
        if (visibleFoodArray[indexPath.item].isExpanded) {
            return 80
        } else {
            return UITableView.automaticDimension
        }
    }

    func didSwipeDown(indexPath: IndexPath) {
        self.visibleFoodArray[indexPath.item].isExpanded = true
        self.foodTableView.beginUpdates()
        self.foodTableView.reloadRows(at: [indexPath], with: .automatic)
        self.foodTableView.endUpdates()
    }

    func didSwipeUp(indexPath: IndexPath) {
        self.visibleFoodArray[indexPath.item].isExpanded = false
        self.foodTableView.beginUpdates()
        self.foodTableView.reloadRows(at: [indexPath], with: .automatic)
        self.foodTableView.endUpdates()

    }

}