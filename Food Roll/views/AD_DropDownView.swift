//
// Created by Nicolas Capparelli on 2018-12-27.
// Copyright (c) 2018 Adalligo. All rights reserved.
//

import Foundation
import UIKit

protocol AD_DropDownDelegate {
    func didSelectOption(optionIndex: Int)
}

class AD_DropDownView : UIView, UITableViewDelegate, UITableViewDataSource {

    let optionsArray = ["5", "10", "15", "20"]
    var dropDownDelegate : AD_DropDownDelegate?

    private let arrowImage : UIImageView =  {
        let newIV = UIImageView(image: UIImage(named: "drop_up"))
        newIV.translatesAutoresizingMaskIntoConstraints = false
        newIV.contentMode = .bottom
        return newIV
    }()

    let tableView : UITableView = {
        let newTV = UITableView()
        newTV.translatesAutoresizingMaskIntoConstraints = false
        newTV.clipsToBounds = true
        newTV.layer.cornerRadius = 4
        return newTV
    }()

    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")


        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupLayout(){
        self.addSubview(arrowImage)
        self.addSubview(tableView)


        arrowImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        arrowImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        arrowImage.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        arrowImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1).isActive = true

        tableView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: arrowImage.topAnchor, constant: -5).isActive = true
        tableView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

    }

    // MARK: TableViewDelegate & DataSource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dropDownDelegate?.didSelectOption(optionIndex: indexPath.row)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.textAlignment = .center
        cell.textLabel!.text = "\(optionsArray[indexPath.item])"
        return cell
    }


}