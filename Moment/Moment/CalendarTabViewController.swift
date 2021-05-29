//
//  CalendarViewController.swift
//  MomentPractice
//
//  Created by Jaeyong Jeong on 2018. 4. 27..
//  Copyright © 2018년 Jaeyong Jeong. All rights reserved.
//

import UIKit

class CalendarTabViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, DateSelectedDelegate {
    enum MyTheme {
        case light
        case dark
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var theme = MyTheme.dark
    var selectedDate:Date?
    var dateMemos:[Memo] = []
    var delegate:DateSelectedDelegate?
    var selectMode:Bool = false
    var customTabBarVC:CustomTabBarController?
    var selectedItems:[Int] = []
  
  //  var currentFolder:Folder?
    //var folderIndex:Int?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Calender"
        self.navigationController?.navigationBar.isTranslucent=false
        self.view.backgroundColor=Style.bgColor
        
        view.addSubview(calendarView)
        calendarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive=true
        calendarView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive=true
        calendarView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive=true
        calendarView.heightAnchor.constraint(equalToConstant: 365).isActive=true
        
        /*바 버튼 초기화*/
        let lightBtn = UIBarButtonItem(title: "Light", style: .plain, target: self, action: #selector(lightBtnTabbed(sender:)))
        let saveBtn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveBtnTabbed(sender:)))
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnTabbed(sender:)))
        
        if selectMode == true {
            self.navigationItem.rightBarButtonItem = saveBtn
            self.navigationItem.leftBarButtonItem = cancelBtn
        } else {
            self.navigationItem.rightBarButtonItem = lightBtn
        }
        
        calendarView.delegate = self
        
        customTabBarVC = UIApplication.shared.keyWindow?.rootViewController as? CustomTabBarController
        
    }
    
    func dateSelected(selectedDate: Date) {
        dateMemos = []
        
        self.selectedDate = selectedDate
        //customTabBarVC?.selectedDate = selectedDate
        
        for i in calendarFolder.memoCollection {
            if i.date == selectedDate {
                dateMemos.append(i)
            }
        }
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let date = selectedDate {
            dateSelected(selectedDate: date)
        } else {
            collectionView.reloadData()
        }
        
        customTabBarVC?.currentFolder = calendarFolder
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dateMemos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderViewCell", for: indexPath) as! FolderViewCell
        
        cell.previewText.text = dateMemos[indexPath.item].text
        cell.previewImage.image = UIImage(named: "postit")
        cell.cellType = FolderViewCell.CellType.MemoCell(dateMemos[indexPath.item])
        
        return cell
    }
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calendarView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func lightBtnTabbed(sender: UIBarButtonItem) {
        if theme == .dark {
            sender.title = "Dark"
            theme = .light
            Style.themeLight()
        } else {
            sender.title = "Light"
            theme = .dark
            Style.themeDark()
        }
        self.view.backgroundColor=Style.bgColor
        calendarView.changeTheme()
    }
    
    let calendarView: CalendarView = {
        let v = CalendarView(theme: MyTheme.dark)
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    @objc func saveBtnTabbed(sender: UIBarButtonItem) {
        if let date = selectedDate{
            delegate?.dateSelected(selectedDate: date)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelBtnTabbed(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

}
