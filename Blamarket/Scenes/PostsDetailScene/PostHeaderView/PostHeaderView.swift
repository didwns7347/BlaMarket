//
//  PostHeaderView.swift
//  Blamarket
//
//  Created by yangjs on 2022/11/08.
//


import UIKit
class PostHeaderView: UIView{
    @IBOutlet weak var titleLbael: UILabel!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var viewCount: UILabel!
    @IBOutlet weak var writerName: UILabel!
    @IBOutlet var contentView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: PostHeaderView.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.secondaryLabel.cgColor
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func configView(postModel:PostDetailEntity){
        self.titleLbael.text = postModel.title
        let starImage = postModel.wish ? "star.fill":"star"
        self.starButton.setImage(UIImage(systemName: starImage), for: .normal)
        self.writerName.text = "\(postModel.email) | \(postModel.date)"
        self.viewCount.text = "\(postModel.viewCount) views"
    }
}
