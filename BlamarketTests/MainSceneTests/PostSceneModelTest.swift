//
//  PostSceneModelTest.swift
//  BlamarketTests
//
//  Created by yangjs on 2022/11/22.
//

import XCTest
import Nimble
import RxSwift
import RxTest
@testable import Blamarket
final class PostSceneModelTest: XCTestCase {
    let stubNetwork = PostNetworkStub()
    
    var posts : [PostEntity]!
    var vm : MainViewModel!
    let bag = DisposeBag()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.vm = MainViewModel()
        self.posts = postList
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let scheduler = TestScheduler(initialClock: 0)
        
        let dummyDataEvent = scheduler.createHotObservable([.next(0,postList)])
        
        let postData = PublishSubject<[PostEntity]>()
        dummyDataEvent.subscribe(postData).disposed(by: bag)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
