//
//  MainTableViewCell.swift
//  Blamarket
//
//  Created by yangjs on 2022/10/17.
//

import UIKit
import Kingfisher

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var usingMonthLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(model:PostEntity , row:Int ){
        log.debug("row = \(row)")
        guard let imageURL = URL(string: model.thumbnail) else {
            log.debug("Thumnail URL Invalied")
            return
        }
        let image = UIImage(systemName: "questionmark")
        self.thumbnail.kf.setImage(with: imageURL, placeholder: image)
        self.titleLabel.text = model.title
        self.createdDateLabel.text = model.createDate
        self.usingMonthLabel.text = model.usedDate
        self.descriptionLabel.text = model.content
        
    }
    
}
