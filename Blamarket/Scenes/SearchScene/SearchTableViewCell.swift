//
//  SearchTableViewCell.swift
//  Blamarket
//
//  Created by yangjs on 2022/10/27.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!

    var didDelete : ()->() = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        print(self.keywordLabel.text)
        self.didDelete()
    }
    
    func configCell(model : SearchRecode){
        self.keywordLabel.text = model.keyword ?? "???????????"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
