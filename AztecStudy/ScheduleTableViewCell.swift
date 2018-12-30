//
//  ScheduleTableViewCell.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 12/14/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import UIKit

/* Schedule Table Cell Controller
 *
 * Handles the Custom Table Cell for the Schedule Page
 */
class ScheduleTableViewCell: UITableViewCell {

    //MARK: Properties
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var classTitleLabel: UILabel!
    @IBOutlet weak var classIdLabel: UILabel!
    
    //MARK: Initial Load
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
