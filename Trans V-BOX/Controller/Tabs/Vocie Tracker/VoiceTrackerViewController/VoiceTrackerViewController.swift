//
//  VoiceTrackerViewController.swift
//  Trans V-BOX
//
//  Created by Mobikasa  on 19/03/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit
import SCLAlertView
import AudioKit
class VoiceTrackerViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.VoiceTrackerViewController
    static var storyBoardName: String = Storyboard.voiceTracker
    var dots = [PageControl.Dot]()
    var pages = [UIViewController]()
    var pageViewController: UIPageViewController!
    @IBOutlet weak var pageControl: PageControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControlWidthConstant: NSLayoutConstraint!
    var isRecording = false
    var isButtonHidden = true
    var oscillator: AKOscillatorBank? = AKOscillatorBank()
    let notificationButton = UIButton(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.configuration.spacing = 22
        pageControl.isUserInteractionEnabled = false
        self.showLoading()
        setUpPageController()
        notificationButton.setImage(UIImage(named: "push-notification"), for: .normal)
        notificationButton.addTarget(self, action: #selector(notificationButtonAction(_ :)), for: .touchUpInside)
        if !self.isButtonHidden {
            self.setLeftBarButtonItem(imageName: "back")
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationButton)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.createPaino()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopPaino()
    }

    func setUpPageController() {
        self.pages = []
        self.dots = []
        APIManager.shared.getRecordingTask {[weak self] (response, status, error) -> (Void) in
            guard let self = self else {return}
            self.stopLoading()
            if let response = response as? RecordingTaskModel {
                if let data = response.data, let taskList = data.taskList, String(describing: response.code.value) == StringConstants.successCode {
                    if let recCount = data.recCount?.value {
                        AppDelegate.sharedDelegate().recCount = Int("\(recCount)") ?? 1
                    }
                    for value in taskList {
                        let recordVoiceViewController = RecordVoiceViewController.instantiateFromStoryBoard()
                        recordVoiceViewController.recordingTask = value
                        recordVoiceViewController.delegate = self
                        recordVoiceViewController.isRecordingHandler = { [weak self] (status) in
                            guard let self = self else {return}
                            self.pageViewController.isPagingEnabled = !status
                        }
                        recordVoiceViewController.handler = { [weak self] in
                            guard let self = self else {return}
                            self.showSaveVideoAlert(controller: recordVoiceViewController)
                        }
                        self.pages.append(recordVoiceViewController)
                        self.dots.append(.greyStyle)
                    }
                    self.pageControl.dots = self.dots
                    self.pageControlWidthConstant.constant = CGFloat(22 * (self.dots.count - 1))
                    self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
                    self.pageViewController.delegate = self
                    self.pageViewController.dataSource = self
                    self.pageViewController.setViewControllers([self.pages[0]], direction: .forward, animated: true, completion: nil)
                    self.pageViewController.view.frame = self.containerView.bounds
                    self.containerView.addSubview(self.pageViewController.view)
                    self.pageViewController.didMove(toParent: self)
                    self.bouceButton()
                } else {
                    self.showWarningAlert(title: StringConstants.appName, message: response.message)
                }
            } else {
                self.showWarningAlert(title: StringConstants.appName, message: error ?? "")
            }
        }
    }

    func bouceButton() {
        notificationButton.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        UIView.animate(withDuration: 3.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.notificationButton.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
    }

    override func leftButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func notificationButtonAction(_ sender: UIButton) {
        self.presentAddCallNotificationContoller(name: "")
    }

    func setUpControllers() {
        let voiceTrackerViewController = VoiceTrackerViewController.instantiateFromStoryBoard()
        self.pages.append(voiceTrackerViewController)
        self.dots.append(.greyStyle)
    }
    
    func showSaveVideoAlert(controller: RecordVoiceViewController) {
        self.showAlert(controller: controller)
    }
    
    func showAlert(controller: RecordVoiceViewController) {
        self.showAlert(isUpdate: false, text: "Recording \(AppDelegate.sharedDelegate().recCount)") { [weak self] (text, alert) in
            guard let self = self else {return}
            if let tapeURL = controller.tape?.url {
                self.convert(inputURL: tapeURL) { [weak self] (url, status, error) -> (Void) in
                    guard let self = self, let url = url as? URL, let data = try? Data(contentsOf: url)  else {return}
                    let sum: Int = Int(controller.trackedFrequency.reduce(0, +))
                    let min = Int(controller.trackedFrequency.min() ?? 0)
                    let max = Int(controller.trackedFrequency.max() ?? 0)
                    var average: Int = 70
                    if controller.trackedFrequency.count > 0 {
                        average = sum / controller.trackedFrequency.count
                    }
                    let param: [String: Any] = [APIKeys.count: "\(AppDelegate.sharedDelegate().recCount)" ,APIKeys.recordingName: text.trim(), APIKeys.recordingTaskId: controller.recordingTask.id ?? "", APIKeys.avgFrequency: "\(average)", APIKeys.file: data, APIKeys.minFrequency: "\(min)", APIKeys.maxFrequency: "\(max)"]
                    // self.showLoading()
                    DispatchQueue.main.async {
                        (alert as? SaveRecordingViewController)?.dismiss(animated: true, completion: { [weak self] in
                            guard let self = self else { return }
                            let controller = AlertViewController.instantiateFromStoryBoard()
                            controller.modalPresentationStyle = .overCurrentContext
                            controller.modalTransitionStyle = .crossDissolve
                            if let tabBarController = self.tabBarController {
                                tabBarController.present(controller, animated: true, completion: nil)
                            } else {
                                self.present(controller, animated: true, completion: nil)
                            }
                        })
                    }
                    AppDelegate.sharedDelegate().recCount += 1
                    APIManager.shared.uploadAudio(param: param) { [weak self] (response, status, error) -> (Void) in
                        guard let self = self else {return}
                        self.stopLoading()
                    }
                }
            }
        }
    }

    func convert(inputURL: URL, completionHandler: @escaping DataCompletionBlock) {
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "\(Date().currentTimeMillis()).wav"
        documentsURL.appendPathComponent(fileName)
        try? (documentsURL as NSURL).setResourceValue(true, forKey: URLResourceKey.isExcludedFromBackupKey)
        var options = AKConverter.Options()
        options.format = "wav"
        options.sampleRate = 48000
        options.bitDepth = 24
        let converter = AKConverter(inputURL: inputURL, outputURL: documentsURL, options: options)
        converter.start(completionHandler: { error in
            if let error = error {
                completionHandler(nil, 404, error.localizedDescription)
                AKLog("Error during convertion: \(error)")
            } else {
                AKLog("Conversion Complete!")
                completionHandler(documentsURL, 200, nil)
            }
        })
    }

}

// MARK: - PageViewControl DataSource and Delegates
extension VoiceTrackerViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
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
        self.pageControl.dots = dots
    }
}

extension VoiceTrackerViewController: PainoViewDelegate {
    func createPaino() {
//        oscillator = AKOscillatorBank()
//        AudioKit.output = oscillator
//        try? AudioKit.start()
    }

    func noteOn(note: UInt8, frequeny: Double) {
        oscillator?.play(noteNumber: note, velocity: 80)
    }

    func noteOff(note: UInt8, frequeny: Double) {
        oscillator?.stop(noteNumber: note)
    }

    func stopPaino() {
//        oscillator = nil
//        try? AudioKit.stop()
    }
}
