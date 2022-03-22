//
//  ProfileSelectGenderViewController.swift
//  Trans V-BOX
//
//  Created by Suraj on 4/3/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class ProfileSelectGenderViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.ProfileSelectGenderViewController
    static var storyBoardName: String = Storyboard.profile
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.setCharacterSpacing(1.4)
        tableView.registerCell(CellIdentifiers.GenderTableViewCell)
    }
    
}

extension ProfileSelectGenderViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let genderCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.GenderTableViewCell) as! GenderTableViewCell
        genderCell.setGender(title:StringConstants.genderArray[indexPath.row])
        return genderCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        return UITableView.automaticDimension
    }
}
