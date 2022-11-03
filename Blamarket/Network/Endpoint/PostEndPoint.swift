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
    #if DEBUG
    static let authorization = "Bearer eyJraWQiOiJrZXkxIiwiYWxnIjoiSFM1MTIifQ.eyJzdWIiOiJ0ZXN0MUBuYXZlci5jb20iLCJpYXQiOjE2NjcxMzI2OTEsImV4cCI6MTY2NzczMjY5MX0.VVkiqFZvOHanCKFngUNtnBNr9EkIm4mKcMBXiIwn0qZZT4rXgjXXMVuOdoCrK2BzV5Rz_bR0ZhYHHeMd-pmthA"
    static let authKey = "JWT-AUTHENTICATION"
    #endif
    
    static func getPosts(category: Category? = nil, keyword:String? = nil, page:Int)->Endpoint<PostNetworkEntity<[PostEntity]>>{
        let companyId = UserDefaults.standard.string(forKey: UserConst.Company) ?? ""
        let query = PostsRequestBody(category: category?.name ?? "", search: keyword ?? "", page: page)
        var param = [String:String]()
//        if category != nil{
//            param["category"] = category?.name
//        }
//        if keyword != nil {
//            param["keyword"] = keyword
//        }
//        param["page"] = page
        
        return Endpoint(baseURL:PostConst.POST_SERVER_URL,
                        path:"/post/view",
                        method: .get,
                        queryParameters: [ "page":"\(query.page)", "companyId":"1"],
                        bodyParameters: nil,
                        headers: ["JWT-AUTHENTICATION":authorization],
                        sampleData: nil
                        )
        
    }
    
    static func postDetail(param:PostDetailParameter)->Endpoint<PostNetworkEntity<PostDetailEntity>>{
        return Endpoint(baseURL: PostConst.POST_SERVER_URL,
                        method: .get,
                        queryParameters: param,
                        bodyParameters: nil,
                        headers: ["JWT-AUTHENTICATION":authorization],
                        sampleData: nil)
    }
    static func post(postModel:PostModel,images:[UIImage])->Endpoint<CommonResultData>{
      
        let parameters = ["title":postModel.title,
                          "category":postModel.category,
                          "price":postModel.price,
                          "contents":postModel.contents ?? "빈 내용",
                          "email":UserDefaults.standard.string(forKey: "email") ?? "didwns7347@naver.com",
                          "companyId":"1"
                        ]
        let body = createBody(parameters: parameters as [String : Any], images: images, boundary: PostEndPoint.boundary)
        return Endpoint(baseURL: PostConst.POST_SERVER_URL,
                        path: "/post/write",
                        method: .post,
                        queryParameters: nil,
                        bodyParameters: body,
                        headers: ["Content-Type":"multipart/form-data; boundary=\(PostEndPoint.boundary)",
                                  authKey:authorization
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
        print(String(data: body, encoding: .utf8) ?? "NO DATA")
        return body
    }
    

    
}

