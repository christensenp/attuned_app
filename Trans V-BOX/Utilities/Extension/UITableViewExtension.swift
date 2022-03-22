
//  UITableViewExtension.swift
//  Trans V-BOX
//  Created by Trans V-BOX on 20/02/2020.
//  Copyright © 2020 Trans V-BOX. All rights reserved.


import UIKit

extension UITableView{

    func registerCell(_ identifier: String){
        self.register(UINib.init(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func setScrollIndicatorColor(color: UIColor) {
        for view in self.subviews {
            if let imageView = view as? UIImageView{
                imageView.backgroundColor = color
            }
        }
    }
    
    func revertTableView(){
        self.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    public func reloadDataAndKeepOffset() {
        // stop scrolling
        setContentOffset(contentOffset, animated: false)
        
        // calculate the offset and reloadData
        let beforeContentSize = contentSize
        reloadData()
        layoutIfNeeded()
        let afterContentSize = contentSize
        
        // reset the contentOffset after data is updated
        let newOffset = CGPoint(
            x: contentOffset.x + (afterContentSize.width - beforeContentSize.width),
            y: contentOffset.y + (afterContentSize.height - beforeContentSize.height))
        setContentOffset(newOffset, animated: false)
    }
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections - 1) - 1,
                section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}
