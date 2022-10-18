//
//  PostEndPoint.swift
//  Blamarket
//
//  Created by yangjs on 2022/09/27.
//

import Foundation
import UIKit
import RxSwift
import RxAlamofire
import Alamofire
struct PostEndPoint{
    static let boundary = "Boundary-\(UUID().uuidString)"
    static func post(postModel:PostModel,images:[UIImage])->Endpoint<CommonResultData>{
      
        let parameters = ["title":postModel.title,
                          "category":postModel.category,
                          "price":postModel.price,
                          "contents":postModel.contents ?? "빈 내용",
                          "email":UserDefaults.standard.string(forKey: "email") ?? "didwns7347@naver.com"
                        ]
        let body = createBody(parameters: parameters as [String : Any], images: images, boundary: PostEndPoint.boundary)
        return Endpoint(baseURL: UserConst.USER_SERVER_URL,
                        path: "/post/write",
                        method: .post,
                        queryParameters: nil,
                        bodyParameters: body,
                        headers: ["Content-Type":"multipart/form-data; boundary\(PostEndPoint.boundary)"
                                  ],
                        sampleData: nil
        )
        
    }
    //멀티파트 바디 리턴
    static func createBody(parameters: [String:Any], images:[UIImage],boundary:String)->Data{
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.append(boundaryPrefix.data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        var count = 1
        for image in images {
            body.append(boundaryPrefix.data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"images\(count)\"; filename=\"images\(count)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            body.append(image.pngData() ?? Data())
            body.append("\r\n".data(using: .utf8)!)
            count += 1
        }
        

        body.append(boundaryPrefix.data(using: .utf8)!)
        
        return body
    }
    
    
}

