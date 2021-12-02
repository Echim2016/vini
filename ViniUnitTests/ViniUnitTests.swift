//
//  ViniUnitTests.swift
//  ViniUnitTests
//
//  Created by Yi-Chin Hsu on 2021/11/25.
//

import XCTest
@testable import vini

class ViniUnitTests: XCTestCase {
    
    var sut: MapScrollView!

    override func setUpWithError() throws {
        
        try super.setUpWithError()
        sut = MapScrollView()

    }

    override func tearDownWithError() throws {
        
        sut = nil
        try super.tearDownWithError()
    }
    
    func testMapScrollViewConfiguration() throws {
        
        sut = MapScrollView()
        
        XCTAssertEqual(sut.scrollView.backgroundColor, .clear)
        XCTAssertFalse(sut.scrollView.bounces)
        XCTAssertFalse(sut.scrollView.isPagingEnabled)
        XCTAssertFalse(sut.scrollView.showsHorizontalScrollIndicator)
        XCTAssertFalse(sut.scrollView.showsVerticalScrollIndicator)
        XCTAssertNotNil(sut.scrollView.delegate)
        XCTAssertIdentical(sut.scrollView.delegate, sut)
    }
    
    func testSpawnViniRandomly() {

        // 1. given
        let vinis: [ViniView] = [
            ViniView(frame: CGRect(x: 0, y: 0, width: 80, height: 100)),
            ViniView(frame: CGRect(x: 0, y: 0, width: 80, height: 100))
        ]
        
        let map = sut.mapStackView.arrangedSubviews[0]
        map.frame = CGRect(x: 0, y: 0, width: 390, height: 844)
        
        // 2. when
        map.spawnViniRandomly(vinis: vinis)

        // 3. then
        // check whether two vinis are intersected
        var isIntersects = false
        for index in 0..<vinis.count - 1 {
            
            if map.subviews[index].frame.intersects(map.subviews[index + 1].frame) {
                isIntersects = true
            }
        }
        
        // the number of vinis in subviews should equal to the length of input vini array
        XCTAssertEqual(map.subviews.count, vinis.count)
        
        // pass the test if all vinis are not intersected
        XCTAssertFalse(isIntersects)
    }

}
