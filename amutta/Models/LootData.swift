//
//  LootData.swift
//  amutta
//
//  Created by kimminho on 2022/11/13.
//

import Foundation

// MARK: - Welcome
struct Welcome {
    let type: String
    let features: [Feature]
}

// MARK: - Feature
struct Feature {
    let geometry: Geometry
    let properties: Properties
}

// MARK: - Geometry
struct Geometry {
    let type: GeometryType
    let coordinates: [Coordinate]
}

enum Coordinate { // 현재의 경도 위도
    case double(Double)
    case doubleArray([Double])
}

enum GeometryType {
    case lineString
    case point
}

// MARK: - Properties
struct Properties {
    let totalDistance: Int? //총 거리
    let totalTime: Int? //총 걸리는 시간
    let index: Int // 경로 순번
    let pointIndex: Int? // 안내점 노드의 순번
    let name: String // 안내지점의 명칭
    let propertiesDescription: String
    let direction, nearPoiName, nearPoiX, nearPoiY: String?
    let facilityType, facilityName: String
    let turnType: Int?
    let pointType: String?
    let lineIndex, distance, time, roadType: Int?
    let categoryRoadType: Int?
}

