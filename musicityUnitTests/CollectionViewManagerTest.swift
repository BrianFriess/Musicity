//
//  CollectionViewManagerTest.swift
//  musicityUnitTests
//
//  Created by Brian Friess on 04/03/2022.
//

import XCTest
@testable import musicity

class CollectionViewManagerTest: XCTestCase {

    func testReturnCollectionViewString() {
        XCTAssertEqual(CollectionViewManager.styleTagCell.returnCellString, "styleTagCell")
        XCTAssertEqual(CollectionViewManager.instrumentTagCell.returnCellString, "instrumentTagCell")
        XCTAssertEqual(CollectionViewManager.cellTileCollectionView.returnCellString, "cellTileCollectionView")
        XCTAssertEqual(CollectionViewManager.tagCollectionResultCell.returnCellString, "tagCollectionResultCell")
        XCTAssertEqual(CollectionViewManager.tagCollectionCell.returnCellString, "tagCollectionCell")
        XCTAssertEqual(CollectionViewManager.messengerCell.returnCellString, "messengerCell")
        XCTAssertEqual(CollectionViewManager.cellTchat.returnCellString, "cellTchat")
    }
    
}
