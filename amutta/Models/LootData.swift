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
