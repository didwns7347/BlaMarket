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
enum ProfileAction{
    case Album
    case delete
    case cancel
}

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
    
    private lazy var indicator : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        
        indicator.hidesWhenStopped = true
        indicator.stopAnimating()
        return indicator
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
            .asDriver(onErrorJustReturn: ProfileModel(profileImageURL: nil, name: nil, profileImage: nil))
            .drive(onNext:{model in
                self.profileImageView.kf.setImage(with: URL(string: model.profileImageURL ?? "") , placeholder: UIImage(systemName: "person.fill")) { [weak self] result in
                    switch result{
                    case .success(let image):
                        self?.selectedImage.onNext(image.image as UIImage)
                    case .failure(let error):
                        print(error)
                    }
                    
                }
                self.nameTextFeild.text = model.name ?? ""
                
            }).disposed(by: bag)
        
        profileImageView.rx.tapGesture()
            .when(.recognized)
            .map{_ in
                [
                    UIAlertAction(title: "앨범에서 선택",
                                  style: .default,
                                  handler: { _ in vm.selectedProfileAction.onNext(.Album)}),
                    
                    UIAlertAction(title: "프로파일 사진 삭제",
                                  style: .destructive,
                                  handler: { _ in vm.selectedProfileAction.onNext(.delete)}),
                    
                    UIAlertAction(title: "취소", style: .cancel)
                ]
            }
            .asDriver(onErrorJustReturn: [UIAlertAction(title: "취소", style: .cancel)])
            .drive(self.rx.actionSheetAlert)
            .disposed(by: bag)
        
        vm.albumSelected
            .subscribe(onNext:{_ in
                self.present(self.imagePicker, animated: true)
            }).disposed(by: bag)
   
        
        selectedImage
            .asDriver(onErrorJustReturn: UIImage(systemName: "person.fill"))
            .map{
                $0 ?? UIImage(systemName: "pserson.fill")
            }
            .drive(self.profileImageView.rx.image)
            .disposed(by: bag)
        
        submitButton.rx.tap
            .withLatestFrom(
                Observable.combineLatest(selectedImage, nameTextFeild.rx.text).debug()
            )
            .map{ model in
                ProfileModel(profileImageURL: nil, name: model.1, profileImage: model.0)
            }.bind(to: vm.profileSubmitted)
            .disposed(by: bag)
        
        vm.lodingControl.bind(to: self.indicator.rx.isAnimating).disposed(by: bag)
        
        vm.profileEditFinished
            .map{_ in false}
            .bind(to: self.indicator.rx.isAnimating)
            .disposed(by: bag)
        
        vm.showAelrt.bind(to: self.rx.setAlert)
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
        [profileImageView,nameLabel,nameTextFeild,indicator].forEach { sv in
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
        indicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
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
