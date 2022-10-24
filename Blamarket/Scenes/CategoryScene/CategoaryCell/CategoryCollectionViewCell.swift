//
//  CategoryCollectionViewCell.swift
//  Blamarket
//
//  Created by yangjs on 2022/10/24.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTtitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(categoray:Category){
        self.cellImage.image = UIImage(named: categoray.iconURL!)
        self.cellTtitle.text = categoray.name
    }

}
