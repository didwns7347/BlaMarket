//
//  SearchPostsViewController.swift
//  Blamarket
//
//  Created by yangjs on 2022/10/21.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
class SearchPostsViewController: UIViewController{
    let searchBar : UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 280, height: 0))
        searchBar.placeholder = "Search User"
        return searchBar
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
private extension SearchPostsViewController{
    func attribute(){

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
    }
    
    func layout(){
        
    }
}
