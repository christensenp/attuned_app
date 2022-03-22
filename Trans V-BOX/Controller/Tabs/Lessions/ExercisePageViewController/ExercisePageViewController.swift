//
//  ExercisePageViewController.swift
//  Trans V-BOX
//
//  Created by Gourav on 24/03/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class ExercisePageViewController: BaseViewController {
    @IBOutlet weak var backButton: UIButton!

    static var storyBoardId: String = ViewIdentifiers.ExercisePageViewController
    static var storyBoardName: String = Storyboard.lessions
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var homeWorkContainerView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var pageControl: PageControl!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var pageControlWidth: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    var isHomeWorkViewHidden = false
    var pageViewController: UIPageViewController!
    var dots = [PageControl.Dot]()
    var pages = [UIViewController]()
    var isVideoFinished: Bool = false
    var lesson: Lesson?
    var homework: Homework?
    var homeworkData: HomeworkData?
    var colorCode: String!
    var handler: EmptyAction?
    var dismissHandler: EmptyAction?
    var isLastHomeWork: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.configuration.spacing = 22
        bottomView.isHidden = isHomeWorkViewHidden
        if !isHomeWorkViewHidden {
            self.setUpHomeContainerView()
        }
        backButton.isHidden = true
        pageControl.isUserInteractionEnabled = false
        self.setUpPageController()
    }
    
    func setUpPageController() {
        self.pages = []
        self.dots = []
        if let lessonContents = lesson?.lessonContents, !isHomeWorkViewHidden {
            self.setUpControllers(lessonContents: lessonContents)
        } else if let exerciseContents = homework?.exerciseContents {
            self.setUpControllers(lessonContents: exerciseContents)
        }
        let exerciseFeedbackViewController = ExerciseFeedbackViewController.instantiateFromStoryBoard()
        exerciseFeedbackViewController.isHomework = isHomeWorkViewHidden
        exerciseFeedbackViewController.lesson = lesson
        exerciseFeedbackViewController.homework = homework
        exerciseFeedbackViewController.handler = {[weak self](message) in
            guard let self = self else {return}
            if self.isHomeWorkViewHidden && self.isLastHomeWork {
                let controller = LessonCompletePopupViewController.instantiateFromStoryBoard()
                controller.lessonName = self.lesson?.name ?? ""
                controller.modalPresentationStyle = .overCurrentContext
                controller.modalTransitionStyle = .crossDissolve
                controller.handler = { [weak self] in
                    guard let self = self else { return }
                    if self.isHomeWorkViewHidden {
                        self.dismiss(animated: true, completion: { [weak self] in
                            guard let self = self, let handler =  self.handler else {return}
                            handler()
                        })
                    }
                }
                self.present(controller, animated: true, completion: nil)
            } else {
                self.showAlert(title: StringConstants.appName, message: message, completion: { [weak self] in
                    guard let self = self else {return}
                    if self.isHomeWorkViewHidden {
                        self.dismiss(animated: true, completion: { [weak self] in
                            guard let self = self, let handler =  self.handler else {return}
                            handler()
                        })
                    }
                })
            }
            if !self.isHomeWorkViewHidden {
                self.lesson?.isFeedBack = true
                self.setUpHomeContainerView()
            }
        }
        
        self.pages.append(exerciseFeedbackViewController)
        self.dots.append(.greyStyle)
        pageControl.dots = dots
        pageControl.configuration.spacing = 22
        pageControlWidth.constant = CGFloat(22 * (dots.count - 1))
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        if pages.count > 0 && pages[0] is VideoExerciseViewController {
            self.pageViewController.isPagingEnabled = self.isPagingEnabled(index: 0)
        }
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
        pageViewController.view.frame = self.containerView.bounds
        containerView.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    func setUpControllers(lessonContents: [LessonContent]) {
        for data in lessonContents {
            if data.contentType == ContentType.video.rawValue {
                let videoExerciseViewController = VideoExerciseViewController.instantiateFromStoryBoard()
                videoExerciseViewController.lessonContent = data
                if let isCompleted = homework?.isCompleted {
                    videoExerciseViewController.isFeedback = isCompleted
                } else if let isFeedBack = lesson?.isFeedBack {
                    videoExerciseViewController.isFeedback = isFeedBack
                }
                videoExerciseViewController.pageViewController = self
                videoExerciseViewController.handler = { [unowned self] in
                    self.pageViewController.isPagingEnabled = true
                }
                self.pages.append(videoExerciseViewController)
            } else if data.contentType == ContentType.text.rawValue{
                let textExerciseViewController = TextExerciseViewController.instantiateFromStoryBoard()
                textExerciseViewController.lessonContent = data
                self.pages.append(textExerciseViewController)
            }
            self.dots.append(.greyStyle)
        }
    }
    
    @IBAction func previousScreenButtonAction(_ sender: Any) {
        let index = Int(self.pageControl.activeDotIndex) - 1
        if index >= 0 {
            let viewController = self.pages[index]
            self.changeIndex(index: index)
            self.pageViewController.setViewControllers([viewController], direction: .reverse, animated: true, completion: nil)
            self.pageViewController(self.pageViewController, didFinishAnimating: true, previousViewControllers: [viewController], transitionCompleted: true)
        }
    }

    @IBAction func homeWorkButtonAction(_ sender: Any) {
        self.showLoading()
        if let controller = self.pages[Int(self.pageControl.activeDotIndex)] as? VideoExerciseViewController {
            controller.pauseVideo()
        }
        APIManager.shared.getHomeWork(lessonID: self.lesson?.lessonID ?? "") { [weak self] (response, status, error) -> (Void) in
            guard let self = self else {return}
            self.stopLoading()
            if let response = response as? HomeWorkModel {
                if String(describing: response.code.value) == StringConstants.successCode {
                    let controller = HomeWorkViewController.instantiateFromStoryBoard()
                    controller.homeworkData = response.data
                    controller.lesson = self.lesson
                    controller.colorCode = self.colorCode
                    let root = UINavigationController(rootViewController: controller)
                    root.modalPresentationStyle = .overCurrentContext
                    self.present(root, animated: true, completion: nil)
                } else {
                    self.showWarningAlert(title: StringConstants.appName, message: response.message)
                }
            } else {
                self.showWarningAlert(title: StringConstants.appName, message: error ?? "")
            }
        }
        
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: { [weak self] in
            guard let self = self, let dismissHandler = self.dismissHandler else {return}
            dismissHandler()
        })
    }
    
    func setUpHomeContainerView() {
        nameLabel.text = lesson?.homeWorkName ?? ""
        timeLabel.text = "\(StringConstants.time): \(Double(lesson?.homeWorktotalTime ?? 0).format()) min"
        let isFeedBack = lesson?.isFeedBack ?? false
        rightButton.setImage(UIImage(named: isFeedBack ? "\(colorCode ?? "")_arrow" : "Locked"), for: .normal)
        leftButton.setImage(UIImage(named: isFeedBack ? "\(colorCode ?? "")_homework" : "homework"), for: .normal)
        nameLabel.alpha = isFeedBack ? 1.0 : 0.4
        timeLabel.alpha = isFeedBack ? 1.0 : 0.4
        homeWorkContainerView.backgroundColor = isFeedBack ? UIColor.init(colorCode) : disableColor
        homeWorkContainerView.isUserInteractionEnabled = isFeedBack
    }
    
    func isPagingEnabled(index: Int) -> Bool {
        var flag = true
        if isHomeWorkViewHidden {
            if let id = homework?.exerciseContents?[index].id,   !UserDefaults.standard.bool(forKey: "\(id)_finished") {
                flag = false
                self.pageViewController.isPagingEnabled = false
            }
        } else {
            if let id = lesson?.lessonContents?[index].id, !UserDefaults.standard.bool(forKey: "\(id)_finished") {
                flag = false
            }
        }
        return flag
    }
    
    deinit {
        print("delloc ExercisePageViewController")
    }
}

extension ExercisePageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
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
        if !finished {
            return
        }
        if let controller = pageViewController.viewControllers?.first, let index = self.pages.firstIndex(of: controller) {
            DispatchQueue.main.async {
                self.pageViewController.isPagingEnabled = true
            }
            backButton.isHidden = !(index != 0 && self.pages[index] is VideoExerciseViewController)
            if self.pages[index] is VideoExerciseViewController {
                DispatchQueue.main.async {
                    self.pageViewController.isPagingEnabled = self.isPagingEnabled(index: index)
                }
            }
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
        self.pageControl.dots = dots
    }
    
}

