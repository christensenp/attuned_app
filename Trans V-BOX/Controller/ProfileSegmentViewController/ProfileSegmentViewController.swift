//
//  ProfileSegmentViewController.swift
//  Trans V-BOX
//
//  Created by Suraj on 4/3/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class ProfileSegmentViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.ProfileSegmentViewController
    static var storyBoardName: String = Storyboard.settings
    var dataToSend: ScreenData!

    static func viewController() -> ProfileSegmentViewController {
        let profileSegmentViewController = ProfileSegmentViewController.instantiateFromStoryBoard()
        return profileSegmentViewController
    }
    
    lazy var firstViewController: EditProfileViewController = {
        let editProfileViewController = EditProfileViewController.instantiateFromStoryBoard()
        self.add(asChildViewController: editProfileViewController)
        return editProfileViewController
    }()
    
    lazy var secondViewController: ProfilePageViewController = {
        let profilePageViewController = ProfilePageViewController.instantiateFromStoryBoard()
        self.add(asChildViewController: profilePageViewController)
        profilePageViewController.data = self.dataToSend
        return profilePageViewController
    }()
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            segmentControl.selectedSegmentTintColor = UIColor(displayP3Red: 68/255, green: 141/255, blue: 247/255, alpha: 1.0)
        } else {
            // Fallback on earlier versions
            segmentControl.tintColor = UIColor(displayP3Red: 68/255, green: 141/255, blue: 247/255, alpha: 1.0)
        }
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        super.viewDidLoad()
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = StringConstants.profile
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        self.setLeftBarButtonItem(imageName: "back")
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    private func updateView() {
        if segmentControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: secondViewController)
            add(asChildViewController: firstViewController)
        } else {
            remove(asChildViewController: firstViewController)
            add(asChildViewController: secondViewController)
        }
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        updateView()
    }
    
    
}

