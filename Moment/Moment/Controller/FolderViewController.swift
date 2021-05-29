//
//  FolderViewController.swift
//  Moment
//
//  Created by Jaeyong Jeong on 2018. 6. 8..
//  Copyright © 2018년 Jaeyong Jeong. All rights reserved.
//

import UIKit

class FolderViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var editBtnView: UIView!
    
    var editBtn:UIBarButtonItem = UIBarButtonItem()
    var cancelBtn:UIBarButtonItem = UIBarButtonItem()
    
    var selectedItems:[Int] = []
    var selectMode = false
    var currentFolder:Folder?
    var folderIndex:Int?
    var customTabBarVc:CustomTabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postSize = UIScreen.main.bounds.width/3 - 3
        
        let mainLayout = UICollectionViewFlowLayout()
        mainLayout.sectionInset =  UIEdgeInsetsMake(20, 0, 10, 0)
        mainLayout.itemSize = CGSize(width: postSize, height: postSize)
        mainLayout.minimumInteritemSpacing = 3
        mainLayout.minimumLineSpacing = 3
        
        collectionView.collectionViewLayout = mainLayout
        
        self.title = currentFolder?.folderTitle
        
        /*바 버튼 초기화*/
        editBtn = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editBtnTabbed(sender:)))
        cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnTabbed(sender:)))
        
        self.navigationItem.rightBarButtonItems = [editBtn]
        
        /*편집 뷰 초기화*/
        if let parent = self.parent as? UINavigationController{
            if let folderTabVC = parent.viewControllers[0] as? FolderTabViewController{
                customTabBarVc = folderTabVC.customTabBarVC
                self.editBtnView.frame = folderTabVC.editBtnView.frame
                self.view.addSubview(editBtnView)
                self.editBtnView.isHidden = true
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
        
        if let folder = currentFolder {
            customTabBarVc?.currentFolder = folder
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let folder = currentFolder {
            return folder.memoCollection.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderViewCell", for: indexPath) as! FolderViewCell
        
        if let folder = currentFolder{
            if folder.memoCollection.count != 0 {
                cell.previewText.text = folder.memoCollection[indexPath.item].text 
                cell.previewImage.image = UIImage(named: "postit")
                cell.cellType = .MemoCell(folder.memoCollection[indexPath.item])
            }
        }
        
        cell.layer.borderWidth = 0
        cell.layer.borderColor = UIColor.white.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedIndex = indexPath.row
        
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? FolderViewCell{
            if selectMode == true {//편집 모드
                selectedItems.append(selectedIndex)
                selectedCell.layer.borderWidth = 2.0
                selectedCell.layer.borderColor = UIColor.gray.cgColor
            }
            else {//편집 모드 아니고 그냥 선택
                if let newEditMemoViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditMemoView") as? EditMemoViewController {
                    newEditMemoViewController.currentMemo = currentFolder?.memoCollection[indexPath.item]
                    newEditMemoViewController.memoIndex = selectedIndex
                    self.present(newEditMemoViewController, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    func changeToInitMode(){
        selectMode = false
        customTabBarVc?.customTabBarView.isHidden = false
        editBtnView.isHidden = true
        
        self.navigationItem.rightBarButtonItems = [editBtn]
        selectedItems = []
        collectionView.reloadData()
    }
    
    func changeToSelectMode() {
        selectMode = true
        customTabBarVc?.customTabBarView.isHidden = true
        editBtnView.isHidden = false
        
        self.navigationItem.rightBarButtonItems = [cancelBtn]
    }
    
    @objc func editBtnTabbed(sender: UIBarButtonItem) {
        changeToSelectMode()
    }
    
    @objc func cancelBtnTabbed(sender: UIBarButtonItem) {
        changeToInitMode()
    }
    
    @IBAction func moveBtnTabbed(_ sender: UIButton) {
        if let newFolderListViewController = self.storyboard?.instantiateViewController(withIdentifier: "FolderListView") as? FolderListViewController{
            newFolderListViewController.currentFolder = currentFolder!
            newFolderListViewController.selectedItems = selectedItems
            
            self.present(newFolderListViewController, animated: true, completion: nil)
        }
        
        changeToInitMode()
    }
    
    @IBAction func deleteBtnTabbed(_ sender: UIButton) {
        selectedItems.sort()
        selectedItems.reverse()
        
        for index in selectedItems {
            currentFolder?.deleteMemo(index: index)
        }
        
        changeToInitMode()
    }
    
}
