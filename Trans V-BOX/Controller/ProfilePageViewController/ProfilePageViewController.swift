//
//  ProfilePageViewController.swift
//  Trans V-BOX
//
//  Created by Mobikasa Night on 2/27/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class ProfilePageViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.profilePageViewController
    static var storyBoardName: String = Storyboard.profile
    
    @IBOutlet weak var pageControlWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: PageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    var index = 0
    var isFromStarting = -1
    var pageViewController: UIPageViewController!
    var dots: [PageControl.Dot] = [.greyStyle, .greyStyle, .greyStyle, .greyStyle, .greyStyle, .greyStyle, .greyStyle]
    var pages = [UIViewController]()
    var data: ScreenData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.dots = dots
        pageControl.configuration.spacing = 22
        pageControl.isUserInteractionEnabled = false
        backButton.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        if isFromStarting == 1 {
            self.setUpPageController()
        } else{
            getQuestionnareData()
            self.nextButton.setTitle(StringConstants.save, for: .normal)
        }
        self.pageControlWidthConstant.constant = CGFloat(22 * (self.dots.count - 1))
    }
    
    
    func setUpPageController() {
        let profileStep1ViewController = ProfileStep1ViewController.instantiateFromStoryBoard()
        profileStep1ViewController.screen = data.screen1 ?? []
        let profileStep2ViewController = ProfileStep2ViewController.instantiateFromStoryBoard()
        profileStep2ViewController.screen = data.screen2 ?? []
        let profileStep3ViewController = ProfileStep3ViewController.instantiateFromStoryBoard()
        profileStep3ViewController.screen = data.screen3 ?? []
        let profileStep4ViewController = ProfileStep4ViewController.instantiateFromStoryBoard()
        profileStep4ViewController.screen = data.screen4 ?? []
        let profileStep5ViewController = ProfileStep4ViewController.instantiateFromStoryBoard()
        profileStep5ViewController.screen = data.screen5 ?? []
        let profileStep6ViewController = ProfileStep4ViewController.instantiateFromStoryBoard()
        profileStep6ViewController.screen = data.screen6 ?? []
        let profileStep7ViewController = ProfileStep7ViewController.instantiateFromStoryBoard()
        profileStep7ViewController.screen = data.screen7 ?? []
        
        self.pages = [profileStep1ViewController, profileStep2ViewController, profileStep3ViewController, profileStep4ViewController, profileStep5ViewController, profileStep6ViewController, profileStep7ViewController]
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        if isFromStarting != 1 {
            pageViewController.delegate = self
            pageViewController.dataSource = self
        }
        pageViewController.view.frame = self.containerView.bounds
        containerView.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    
    @IBAction func actionBackButton(_ sender: Any) {
        if index >= 0 {
            dots[index] = .greyStyle
            index -= 1
            if index < 0 {
                
                index = 0
            } else {
                pageViewController.setViewControllers([pages[index]], direction: .reverse, animated: true, completion: nil)
            }
            pageControl.dots = dots
            if isFromStarting == 1 {
                nextButton.setTitle(((index == dots.count - 1) ? StringConstants.finish : StringConstants.next) , for: .normal)
            } else{
                self.nextButton.setTitle(StringConstants.save, for: .normal)
            }
            pageControl.activeDotIndex = Float(index)
            backButton.isHidden = (index == 1)
        } 
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        if dots.count > 0 {
            if index < dots.count {
                if let controller = pages[index] as? ProfileStep1ViewController {
                    controller.saveAnswer(handler: { [unowned self] in
                        self.changeIndex()
                    })
                } else if let controller = pages[index] as? ProfileStep2ViewController {
                    controller.saveAnswer(handler: { [unowned self] in
                        self.changeIndex()
                    })
                } else if let controller = pages[index] as? ProfileStep3ViewController {
                    controller.saveAnswer(handler: { [unowned self] in
                        self.changeIndex()
                    })
                }  else if let controller = pages[index] as? ProfileStep4ViewController {
                    controller.saveAnswer(handler: { [unowned self] in
                        self.changeIndex()
                    })
                } else if let controller = pages[index] as? ProfileStep7ViewController {
                    controller.saveAnswer(handler: { [unowned self] in
                        let messsage = (self.isFromStarting == 1 ? StringConstants.profileCreated : StringConstants.profileUpdated)
                        self.showAlert(title: StringConstants.appName, message: messsage, completion: {
                            self.navigationController?.isNavigationBarHidden = false
                            UserDefaults.standard.set(true, forKey: UserDefaultKey.isProfileCompleted)
                            AppRouter.shared.moveToDashBoardScreen()
                        })
                    })
                }
            }
        }

    }
    
    func changeIndex() {
        self.dots[self.index] = .blackStyle
        self.pageControl.dots = self.dots
        self.index += 1
        if self.index >= self.dots.count {
            self.index = self.dots.count - 1
        }
        self.pageViewController.setViewControllers([self.pages[self.index]], direction: .forward, animated: true, completion: nil)
        if isFromStarting == 1 {
            self.nextButton.setTitle(((self.index == self.dots.count - 1) ? StringConstants.finish : StringConstants.next), for: .normal)
        } else{
            self.nextButton.setTitle(StringConstants.save, for: .normal)
        }
        self.pageControl.activeDotIndex = Float(self.index)
        if isFromStarting == 1 {
            backButton.isHidden = (index == 0)
        } else{
            backButton.isHidden = true
        }
        
    }
    
}

//MARK: - API calling if user comes from segment control

extension ProfilePageViewController{
    func getQuestionnareData(){
        APIManager.shared.getQuestionAnswers { [weak self] (response, status, error) -> (Void) in
            guard let self = self else { return }
            if let response = response as? QuestionAnswerModel {
                self.data = response.data
                self.setUpPageController()
            }
        }
    }
}

extension ProfilePageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func viewControllerAtIndex(_ index:Int ) -> UIViewController {
        return pages[index]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if var index = self.pages.firstIndex(of: viewController) {
            if index == NSNotFound {
                return nil
            }
            index += 1
            if index == self.pages.count {
                return nil
            }
            return self.viewControllerAtIndex(index)
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if var index = self.pages.firstIndex(of: viewController) {
            if index == 0 || index == NSNotFound {
                return nil
            }
            index -= 1
            return self.viewControllerAtIndex(index)
        }
        return nil

    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            return
        }
        if let controller = pageViewController.viewControllers?.first, let index = self.pages.firstIndex(of: controller) {
            self.changeIndex(index: index)
            self.pageControl.activeDotIndex = Float(index)
        }
    }

    func changeIndex(index: Int) {
        for i in 0..<dots.count {
            if i <= index {
                dots[i] = .blackStyle
            } else {
                dots[i] = .greyStyle
            }
        }
        self.index = index
        self.pageControl.dots = dots
    }

}
