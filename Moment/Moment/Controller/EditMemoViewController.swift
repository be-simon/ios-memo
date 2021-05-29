//
//  MemoEditViewController.swift
//  MomentPractice
//
//  Created by Jaeyong Jeong on 2018. 4. 22..
//  Copyright © 2018년 Jaeyong Jeong. All rights reserved.
//

import UIKit

class EditMemoViewController: UIViewController, DateSelectedDelegate {

    @IBOutlet weak var naviItem: UINavigationItem!
    @IBOutlet weak var editTextView: UITextView!
    @IBOutlet var editBtnView: UIView!
    
    var currentFolder:Folder = rootFolder
    var currentMemo:Memo?
    var memoIndex:Int?
    var customTabBarVC:CustomTabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editTextView.text = currentMemo?.text ?? ""

        customTabBarVC = UIApplication.shared.keyWindow?.rootViewController as? CustomTabBarController

        if let customVC = customTabBarVC {
            customVC.tabBar.isHidden = true
            editBtnView.frame = customVC.tabBar.frame
            self.view.addSubview(editBtnView)
        }

        /*바 버튼 초기화*/
        let saveBtn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveBtnTabbed(sender:)))
        naviItem.rightBarButtonItems = [saveBtn]
        
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnTabbed(sender:)))
        naviItem.leftBarButtonItems = [cancelBtn]
        
        if currentMemo == nil {//새로운 메모 추가
            editBtnView.isHidden = true
        }

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        customTabBarVC?.tabBar.isHidden = false
    }
    
    func dateSelected(selectedDate: Date) {
        if let memo = currentMemo{
            memo.date = selectedDate
            calendarFolder.memoCollection.append(memo)
        }
    }
    
    /*버튼 동작 함수*/
    @objc func saveBtnTabbed(sender: UIBarButtonItem) {
    
        if let memo = currentMemo {//메모 편집
            memo.editMemoText(text: editTextView.text)
        } else {
            //currentFolder.addMemo(text: editTextView.text)
            var newMemo = Memo(text: editTextView.text)
            if currentFolder === calendarFolder {
                let calendarVC = customTabBarVC?.childViewControllers[1].childViewControllers[0] as? CalendarTabViewController
                newMemo.date = calendarVC?.selectedDate
    
            }
            
            currentFolder.addmemo(memo: newMemo)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelBtnTabbed(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editBtnTabbed(sender: UIButton) {
        let calendarVC = storyboard?.instantiateViewController(withIdentifier: "CalendarView") as? CalendarTabViewController
        calendarVC?.delegate = self
        calendarVC?.selectMode = true
        let newNaviVC = UINavigationController(rootViewController: calendarVC!)
        
        self.present(newNaviVC, animated: true, completion: nil)
    }
    
    @IBAction func deleteBtnTabbed(sender: UIButton) {
        if let index = memoIndex {
            currentFolder.deleteMemo(index: index)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
