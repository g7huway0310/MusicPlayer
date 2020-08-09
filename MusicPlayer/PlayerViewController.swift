//
//  ViewController.swift
//  MusicPlayer
//
//  Created by guowei on 2020/7/29.
//  Copyright © 2020 guowei. All rights reserved.
//

import UIKit
import AVFoundation

protocol PassRatingdata : class {
    func  receiveData(data: Int)
}

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var musicImage: UIImageView!
  
    
    @IBOutlet var starLabel: [UIButton]!
    
    var rating=0
    
    @IBOutlet weak var singer: UILabel!
    
    @IBOutlet weak var songSilder: UISlider!
    
    @IBOutlet weak var songName: UILabel!
    
    @IBOutlet weak var songLengthLabel: UILabel!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var playBtn: UIButton!
    
    let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectcontrollerViewController") as! SelectcontrollerViewController
    
    var timeoObserver:Any?
    
    var position:Int=0
    
    var userRating=0
    
    var songs:[Song]=[Song]()
    
    var audioPlayer=AVPlayer()//製作一個AVPlayer物件
    
    var playerItem:AVPlayerItem? //抓取音樂長度
    
    var timer=Timer()
    
    var currentTime=0.0
    
    weak var delegate: PassRatingdata?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        
        
        PrepareSong()
        
        PrepareIB()
        
        updatePlayerUI()
        
        showSongRealTime()
        
        playBtn.setImage(UIImage(named: "icons8-pause-50"), for: .normal)
        
        setButton()
        
        print(songs.count)
        
    }
    
    override func viewWillLayoutSubviews() {
      self.songSilder.setThumbImage(UIImage(named:"cycle15")!, for: .normal)
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        if (timeoObserver != nil) {
            if audioPlayer.rate == 1.0 { // it is required as you have to check if player is playing
                audioPlayer.removeTimeObserver(timeoObserver)
                audioPlayer.pause()
            }
        }
        delegate?.receiveData(data: userRating+1)
        
        songs[position].rating=userRating+1
        
        print(songs[position].rating)
        
    }
    @objc func showSongRealTime(){
        
        timeoObserver=audioPlayer.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1),
                                            
        queue: DispatchQueue.main, using: { (CMTime) in
                                                            
        if self.audioPlayer.currentItem?.status == .readyToPlay {
                                                                
            self.currentTime = CMTimeGetSeconds(self.audioPlayer.currentTime())
            
            let duration = Float((CMTimeGetSeconds(self.audioPlayer.currentItem!.asset.duration)))
                                                                
            self.songSilder.value = Float(self.currentTime)
            
            let process = Float(self.currentTime)/duration
            
            self.currentTimeLabel.text = self.formatConversion(time: self.currentTime)
                                                                
            self.delegate=self.vc as! PassRatingdata
            
//          self.delegate?.receiveData(data: self.currentTime)
           }
                                                            
        }
            
    )
   
        
        
}
    
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        
        //根據播放rate(播放速率)判斷是否正在播放
    
        let playBtnImage=sender.image(for: .normal)
        
        if playBtnImage == UIImage(named: "icons8-play-50"){
            if audioPlayer.rate == 0{            //rate0代表中暫停中
                audioPlayer.play()
                sender.setImage(UIImage(named: "icons8-pause-50"), for: .normal)
            }
        }
        
        else if playBtnImage == UIImage(named: "icons8-pause-50"){
             if audioPlayer.rate == 1{
                audioPlayer.pause()
                sender.setImage(UIImage(named: "icons8-play-50"), for: .normal)
            }
        }
            

    }
    
    
    
    
   @IBAction func songSliderValueChanged(_ sender: UISlider) {
        
        let seconds = Int64(songSilder.value)
        
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        audioPlayer.seek(to: targetTime)
        //如果目前是暫停，自動播放
        if audioPlayer.rate == 0
        {
            audioPlayer.play()
        }
        
        
        
    }
    
    func PrepareSong(){
        //選定song
        let song=songs[position]
        
        let fileUrl=Bundle.main.url(forResource: song.trackName, withExtension: "mp3")
        
        do{
            
            try AVAudioSession.sharedInstance().setMode(.default)
            
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let fileUrl = fileUrl else{
                print("player is nil")
                return
            }
            
            playerItem=AVPlayerItem(url: fileUrl)
            
            audioPlayer = AVPlayer(playerItem: playerItem!)
            
            audioPlayer.play()
            
            
        }
        catch{
            print("Error occurred")
        }
        
    }
    
    @IBAction func nextBtn(_ sender: UIButton) {
        audioPlayer.removeTimeObserver(timeoObserver)
        
        position+=1
        if position>songs.count-1{
           position=0
        }
        
        PrepareSong()
        PrepareIB()
        updatePlayerUI()
        showSongRealTime()
        
        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        
        audioPlayer.removeTimeObserver(timeoObserver)
        
        position-=1
        if position<0{
            position=songs.count-1
        }
        PrepareSong()
        PrepareIB()
        updatePlayerUI()
        showSongRealTime()
        
    }
    
    
    func PrepareIB(){
        
        let song=songs[position]
        //設定顯示的專輯圖片
        musicImage.image=UIImage(named: song.imageName)
        
        singer.text=song.artistName
        songName.text=song.name
    }
    func updatePlayerUI(){
        
        // 抓取 playItem 的 duration
        let duration = playerItem!.asset.duration
        // 把 duration 轉為我們歌曲的總時間（秒數）。
        let seconds = CMTimeGetSeconds(duration)
        // 把我們的歌曲總時長顯示到我們的 Label 上。
        songLengthLabel.text = formatConversion(time: seconds)
        
        songSilder.minimumValue = 0
        // 更新 Slider 的 maximumValue。
        songSilder.maximumValue = Float(seconds)
        // 這裡看個人需求，如果想要拖動後才更新進度，那就設為 false；如果想要直接更新就設為 true，預設為 true。
        songSilder.isContinuous = true
        
        
    }
    
    @IBAction func Btn1Press(_ sender: UIButton) {
        
        if starLabel[0].image(for: .normal)==UIImage(systemName: "star.fill"){
           starLabel[0].setImage(UIImage(systemName: "star"), for: .normal)
        }else if starLabel[0].image(for: .normal)==UIImage(systemName: "star"){
           starLabel[0].setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        showStarImage()
        if userRating>0{
           userRating=0
           showStarImage()
        }
    }
    @IBAction func Btn2Press(_ sender: UIButton) {
        userRating+=1
        showStarImage()
        if userRating>1{
            userRating=0
            showStarImage()
        }
       
    }
    @IBAction func btn3Press(_ sender: Any) {
        userRating+=1
        showStarImage()
        if userRating>2{
            userRating=1
            showStarImage()
        }
       
       
    }
    @IBAction func btn4Press(_ sender: Any) {
        userRating+=1
        showStarImage()
        if userRating>3{
            userRating=2
            showStarImage()
        }
        
        
    }
    
    @IBAction func btn5Press(_ sender: Any) {
        
        userRating+=1
        showStarImage()
        if userRating>4{
           userRating=3
           showStarImage()
        }
    }
    
    
   func showStarImage(){
        
        switch userRating {
            
        case 0:
            starLabel[0].setImage(UIImage(systemName: "star.fill"), for: .normal)
            starLabel[1].setImage(UIImage(systemName: "star"), for: .normal)
            starLabel[2].setImage(UIImage(systemName: "star"), for: .normal)
            starLabel[3].setImage(UIImage(systemName: "star"), for: .normal)
            starLabel[4].setImage(UIImage(systemName: "star"), for: .normal)
        case 1:
            starLabel[0].setImage(UIImage(systemName: "star.fill"), for: .normal)
            starLabel[1].setImage(UIImage(systemName: "star.fill"), for: .normal)
            starLabel[2].setImage(UIImage(systemName: "star"), for: .normal)
            starLabel[3].setImage(UIImage(systemName: "star"), for: .normal)
            starLabel[4].setImage(UIImage(systemName: "star"), for: .normal)
        case 2:
            starLabel[0].setImage(UIImage(systemName: "star.fill"), for: .normal)
            starLabel[1].setImage(UIImage(systemName: "star.fill"), for: .normal)
            starLabel[2].setImage(UIImage(systemName: "star.fill"), for: .normal)
            starLabel[3].setImage(UIImage(systemName: "star"), for: .normal)
            starLabel[4].setImage(UIImage(systemName: "star"), for: .normal)
        case 3:
            starLabel[0].setImage(UIImage(systemName: "star.fill"), for: .normal)
            starLabel[1].setImage(UIImage(systemName: "star.fill"), for: .normal)
            starLabel[2].setImage(UIImage(systemName: "star.fill"), for: .normal)
            starLabel[3].setImage(UIImage(systemName: "star.fill"), for: .normal)
            starLabel[4].setImage(UIImage(systemName: "star"), for: .normal)
        case 4:
            starLabel[0].setImage(UIImage(systemName: "star.fill"), for: .normal)
            starLabel[1].setImage(UIImage(systemName: "star.fill"), for: .normal)
            starLabel[2].setImage(UIImage(systemName: "star.fill"), for: .normal)
            starLabel[3].setImage(UIImage(systemName: "star.fill"), for: .normal)
            starLabel[4].setImage(UIImage(systemName: "star.fill"), for: .normal)
        default:
            starLabel[0].setImage(UIImage(systemName: "star"), for: .normal)
            starLabel[1].setImage(UIImage(systemName: "star"), for: .normal)
            starLabel[2].setImage(UIImage(systemName: "star"), for: .normal)
            starLabel[3].setImage(UIImage(systemName: "star"), for: .normal)
            starLabel[4].setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    func formatConversion(time:Float64)->String{
        let songLength = Int(time)
        let minutes = Int(songLength / 60) // 求 songLength 的商，為分鐘數
        let seconds = Int(songLength % 60) // 求 songLength 的餘數，為秒數
        var time = ""
        if minutes < 10 {
            time = "0\(minutes):"
        } else {
            time = "\(minutes)"
        }
        if seconds < 10 {
            time += "0\(seconds)"
        } else {
            time += "\(seconds)"
        }
        return time
        
    }
   func setButton(){
        for i in 0...4{
        starLabel[i].setImage(UIImage(systemName: "star"), for: .normal)
        }
    }

}
