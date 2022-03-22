//
//  TextExerciseViewController.swift
//  Trans V-BOX
//
//  Created by Gourav on 25/03/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class TextExerciseViewController: BaseViewController {

    static var storyBoardId: String = ViewIdentifiers.TextExerciseViewController
    static var storyBoardName: String = Storyboard.lessions
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    var lessonContent: LessonContent!
    // var scrollBar: SwiftyVerticalScrollBar?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.showsVerticalScrollIndicator = false
        messageLabel.text = lessonContent.contentText
    }

    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.persistantScrollBar()
    }

    func persistantScrollBar() {
        scrollView.setNeedsLayout()
        scrollView.layoutIfNeeded()
        if self.scrollView.contentSize.height > self.scrollView.frame.size.height + 10 {
            scrollView.enableCustomScrollIndicators(with: .classic, positions: .verticalScrollIndicatorPositionRight, color: UIColor.colorWithRGB(r: 205, g: 218, b: 235))
            scrollView.refreshCustomScrollIndicators(withAlpha: 1.0)
        }
    }

    deinit {
        print("delloc TextExerciseViewController")
    }

}
