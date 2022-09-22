//
//  ItemImageCollecteionViewCell.swift
//  Blamarket
//
//  Created by yangjs on 2022/09/19.
//

import UIKit
import SnapKit

class ItemImageCollectionViewCell : UICollectionViewCell{
    static let id  = "ItemCell"
    private let defaultImage = UIImage(systemName: "questionmark")!
    private let imageView : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        img.tintColor = .secondaryLabel
        return img
    }()
    
    private let deleteBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "xmark.octagon"), for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //attribute()
        layout()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(provider:NSItemProvider?, row:Int){
        if row == 0{
            self.deleteBtn.isHidden = true
            self.imageView.image = UIImage(systemName: "camera")
            return
        }else{
            self.deleteBtn.isHidden = false

            if let provider{
                if provider.canLoadObject(ofClass: UIImage.self){
                    provider.loadObject(ofClass: UIImage.self, completionHandler: { img, error in
                        if let loadImage = img as? UIImage{
                            DispatchQueue.main.async {
                                self.imageView.image = loadImage
                            }
                        }else{
                            print(error?.localizedDescription ?? "이미지 로딩 에러")
                        }
                    })
                }
            }
         
        }
     
      
        
    }
    
    private func layout(){
        [imageView, deleteBtn].forEach{
            self.addSubview($0)
        }
        imageView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
                     
       
        }
        deleteBtn.snp.makeConstraints{
            $0.top.trailing.equalToSuperview()
            $0.width.height.equalTo(0)
        }
        
    }
    
}
