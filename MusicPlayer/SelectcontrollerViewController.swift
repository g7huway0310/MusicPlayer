//
//  selectcontrollerViewController.swift
//  MusicPlayer
//
//  Created by guowei on 2020/8/4.
//  Copyright © 2020 guowei. All rights reserved.
//

import UIKit

class SelectcontrollerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var table: UITableView!
    
    
    
    
    var songs=[Song]()
    
    
    
    var lrcIndex = 0
         
   var rate=0
         
       
         
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        table.delegate=self
        
        table.dataSource=self
        
        //自訂tableView
        
        let nib=UINib(nibName:"MusicTableViewCell", bundle: nil)
        //註冊cell使用自訂的xib
        table.register(nib,forCellReuseIdentifier:"MusicTableViewCell")
        
        
        
        
        
        loadSong()
        
    }
    
    func loadSong(){
        
        songs.append(Song(name: "Noen",
                         artistName: "John Mayer",
                         albumName: "'Where the Light Is' live in LA",
                         imageName: "cover1",
                         trackName: "NeonAudio",
                         rating: 5))
        songs.append(Song(name: "Gravity",
                         artistName: "John Mayer",
                         albumName: "'Where the Light Is' live in LA'",
                         imageName: "cover1",
                         trackName: "GavityAudio",
                         rating:5))
        songs.append(Song(name: "Covered in Rain",
                            artistName: "John Mayer",
                            albumName: "'Where the Light Is' live in LA'",
                            imageName: "cover1",
                            trackName: "CoveredinRain",
                            rating:5))
        songs.append(Song(name: "Bold As Love",
                            artistName: "John Mayer",
                            albumName: "'Where the Light Is' live in LA'",
                            imageName: "cover1",
                            trackName: "BoldAsLove",
                            rating:5))
        songs.append(Song(name: "Free Falling",
                            artistName: "John Mayer",
                            albumName: "'Where the Light Is' live in LA'",
                            imageName: "cover1",
                            trackName: "FreeFallin",
                            rating:5))
        songs.append(Song(name: "Good Love Is On The Way",
                                   artistName: "John Mayer",
                                   albumName: "'Where the Light Is' live in LA'",
                                   imageName: "cover1",
                                   trackName: "Good Love Is On The Way",
                                   rating:5))
        songs.append(Song(name: "Cornelia Street",
                                artistName: "Tayor Swift",
                                albumName: "'City of Lover’ Paris'",
                                imageName: "cover4",
                                trackName: "CorneliaStreetAudio",
                                rating:5))
        
    
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "MusicTableViewCell", for: indexPath) as! MusicTableViewCell
       
        cell.songImageView.image=UIImage(named: songs[indexPath.row].imageName)
        cell.singer.text=songs[indexPath.row].artistName
        cell.songName.text=songs[indexPath.row].name
        cell.musicAlbum.text=songs[indexPath.row].albumName
        cell.songRank.text="\(songs[indexPath.row].rating)"
        print(songs[indexPath.row].rating)
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //present the player
        let position=indexPath.row
    
        
        guard let vc = storyboard?.instantiateViewController(identifier: "player") as? PlayerViewController  else{
            
            return
        }
        vc.position=position
    
        vc.songs=songs
        
        present(vc, animated: true, completion: nil)
       
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
