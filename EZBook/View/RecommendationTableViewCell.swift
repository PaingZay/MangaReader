//
//  RecommendationTableViewCell.swift
//  EZBook
//
//  Created by Paing Zay on 3/12/23.
//

import UIKit

class RecommendationTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
