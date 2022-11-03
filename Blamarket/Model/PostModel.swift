//
//  PostModel.swift
//  Blamarket
//
//  Created by yangjs on 2022/09/28.
//

import UIKit
import RxSwift
import RxCocoa
class PostModel{
    let title:String
    let category:String
    let contents :String?
    let providers: [NSItemProvider]
    let price : String?
    let loadedImagesSubject = PublishSubject<[UIImage]>()
    
    init(title: String, category: String, contents: String?, imageProviders: [NSItemProvider], price: String?) {
        self.title = title
        self.category = category
        self.contents = contents
        self.providers = imageProviders
        self.price = price
        self.loadImages(providers:self.providers)
       
    }
    
    private func loadImages(providers : [NSItemProvider] ){
         print("LOAD IMAGES CALLED")
        var images = [UIImage]()
        for provider in providers {
            if provider.canLoadObject(ofClass: UIImage.self){
                provider.loadObject(ofClass: UIImage.self, completionHandler: { img, error in
                    if let loadImage = img as? UIImage{
                        images.append(self.resizeImage(image: loadImage))
                    }else{
                        images.append(UIImage())
                        print(error?.localizedDescription ?? "이미지 로딩 에러")
                    }
                    if images.count == providers.count{
                        self.loadedImagesSubject.onNext(images)
                    }
                })
            }
        }
    }
    
    private func resizeImage(image: UIImage) -> UIImage {
        let scale = 100 / image.size.width // 새 이미지 확대/축소 비율
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(100, 100))
        image.draw(in: CGRectMake(0, 0, 100, 100))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? image
    }
    
    
}


struct PostsRequestBody : Encodable{
    let category :String
    let search: String
    let page : Int
}
struct PostDetailParameter : Encodable{
    let email: String
    let itemId : Int
}
