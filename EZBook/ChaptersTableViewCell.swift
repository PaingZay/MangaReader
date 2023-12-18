//
//  ChaptersTableViewCell.swift
//  EZBook
//
//  Created by Paing Zay on 26/11/23.
//

import UIKit

class ChaptersTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var chapter: UILabel!
    @IBOutlet weak var mangaTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
