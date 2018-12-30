//
//  AssignmentTableViewCell.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 12/16/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import UIKit

/* Assignement Table Cell Controller
 *
 * Handles the Custom Table Cell for the Assignment Page
 */
class AssignmentTableViewCell: UITableViewCell {

    //MARK: Outlets
    
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    //MARK: Initial Load
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
