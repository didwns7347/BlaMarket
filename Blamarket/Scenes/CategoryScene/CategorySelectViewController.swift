//
//  CategorySelectViewController.swift
//  Blamarket
//
//  Created by yangjs on 2022/10/21.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class CategorySelectViewController: UIViewController{
    let bag = DisposeBag()
    
    let collectionView : UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        
        return collectionView
    }()
    
    let copyRightlabel : UILabel = {
        let label = UILabel()
        label.text = "icons created by photo3idea_studio, amonrat rungreangfangsai, Freepik"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .center
        return label
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(vm:CategorySelectViewModel){
        vm.categoryObservalbe
            .drive(collectionView.rx.items(cellIdentifier: "categoryCell", cellType: CategoryCollectionViewCell.self))
        {row,element,cell in
            cell.configCell(categoray: element)
        }.disposed(by: bag)
        
        collectionView.rx.setDelegate(self).disposed(by: bag)
        
        collectionView.rx.modelSelected(Category.self).subscribe(onNext:{category in
            print(category.name)
            let vm = FilterPostsviewModel(category: category, keyword: nil, selectedType: .category)
            let vc = FilterPostsViewController()
            vc.bind(vm: vm)
            self.show(vc, sender: nil)
        }).disposed(by: bag)
    }
}

private extension CategorySelectViewController{
    func attribute(){
        self.title = "???????????? ??????"
        let nibName = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "categoryCell")
        [collectionView,copyRightlabel].forEach{view.addSubview($0)}
    }
    
    func layout(){
        copyRightlabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(20)
        })
        collectionView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.bottom.equalTo(copyRightlabel.snp.top)
        }
    }
}

extension CategorySelectViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 4 - 30 ///  3???????????? ??????, ??? ????????? 1????????? 1??? ??????
        print("collectionView width=\(collectionView.frame.width)")
        print("cell????????? width=\(width)")
        print("root view width = \(self.view.frame.width)")
        
        let size = CGSize(width: width, height: width)
        return size
    }
}
//   ??????: https://huniroom.tistory.com/entry/RxSwift-RxCocoa-UICollectionView [Tunko Development Diary:????????????]
