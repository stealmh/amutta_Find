//
//  Constants.swift
//  amutta
//
//  Created by kimminho on 2022/11/10.
//


import Foundation
// MARK: Name Space

// 사용하게될 Cell 문자열 묶음
public struct Cell {
    static let musicCellIdentifier = "MusicCell"
    static let musicCollectionViewCellIdentifier = "CollectionViewCell"
    private init() {}
}

// 컬렉션뷰 구성을 위한 설정
public struct CVCell {
    static let spacingWitdh: CGFloat = 1
    static let cellColumns: CGFloat = 3
    private init() {}
}
