//
//  Data.swift
//  amutta
//
//  Created by kimminho on 2022/11/08.
//

import Foundation

// MARK: - Welcome
struct DataHere: Codable {
    let searchPoiInfo: SearchPoiInfo
}

// MARK: - SearchPoiInfo
struct SearchPoiInfo: Codable {
    let pois: Pois
}

// MARK: - Pois
struct Pois: Codable {
    let poi: [Poi]
}

// MARK: - Poi
struct Poi: Codable {
    let name: String

}
