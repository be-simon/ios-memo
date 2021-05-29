//
//  memoModel.swift
//  MomentPractice
//
//  Created by Jaeyong Jeong on 2018. 4. 22..
//  Copyright © 2018년 Jaeyong Jeong. All rights reserved.
//

import Foundation

class Memo : Codable{
    var text:String = ""
    var date:Date?
    
    init(text:String){
        self.text = text
    }
    
    func editMemoText(text:String) {
        self.text = text
    }
}
