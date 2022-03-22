//
//  AlertViewController.swift
//  Trans V-BOX
//
//  Created by Gourav on 27/05/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class AlertViewController: BaseViewController {

    static var storyBoardId: String = ViewIdentifiers.AlertViewController
    static var storyBoardName: String = Storyboard.voiceTracker
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor.colorWithRGB(r: 242, g: 209, b: 132).cgColor,
                           UIColor.colorWithRGB(r: 247, g: 197, b: 171).cgColor,
                           UIColor.colorWithRGB(r: 245, g: 188, b: 200).cgColor,
                           UIColor.colorWithRGB(r: 167, g: 195, b: 227).cgColor,
                           UIColor.colorWithRGB(r: 201, g: 237, b: 227).cgColor]
        gradient.frame = popUpView.bounds
        popUpView.layer.insertSublayer(gradient, at: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        })
        // Do any additional setup after loading the view.
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
