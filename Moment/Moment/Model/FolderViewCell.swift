//
//  File.swift
//  MomentPractice
//
//  Created by Jaeyong Jeong on 2018. 4. 22..
//  Copyright © 2018년 Jaeyong Jeong. All rights reserved.
//

import UIKit

class FolderViewCell : UICollectionViewCell {
    
    
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var previewText: UILabel!
    
    enum CellType {
        case MemoCell(Memo)
        case FolderCell(Folder)
    }

    var cellType:CellType?
}
