//
//  ViewController.swift
//  MomentPractice
//
//  Created by Jaeyong Jeong on 2018. 4. 22..
//  Copyright © 2018년 Jaeyong Jeong. All rights reserved.
//

import UIKit

class FolderTabViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var folderView: UICollectionView!
    @IBOutlet weak var naviItem: UINavigationItem!
    @IBOutlet var editBtnView: UIView!
    
    var editBtn:UIBarButtonItem = UIBarButtonItem()
    var addFolderBtn:UIBarButtonItem = UIBarButtonItem()
    var cancelBtn:UIBarButtonItem = UIBarButtonItem()
    
    var selectedItems:[Int] = []
    var customTabBarVC:CustomTabBarController?

    enum folderTabMode:Int {
        case updateMode
        case selectMode
    }
    var tabMode = folderTabMode.selectMode
    
    override func viewDidLoad() {
        /*메인 화면 만들기*/
        super.viewDidLoad()

        let postSize = UIScreen.main.bounds.width/3 - 3

        let mainLayout = UICollectionViewFlowLayout()
        mainLayout.sectionInset =  UIEdgeInsetsMake(20, 0, 10, 0)
        mainLayout.itemSize = CGSize(width: postSize, height: postSize)
        mainLayout.minimumInteritemSpacing = 3
        mainLayout.minimumLineSpacing = 3

        folderView.collectionViewLayout = mainLayout
        
        self.title = "Folder"
        
        /*바 버튼 초기화*/
        editBtn = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editBtnTabbed(sender:)))
        addFolderBtn = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addFolderBtnTabbed(sender:)))
        cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnTabbed(sender:)))
        
        naviItem.rightBarButtonItems = [editBtn, addFolderBtn]
        
        /*편집 뷰 초기화*/
        customTabBarVC = UIApplication.shared.keyWindow?.rootViewController as? CustomTabBarController
        if let vc = customTabBarVC {
            editBtnView.frame = vc.tabBar.frame
            self.view.addSubview(editBtnView)
            editBtnView.isHidden = true
        }
        
        /*인코딩 데이터 불러오기*/
        if let data = try? Data.init(contentsOf: fileUrl) {
            rootFolder = try! decoder.decode(Folder.self, from: data)
        }
        
        if let data = try? Data.init(contentsOf: calendarFileUrl) {
            calendarFolder = try! decoder.decode(Folder.self, from: data)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        folderView.reloadData()
        customTabBarVC?.currentFolder = rootFolder
    }

    // -----------
    //
    // Collection View DataSource
    //
    // -----------
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: // folder section
            return rootFolder.folderCollection.count
        case 1: // default memo section
            return rootFolder.memoCollection.count
        default:
            print("NumberOfItemsInSection: unknown section number")
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = folderView.dequeueReusableCell(withReuseIdentifier: "FolderViewCell", for: indexPath) as! FolderViewCell

        switch indexPath.section {
        case 0:
            cell.previewText.text = rootFolder.folderCollection[indexPath.item].folderTitle
            cell.previewImage.image = UIImage(named: "folder")
            cell.cellType = .FolderCell(rootFolder.folderCollection[indexPath.item])
        case 1:
            cell.previewText.text = rootFolder.memoCollection[indexPath.item].text
            cell.previewImage.image = UIImage(named: "postit")
            cell.cellType = .MemoCell(rootFolder.memoCollection[indexPath.item])
        default:
            print("cellForItemAt : unknown section number")
        }
        
        cell.layer.borderWidth = 0
        //cell.layer.borderColor = UIColor.white.cgColor
        
        return cell
    }

    // -----------
    //
    // Collection View Delegate
    //
    // -----------
    
    func updateModeAction(selectedIndex: Int, selectedCell: FolderViewCell) {
        switch selectedCell.cellType {
        case .FolderCell(let folder) :
            /*알림창 띄우기*/
            let alertViewController = UIAlertController(title: "\(String(describing: folder.folderTitle)) 폴더를 지우겠습니까?", message: "폴더의 모든 메모도 지워집니다", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler:{
                (UIAlertAction) -> Void in
                rootFolder.deleteFolder(index: selectedIndex)
                self.changeToSelectMode()
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
                (UIAlertAction) -> Void in
                self.dismiss(animated: true, completion: nil)
                self.changeToSelectMode()
            })
            
            alertViewController.addAction(deleteAction)
            alertViewController.addAction(cancelAction)
            self.present(alertViewController, animated: true, completion: nil)
            
            
        case .MemoCell( _) :
            selectedItems.append(selectedIndex)
            selectedCell.layer.borderWidth = 2.0
            selectedCell.layer.borderColor = UIColor.gray.cgColor
        case .none:
            print("updateModeAction : none cellType")
        }
    }
    
    func selectModeAction(selectedIndex: Int, selectedCell: FolderViewCell) {
        switch selectedCell.cellType {
        case .FolderCell(let folder) : //폴더 선택 시
            if let newFolderViewController = self.storyboard?.instantiateViewController(withIdentifier: "FolderView") as? FolderViewController {
                newFolderViewController.currentFolder = folder
                self.navigationController?.pushViewController(newFolderViewController, animated: true)
            }
        case .MemoCell(let memo) : //메모 선택 시
            if let newEditMemoViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditMemoView") as? EditMemoViewController {
                newEditMemoViewController.currentMemo = memo
                newEditMemoViewController.memoIndex = selectedIndex
                self.present(newEditMemoViewController, animated: true, completion: nil)
            }
        case .none:
            print("selectModeAction : none cellType")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedIndex = indexPath.row
        
        guard let selectedCell = folderView.cellForItem(at: indexPath) as? FolderViewCell else {
            print("didSelectItemAt : no selected cell")
            return
        }
        
        switch tabMode {
        case folderTabMode.selectMode:
            selectModeAction(selectedIndex:selectedIndex, selectedCell: selectedCell)
        case folderTabMode.updateMode:
            updateModeAction(selectedIndex: selectedIndex, selectedCell: selectedCell)
        }
    }
    
    func changeToSelectMode(){
        tabMode = folderTabMode.selectMode
        customTabBarVC?.customTabBarView.isHidden = false
        editBtnView.isHidden = true
        
        naviItem.rightBarButtonItems = [editBtn, addFolderBtn]
        selectedItems = []
        folderView.reloadData()
    }
    
    func changeToUpdateMode() {
        tabMode = folderTabMode.updateMode
        customTabBarVC?.customTabBarView.isHidden = true
        editBtnView.isHidden = false
        
        naviItem.rightBarButtonItems = [cancelBtn, addFolderBtn]
    }
    
    /*버튼 액션*/
    @objc func editBtnTabbed(sender: UIBarButtonItem) {
        changeToUpdateMode()
    }
    
    @objc func addFolderBtnTabbed(sender: UIBarButtonItem) {
        if let newAddFolderViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddFolderView"){
            self.present(newAddFolderViewController, animated: true, completion: nil)
        }
    }
    
    @objc func cancelBtnTabbed(sender: UIBarButtonItem) {
        changeToSelectMode()
    }
    
    @IBAction func moveBtnTabbed(_ sender: UIButton) {
        if let newFolderListViewController = self.storyboard?.instantiateViewController(withIdentifier: "FolderListView") as? FolderListViewController{
            newFolderListViewController.currentFolder = rootFolder
            newFolderListViewController.selectedItems = selectedItems
            
            self.present(newFolderListViewController, animated: true, completion: nil)
        }
        
        changeToSelectMode()
    }
    
    @IBAction func deleteBtnTabbed(_ sender: UIButton) {
        selectedItems.sort()
        selectedItems.reverse()
        
        for index in selectedItems {
            rootFolder.deleteMemo(index: index)
        }
        
        changeToSelectMode()
    }
    
}
