////
////  LootData.swift
////  amutta
////
////  Created by kimminho on 2022/11/13.
////
//
//import Foundation
//
//// MARK: - Welcome
//struct Welcome: Codable {
//    let type: String
//    let features: [Feature]
//}
//
//// MARK: - Feature
//struct Feature: Codable {
//    let type: String
//    let geometry: Geometry
//    let properties: Properties
//}
//
//// MARK: - Geometry
//struct Geometry: Codable {
//    let type: GeometryType
//    let coordinates: [Double]
//}
//
//
//enum GeometryType: Codable {
//    case lineString
//    case point
//}
//
//// MARK: - Properties
//struct Properties: Codable {
//    let totalDistance: Int? //총 거리
//    let totalTime: Int? //총 걸리는 시간
//    let index: Int // 경로 순번
//    let pointIndex: Int? // 안내점 노드의 순번
//    let name: String // 안내지점의 명칭
//    let description: String
//    let direction, nearPoiName, nearPoiX, nearPoiY: String
//    let facilityType, facilityName: String
//    let turnType: Int
//    let pointType: String
//
//    let lineIndex, distance, time, roadType: Int?
//    let categoryRoadType: Int?
//}
//


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation
import MapKit

// MARK: - Welcome
struct Welcome: Codable {
    let type: String
    let features: [Feature]
}

// MARK: - Feature
struct Feature: Codable {
    let type: FeatureType
    let geometry: Geometry
    let properties: Properties
}

// MARK: - Geometry
struct Geometry: Codable {
    let type: GeometryType
    let coordinates: [Coordinate]
}

enum Coordinate: Codable {
    case double(Double)
    case doubleArray([Double])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([Double].self) {
            self = .doubleArray(x)
            return
        }
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        throw DecodingError.typeMismatch(Coordinate.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Coordinate"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
             try container.encode(x)
        case .doubleArray(let x):
             try container.encode(x)
        }
    }
}

enum GeometryType: String, Codable {
    case lineString = "LineString"
    case point = "Point"
}

// MARK: - Properties
struct Properties: Codable {
    let totalDistance, totalTime: Int?
    let index: Int
    let pointIndex: Int?
    let name, propertiesDescription: String
    let direction, nearPoiName, nearPoiX, nearPoiY: String?
    let intersectionName: String?
    let facilityType, facilityName: String
    let turnType: Int?
    let pointType: PointType?
    let lineIndex, distance, time, roadType: Int?
    let categoryRoadType: Int?

    enum CodingKeys: String, CodingKey {
        case totalDistance, totalTime, index, pointIndex, name
        case propertiesDescription = "description"
        case direction, nearPoiName, nearPoiX, nearPoiY, intersectionName, facilityType, facilityName, turnType, pointType, lineIndex, distance, time, roadType, categoryRoadType
    }
}

enum PointType: String, Codable {
    case ep = "EP"
    case gp = "GP"
    case pp1 = "PP1"
    case pp2 = "PP2"
    case sp = "SP"
}

enum FeatureType: String, Codable {
    case feature = "Feature"
}
