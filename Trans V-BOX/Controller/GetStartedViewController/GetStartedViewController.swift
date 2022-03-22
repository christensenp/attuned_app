//
//  GetStartedViewController.swift
//  Trans V-BOX
//
//  Created by Mobikasa Night on 2/27/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class GetStartedViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.getStartedViewController
    static var storyBoardName: String = Storyboard.main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func getStartedButtonAction(_ sender: Any) {
        self.showLoading()
        APIManager.shared.getQuestionAnswers { [unowned self] (response, status, error) -> (Void) in
            self.stopLoading()
            if let response = response as? QuestionAnswerModel {
                let controller = ProfilePageViewController.instantiateFromStoryBoard()
                controller.data = response.data
                controller.isFromStarting = 1
                self.push(controller)
            }
        }
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
