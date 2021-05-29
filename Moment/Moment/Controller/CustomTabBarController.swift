import UIKit

class CustomTabBarController: UITabBarController  {
    
    @IBOutlet var customTabBarView: UIView!
    
    var currentFolder:Folder = rootFolder
    //var selectedDate:Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customTabBarView.frame = self.tabBar.frame
        self.view.addSubview(customTabBarView)
        
        print(NSHomeDirectory())
    }

    @IBAction func customTabBarAction(sender: UIButton){
        switch sender.tag {
        case 2:
            guard let newEditMemoVC = self.storyboard?.instantiateViewController(withIdentifier: "EditMemoView") as? EditMemoViewController else {
                print("new EditMemoVC is nil")
                return
            }
            
            newEditMemoVC.currentFolder = self.currentFolder
            self.present(newEditMemoVC, animated: true, completion: nil)
                
        default:
            self.selectedIndex = sender.tag
        }
    }
}
