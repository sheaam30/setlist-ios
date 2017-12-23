//
//  SetListItemViewCell.swift
//  Set List
//
//  Created by Adam Shea on 12/11/17.
//  Copyright © 2017 Adam Shea. All rights reserved.
//

import UIKit

class SetListItemViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
