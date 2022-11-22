//
//  BlamarketTests.swift
//  BlamarketTests
//
//  Created by yangjs on 2022/11/21.
//

import XCTest
@testable import Blamarket

final class BlamarketTests: XCTestCase {
    //테스트 코드 시작전 실행 (값을 세팅하는부분임)
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    //모든 테스트 코드가 실행된 후에 호출 (SetUP에서 설정한 값들을 해제할때 사용)
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    //테스트 코드를 작성하는 메인 코드 (삭제하고 세롭게 생성하여 사용가능)
    func testExample() throws {
        let vc = MainViewController()
        vc.bind(vm: MainViewModel())
        XCTAssertEqual(vc.title, "게시판")
    }
    //성능을 측정해 보기 위해 사용하는
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
