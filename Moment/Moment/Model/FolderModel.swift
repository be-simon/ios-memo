import Foundation

class Folder : Codable {
    var folderCollection:[Folder] = []
    var memoCollection:[Memo] = []
    var folderTitle:String?
    var folderImage:String?
    
    init(){}
    init(folderTitle:String){
        self.folderTitle = folderTitle
    }
    
    func editFolderTitle(title:String){
        folderTitle = title
    }
    
    func addFolder(title:String){
        let newFolder = Folder(folderTitle: title)
        
        folderCollection.append(newFolder)
        
        if let data = try? encoder.encode(rootFolder) {
            try! data.write(to: fileUrl)
        }
        
        if let data = try? encoder.encode(calendarFolder) {
            try! data.write(to: calendarFileUrl)
        }
    }
    
    func deleteFolder(index: Int) {
        folderCollection.remove(at: index)
        
        if let data = try? encoder.encode(rootFolder) {
            try! data.write(to: fileUrl)
        }
        
        if let data = try? encoder.encode(calendarFolder) {
            try! data.write(to: calendarFileUrl)
        }
    }
    
    func addmemo(memo: Memo){
        let newMemo = Memo(text: memo.text)
        newMemo.date = memo.date
        memoCollection.append(newMemo)
        
        if let data = try? encoder.encode(rootFolder) {
            try! data.write(to: fileUrl)
        }
        
        if let data = try? encoder.encode(calendarFolder) {
            try! data.write(to: calendarFileUrl)
        }
    }
    
    func addMemo(text:String){
        let newMemo = Memo(text: text)
        
        memoCollection.append(newMemo)
        
        if let data = try? encoder.encode(rootFolder) {
            try! data.write(to: fileUrl)
        }
        
        if let data = try? encoder.encode(calendarFolder) {
            try! data.write(to: calendarFileUrl)
        }
    }
    
    func deleteMemo(index: Int) {
        memoCollection.remove(at: index)
        
        if let data = try? encoder.encode(rootFolder) {
            try! data.write(to: fileUrl)
        }
        
        if let data = try? encoder.encode(calendarFolder) {
            try! data.write(to: calendarFileUrl)
        }
    }
}

var rootFolder:Folder = Folder()
var calendarFolder:Folder = Folder()
let filePath = NSHomeDirectory() + "/Documents/FileData.json"
let fileUrl = URL.init(fileURLWithPath: filePath)
let calendarFilePath = NSHomeDirectory() + "/Documents/CalendarFileData.json"
let calendarFileUrl = URL.init(fileURLWithPath: calendarFilePath)
let encoder = JSONEncoder()
let decoder = JSONDecoder()
