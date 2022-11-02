//
//  ImageCollectionViewCell.swift
//  Blamarket
//
//  Created by yangjs on 2022/11/01.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configCell(image:UIImage){
        self.cellImage.image = image
    }
}
