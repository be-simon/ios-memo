//
//  AddFolderViewController.swift
//  MomentPractice
//
//  Created by Jaeyong Jeong on 2018. 4. 25..
//  Copyright © 2018년 Jaeyong Jeong. All rights reserved.
//

import UIKit

class AddFolderViewController : UIViewController {
    
    @IBOutlet weak var naviItem: UINavigationItem!
    @IBOutlet weak var folderTitleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*바 버튼 초기화*/
        let saveBtn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveBtnTabbed(sender:)))
        naviItem.rightBarButtonItems = [saveBtn]
        
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnTabbed(sender:)))
        naviItem.leftBarButtonItems = [cancelBtn]
    }
    
    /*버튼 액션 함수*/
    @objc func saveBtnTabbed(sender: UIBarButtonItem) {
        rootFolder.addFolder(title: folderTitleTextField.text ?? "")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelBtnTabbed(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
