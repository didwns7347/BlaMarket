//
//  PostCell.swift
//  Blamarket
//
//  Created by yangjs on 2022/09/15.
//


import UIKit
import SnapKit

class PostCell : UITableViewCell{
    let thumbnail = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let usingPeriod = UILabel()
    let postedDate = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
private extension PostCell{
    func attribute(){
        backgroundColor = .systemBackground
        titleLabel.font = .systemFont(ofSize: 11, weight: .bold)
        titleLabel.textColor = .label
        
        descriptionLabel.font = .systemFont(ofSize: 8)
        descriptionLabel.textColor = .secondaryLabel
        
        usingPeriod.font = .systemFont(ofSize: 8)
        usingPeriod.textColor = .secondaryLabel
        
        postedDate.font = .systemFont(ofSize: 10)
        postedDate.textColor = .secondaryLabel
    }
    
    func layout(){
        [thumbnail, titleLabel, descriptionLabel, usingPeriod, postedDate]
            .forEach{
                self.contentView.addSubview($0)
            }
        thumbnail.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.leading.top.bottom.equalToSuperview().inset(20)
            make.width.equalTo(80)
            make.height.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints{
            $0.leading.equalTo(thumbnail.snp.trailing).inset(10)
        }
    }
}
