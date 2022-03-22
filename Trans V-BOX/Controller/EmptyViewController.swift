//
//  EmptyViewController.swift
//  Trans V-BOX
//
//  Created by Gourav on 23/03/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class EmptyViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.EmptyViewController
    static var storyBoardName: String = Storyboard.main
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        self.showAlert(title: StringConstants.Logout, message: StringConstants.logoutMessage, completion: {[unowned self] in
            UserSession.removeUserSession()
            let controller = AccessCodeViewController.instantiateFromStoryBoard()
            AppDelegate.sharedDelegate().window?.rootViewController = UINavigationController(rootViewController: controller)
        })
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
