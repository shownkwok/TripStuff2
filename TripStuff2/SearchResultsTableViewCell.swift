//
//  SearchResultsTableViewCell.swift
//  TripStuff2
//
//  Created by SHAWN on 9/22/15.
//  Copyright © 2015 SHAWN. All rights reserved.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var country: UILabel!
    
    @IBOutlet weak var place: UILabel!

}
