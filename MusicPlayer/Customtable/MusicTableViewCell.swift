//
//  TableViewCell.swift
//  MusicPlayer
//
//  Created by guowei on 2020/8/4.
//  Copyright © 2020 guowei. All rights reserved.
//

import UIKit

class MusicTableViewCell: UITableViewCell {

    @IBOutlet weak var songImageView: UIImageView!
    
    @IBOutlet weak var songName: UILabel!
    
    @IBOutlet weak var musicAlbum: UILabel!
    
    @IBOutlet weak var songRank: UILabel!
    
    @IBOutlet weak var singer: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
