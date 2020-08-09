
import UIKit

class LyricsViewController: UIViewController {
    
   
    
    
    var lrcIndex = 0
    
    var time=0.0
    
    var process=0.0
    
    

    @IBOutlet weak var mLrcTable: SCTableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(time)
        self.mLrcTable.separatorStyle = .none                 // 去掉tableView分割线
        self.mLrcTable.showsVerticalScrollIndicator = false   // 去掉tableView垂直滚动条
        self.mLrcTable.updateLRC(currentTime: CGFloat(time))
        self.mLrcTable.lrcProgress=CGFloat(process)
        self.mLrcTable.prepareLRC(lrcPath:"Neon.lrc") // 歌词解析
        
        
        
    }
    
    
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // 上一行
    @IBAction func preLine(_ sender: Any) {
        if lrcIndex > 0 {
            lrcIndex  = lrcIndex - 1
            self.mLrcTable.Lrc_Index = lrcIndex
        }
    }
    
    // 下一行
    @IBAction func nextLine(_ sender: Any) {
        if lrcIndex < self.mLrcTable.mTimeArray.count - 1 {
            lrcIndex  = lrcIndex + 1
            self.mLrcTable.Lrc_Index = lrcIndex
        }
    }

}

