//
//  FolderListViewController.swift
//  Moment
//
//  Created by Jaeyong Jeong on 2018. 6. 13..
//  Copyright © 2018년 Jaeyong Jeong. All rights reserved.
//

import UIKit

class FolderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var naviItem: UINavigationItem!

    var currentFolder:Folder = rootFolder
    var selectedItems:[Int] = []
    
    override func viewDidLoad() {
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnTabbed(sender:)))
        naviItem.rightBarButtonItems = [cancelBtn]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return rootFolder.folderCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolderListCell", for: indexPath) as! FolderListCell
        
        cell.folderTitle.text = rootFolder.folderCollection[indexPath.row].folderTitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        selectedItems.sort()
        for index in selectedItems {
            rootFolder.folderCollection[indexPath.row].addmemo(memo: currentFolder.memoCollection[index])
        }
        
        selectedItems.reverse()
        for index in selectedItems {
            currentFolder.deleteMemo(index: index)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelBtnTabbed(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
