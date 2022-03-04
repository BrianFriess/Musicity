//
//  collectionViewManager.swift
//  musicity
//
//  Created by Brian Friess on 04/03/2022.
//

import Foundation

enum CollectionViewManager {
    case styleTagCell
    case instrumentTagCell
    case cellTileCollectionView
    case tagCollectionResultCell
    case tagCollectionCell
    case messengerCell
    case cellTchat
    
    var returnCellString : String {
        switch self {
        case .styleTagCell:
            return "styleTagCell"
        case .instrumentTagCell:
            return "instrumentTagCell"
        case .cellTileCollectionView:
            return "cellTileCollectionView"
        case .tagCollectionResultCell:
            return "tagCollectionResultCell"
        case .tagCollectionCell:
            return "tagCollectionCell"
        case .messengerCell:
            return "messengerCell"
        case .cellTchat:
            return "cellTchat"
        }
    }
    
}
