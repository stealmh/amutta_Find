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
    let name: String //목적지의 이름
    let frontLat: String //목적지의 위도
    let frontLon: String // 목적지의 경도

}
