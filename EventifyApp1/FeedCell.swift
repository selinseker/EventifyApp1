//
//  FeedCell.swift
//  EventifyApp1
//
//  Created by Selin Şeker on 13.09.2024.
//

import UIKit

class FeedCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var etkinlikAdiField: UILabel!
    @IBOutlet weak var etkinlikTarihiField: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var YorumText: UILabel!
    @IBOutlet weak var locationField: UILabel!
    @IBOutlet weak var feedUsernameField: UILabel!
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var view: UIView!
}
