//
//  VoiceTableViewCell.swift
//  Trans V-BOX
//
//  Created by Mobikasa  on 04/03/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class VoiceTableViewCell: UITableViewCell {
    
    static let cellIdentifier = CellIdentifiers.VoiceTableViewCell
    @IBOutlet weak var collectionViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var footerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var sections = [[QuestionOption]]()
    var selectionHanler: SelectionClosure!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.registerCell(VoiceCollectionViewCell.cellIdentifier)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setUp(options: [QuestionOption], handler: @escaping SelectionClosure) {
        self.selectionHanler = handler
        let filter = options.filter{$0.isAnswer}
        self.footerLabel.text = ""
        if filter.count > 0 {
            self.footerLabel.text = filter[0].optionDesc ?? ""
        }
        self.sections = options.chunked(by: 3)
        collectionView.reloadData()
        collectionViewHeightConstant.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionView.reloadData()
    }
    
}

extension Array {
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}

extension VoiceTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width) / 3
        return CGSize(width: width, height: width + 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VoiceCollectionViewCell.cellIdentifier, for: indexPath) as! VoiceCollectionViewCell
        let width = (collectionView.frame.size.width - 60) / 3
        cell.widthConstant.constant = width
        cell.setUp(model: self.sections[indexPath.section][indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: section == 0 ? 0 : 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if self.sections[section].count < 3 {
            let width =  (collectionView.frame.size.width) / 3
            let cellCount  = self.sections[section].count
            let totalCellWidth = width * CGFloat(cellCount)
            let totalSpacingWidth = CGFloat(cellCount - 1)
            let leftInset = (collectionView.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            let rightInset = leftInset
            return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(IndexPath(row: indexPath.row + indexPath.section, section: indexPath.section))
        self.selectionHanler(IndexPath(row: (3 * indexPath.section) + indexPath.row, section: indexPath.section))
    }
    
}
