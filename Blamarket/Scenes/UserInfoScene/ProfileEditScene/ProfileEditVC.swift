//
//  ProfileEditVC.swift
//  Blamarket
//
//  Created by yangjs on 2022/12/13.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture
import Kingfisher
import PhotosUI
class ProfileEditVC : UIViewController{
  
    let bag = DisposeBag()
    let submitButton = UIBarButtonItem()
    let backButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: nil, action: nil)
    
    var selectedImage = BehaviorSubject<UIImage?>(value: nil)
    
    let profileImageView : UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.image = UIImage(systemName: "person.fill")
        view.layer.cornerRadius = view.frame.height/2
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        view.tintColor = .secondaryLabel
        view.clipsToBounds = true
        return view
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        return label
    }()
    
    let nameTextFeild : UITextField = {
        let textfeild = UITextField()
        textfeild.borderStyle = .roundedRect
        textfeild.layer.cornerRadius = 10
        return textfeild
    }()
    
    private lazy var imagePicker : PHPickerViewController = {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .any(of: [.livePhotos, .images])
        let pickerVC = PHPickerViewController(configuration: config)
        pickerVC.delegate = self
        return pickerVC
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        layout()
        attribute()
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(vm:ProfileEditVM){
        backButton.rx.tap
            .subscribe(onNext:{
                self.navigationController?.popViewController(animated: true)
                
            })
            .disposed(by: bag)
        
        vm.userInfo
            .asDriver(onErrorJustReturn: ProfileModel(profileImage: nil, name: nil))
            .drive(onNext:{model in
                self.profileImageView.kf.setImage(with: URL(string: model.profileImage ?? "") , placeholder: UIImage(systemName: "person.fill"))
                self.nameTextFeild.text = model.name ?? ""
            }).disposed(by: bag)
        
        profileImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext:{ _ in
                print("tapppppd1!")
                self.present(self.imagePicker, animated: true)
            }).disposed(by: bag)
        
        selectedImage
            .asDriver(onErrorJustReturn: UIImage(systemName: "person.fill"))
            .drive(onNext:{ img in
                self.profileImageView.image = img ?? UIImage(systemName: "pserson.fill")
            }).disposed(by: bag)
    }
    
}
private extension ProfileEditVC {
    func attribute(){
        view.backgroundColor = .systemBackground
 
        submitButton.title = "제출"
        submitButton.style = .done
        submitButton.tintColor = .label
        backButton.tintColor = .label
        navigationItem.setRightBarButton(submitButton, animated: true)
        navigationItem.setLeftBarButton(backButton, animated: true)
        navigationItem.hidesBackButton = true
        
    }
    func layout(){
        [profileImageView,nameLabel,nameTextFeild].forEach { sv in
            view.addSubview(sv)
        }
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.width.equalTo(100)
            make.centerX.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        nameTextFeild.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(nameLabel)
        }
    }
 
}
extension ProfileEditVC : UINavigationControllerDelegate,
                          PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        var provider :NSItemProvider? = results.first?.itemProvider
        provider?.loadObject(ofClass: UIImage.self, completionHandler: { img, error in
            if let loadImage = img as? UIImage{
                self.selectedImage.onNext(loadImage)
            }else{
                print(error?.localizedDescription ?? "이미지 로딩 에러")
            }
        })
    }
    
}
