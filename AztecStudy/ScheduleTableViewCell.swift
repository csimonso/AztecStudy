//
//  ScheduleTableViewCell.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 12/14/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var classTitleLabel: UILabel!
    @IBOutlet weak var classIdLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
