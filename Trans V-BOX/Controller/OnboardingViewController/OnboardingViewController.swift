//
//  OnboardingViewController.swift
//  Trans V-BOX
//
//  Created by Mobikasa Night on 2/26/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class OnboardingViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.onboardingViewController
    static var storyBoardName: String = Storyboard.main
    @IBOutlet weak var containerView: UIView!
    var pageViewController: UIPageViewController!
    var pages = [StringConstants.advertising]
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.isHidden = true
        pageControl.isUserInteractionEnabled = false
        self.navigationItem.hidesBackButton = true
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "animation", withExtension: "gif")!)
        let advTimeGif = UIImage.gifImageWithData(imageData!)
        backgroundImageView.image = advTimeGif
        setUpPageController()
        // Do any additional setup after loading the view.
    }
    
    func setUpPageController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.setViewControllers([getViewControllerAtIndex(0)], direction: .forward, animated: true, completion: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.isPagingEnabled = false
        pageControl.numberOfPages = pages.count
        pageViewController.view.frame = self.containerView.bounds
        containerView.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    @IBAction func signUpButtonAction(_ sender: Any? = nil) {
        let controller = SignUpViewController.instantiateFromStoryBoard()
        controller.closure(dismissHandler: { [unowned self] in
            self.signInButtonAction()
            }, successHandler: { [unowned self] in
                self.pushGetStatredController()
        })
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func signInButtonAction(_ sender: Any? = nil) {
        let controller = SignInViewController.instantiateFromStoryBoard()
        controller.modalPresentationStyle = .overCurrentContext
        controller.closure(dismissHandler: { [unowned self] in
            self.signUpButtonAction()
            }, successHandler: { [unowned self] in
                self.pushGetStatredController()
        })
        self.present(controller, animated: true, completion: nil)
    }
    
    func pushGetStatredController() {
        if UserDefaults.standard.bool(forKey: UserDefaultKey.isProfileCompleted) {
            AppRouter.shared.moveToDashBoardScreen()
        } else {
           let controller = GetStartedViewController.instantiateFromStoryBoard()
           push(controller)
        }
        
    }
    
}

extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let pageContent = viewController as! OnboardingContentViewController
        var index = pageContent.pageIndex
        if index == 0 || index == NSNotFound {
            return nil
        }
        index -= 1
        return getViewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let pageContent = viewController as! OnboardingContentViewController
        var index = pageContent.pageIndex
        if index == NSNotFound {
            return nil;
        }
        index += 1
        if index == pages.count {
            return nil;
        }
        return getViewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let pageContent = pendingViewControllers[0] as! OnboardingContentViewController
        pageControl.currentPage = pageContent.pageIndex
    }
    
    func getViewControllerAtIndex(_ index: NSInteger) -> OnboardingContentViewController {
        let pageContentViewController = OnboardingContentViewController.instantiateFromStoryBoard()
        pageContentViewController.pageIndex = index
        return pageContentViewController
    }
    
}
