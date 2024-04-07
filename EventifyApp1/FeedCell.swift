//
//  FeedCell.swift
//  EventifyApp1
//
//  Created by Selin Şeker on 31.03.2024.
//

import UIKit

class FeedCell: UITableViewCell {

    
    @IBOutlet weak var feedUsernameField: UILabel!
    @IBOutlet weak var YorumText: UITextField!
    @IBOutlet weak var postImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
