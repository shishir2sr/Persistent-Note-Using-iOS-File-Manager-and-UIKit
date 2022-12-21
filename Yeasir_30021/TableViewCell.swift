//
//  TableViewCell.swift
//  Yeasir_30021
//
//  Created by bjit on 21/12/22.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var noteDescription: UILabel!
    
    @IBOutlet weak var noteTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
