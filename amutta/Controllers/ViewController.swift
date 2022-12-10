//
//  ViewController.swift
//  amutta
//
//  Created by kimminho on 2022/11/08.
//

import UIKit
import TMapSDK
import CoreLocation //사용자로부터 현재위치 받기 위함
import Alamofire



class ViewController: UIViewController,TMapViewDelegate,CLLocationManagerDelegate {
    
    //서치바에서 넘어온 목적지,경도,위도 변수
    var destination: String?
    var getLat: String?
    var getLon: String?
    var turnCount: Int = 1
    
    var locationCount = 0
    
    @IBOutlet weak var turnByturnLabel: UILabel!
    //LoadArray를 만들어 일단 라인 그려보기 체크
    
    //type: LineString
    var loadArray: [[Double]] = []
    //type: Point
    var loadArrayPoint: [[Double]] = []
    
    var testArray: [Double] = []
    
    var stepCounter = 0
    
    //marker
    var markers:Array<TMapMarker> = []
    var polylines:Array<TMapPolyline> = []
    
    //circle
    var circles:Array<TMapCircle> = []
    
    //CoreLocation
    var locationManager = CLLocationManager()
    var myLocationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.255776, longitude: 127.106359)
    //
    var destinationCoordiante: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.255776, longitude: 127.106359)
    
    //안내문구를 담아놓은 배열
    var turnByturn: [[String]] = []

    //TMAP
    @IBOutlet weak var mapContainerView: UIView!
    var mapView = TMapView()
    let apiKey: String = "l7xx8749f7a7b24c491682f94ec946029847"
    
    override func viewDidLoad() {
        print(#function)
        super.viewDidLoad()
//        print(destination)
//        print(getLat)
//        print(getLon)
        destinationCoordiante = CLLocationCoordinate2D(latitude: CLLocationDegrees(getLat!)!, longitude: CLLocationDegrees(getLon!)!)
        setTMap()
        setMyLocation()
//        postBodyJsonRequest()
    }

    @IBAction func testTapped(_ sender: UIButton) {
        print(#function)
        //사용자의 현재위치로 이동
        setZoom()
        //사용자의 현재위치에 마커를 찍는다
//        setMark(myLocationCoordinate)
        //사용자의 목적지에 마커를 찍는다
//        setMark(destinationCoordiante)
        postBodyJsonRequest()
    }
 
    func setTMap() {
        print(#function)
        self.mapView = TMapView(frame: mapContainerView.frame)
        self.mapView.delegate = self
        self.mapView.setApiKey(apiKey)
        
        mapContainerView.addSubview(self.mapView)
    }
    
    func setMyLocation() {
        print(#function)
        //대리자 설정
        locationManager.delegate = self
        //거리 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //위치 사용 허용 알림
        locationManager.requestWhenInUseAuthorization()
        Task {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            } else {
                print("[Fail] 위치 서비스 off 상태")
            }
        }

    }
    // MARK: 현재위치로 이동-
    func setZoom() {
        print(#function)
        self.mapView.setCenter(myLocationCoordinate)
        self.mapView.setZoom(15)
    }
    // MARK: 마커 만들기-
    func setMark(_ input: CLLocationCoordinate2D) {
//        print(#function)
        let marker = TMapMarker(position: input)
        marker.title = "제목없음"
        marker.subTitle = "내용없음"
        marker.draggable = true
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 50))
        label.text = "좌측"
        marker.leftCalloutView = label
        let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 50))
        label2.text = "우측"
        marker.rightCalloutView = label2
        
        marker.map = self.mapView
//        print(markers.count)
        self.markers.append(marker)
    }
    
    public func objFunc11(_ input: CLLocationCoordinate2D) {
        let position = CLLocationCoordinate2D(latitude: input.latitude, longitude: input.longitude)
        let circle = TMapCircle(position: position, radius: 10)
            circle.fillColor = .cyan
            circle.strokeColor = .red
            circle.opacity = 0.5
            circle.map = self.mapView
            self.circles.append(circle)
    }
    
    
    //MARK: 라인 추가
    func makeMapLineToLineString() {
        print(#function)
        let position = self.mapView.getCenter()
        
        var path: [CLLocationCoordinate2D] = []
        for i in loadArray {
            path.append(CLLocationCoordinate2D(latitude: i[1], longitude: i[0]))
        }

        let polyline = TMapPolyline(coordinates: path)
        polyline.strokeWidth = 4
        polyline.strokeColor = .red
        polyline.map = self.mapView
        self.polylines.append(polyline)
        
    }
    func makeMapLineToPoint() {
        print(#function)
        let position = self.mapView.getCenter()
        
        var path: [CLLocationCoordinate2D] = []
        for i in loadArrayPoint {
            path.append(CLLocationCoordinate2D(latitude: i[1], longitude: i[0]))
        }

        let polyline = TMapPolyline(coordinates: path)
        polyline.strokeWidth = 4
        polyline.strokeColor = .red
        polyline.map = self.mapView
        self.polylines.append(polyline)
    }
    
    
    
    
    //MARK: 현재위치 최신화
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        if let location = locations.first {
//            print("위치 업데이트!")
//            print("위도 : \(location.coordinate.latitude)")
//            print("경도 : \(location.coordinate.longitude)")
            myLocationCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
        //1.원의 반지름
        //2.다음 마커까지의 path길이
        // 길이보다 반지름이 길어지는 순간은 -> 원에 진입했다는 뜻
        

        if loadArrayPoint.count > 2 {
            
            let coordinate = CLLocationCoordinate2D(latitude: loadArrayPoint[locationCount][1], longitude: loadArrayPoint[locationCount][0])
            let from = CLLocationCoordinate2D(latitude: loadArrayPoint[locationCount][1], longitude: loadArrayPoint[locationCount][0])
            let distance = coordinate.distance(from: from)
            if distance <= 10 {
                locationCount += 1
                turnCount += 1
                print(distance)
                DispatchQueue.main.async {
                    self.turnByturnLabel.text = self.turnByturn[self.turnCount][0]
                }
            }
        }
//        loadArrayPoint.removeFirst()
//            let coordinate = CLLocationCoordinate2D(latitude: polylines[i].path[i].latitude, longitude: polylines[i].path[i].latitude)
//            let from = CLLocationCoordinate2D(latitude: polylines[i].path[i+1].latitude, longitude: polylines[i+1].path[i+1].latitude)
//            let distance = coordinate.distance(from: from)
 
    }

    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
        print("[Fail] 위치 가져오기 실패")
    }

    
    
    //MARK: Alamofire
    func postBodyJsonRequest(){
        print(#function)
        // [http 요청 주소 지정]
        let url = "https://apis.openapi.sk.com/tmap/routes/pedestrian?version=1&callback=function"
            
            
        // [http 요청 헤더 지정]
        let header : HTTPHeaders = [
            "accept": "application/json",
            "Content-Type" : "application/json",
            "appKey": "l7xx8749f7a7b24c491682f94ec946029847"
                
            ]
          
//        print(myLocationCoordinate.latitude)
//        print(myLocationCoordinate.longitude)
            // [http 요청 파라미터 지정 실시]
            let bodyData : Parameters = [
                "startX": myLocationCoordinate.longitude,
                "startY": myLocationCoordinate.latitude,
//                  "angle": 20,
//                  "speed": 30,
//                  "endPoiId": "10001",
                  "endX": Double(getLon!)!,
                  "endY": Double(getLat!)!,
//                  "reqCoordType": "WGS84GEO", 기본값이라 일단 주석
                  "startName": "%EC%88%98%EC%9B%90%EC%97%AD",
                  "endName": "%EB%A7%9D%ED%8F%AC%EC%97%AD",
                  "searchOption": "0",
//                  "resCoordType": "WGS84GEO", 기본값이라 일단 주석
                  "sort": "index"
            ]
            
            AF.request(
                url, // [주소]
                method: .post, // [전송 타입]
                parameters: bodyData, // [전송 데이터]
                encoding: JSONEncoding.default, // [인코딩 스타일]
                headers: header // [헤더 지정]
            )
            .validate(statusCode: 200..<300)
            .responseData { response in
                var routines: Welcome
                switch response.result {
                case .success(let res):
                    do {
                        
//                        print("")
//                        print("====================================")
//                        print("[\(self.ACTIVITY_NAME) >> postBodyJsonRequest() :: Post Body Json 방식 http 응답 확인]")
//                        print("-------------------------------")
//                        print("응답 코드 :: ", response.response?.statusCode ?? 0)
//                        print("-------------------------------")
//                        print("응답 데이터 :: ", String(data: res, encoding: .utf8) ?? "")
//                        print("====================================")
//                        print("")

                    
                        routines = try JSONDecoder().decode(Welcome.self, from: res)
//                        print(routines.features[0].geometry.coordinates)
//                        if case .double(let cord) = routines.features[0].geometry.coordinates[0] {
//                            print("answer: \(cord)")
//                        }


                        
                        // [비동기 작업 수행]
                        DispatchQueue.global().async {
                            for i in routines.features {
                                
                                //type이 LineString일때
                                if i.geometry.type.rawValue == "LineString" {
                                    for j in i.geometry.coordinates {
                                        if case .doubleArray(let array) = j{
//                                            print(array) // 찍히는것 확인
                                            self.loadArray.append(array)
                                    }

                                    }
                                }
                                //type이 Point일때
                                else {
                                    //안내문구를 담아줌/ turnType은 값이 없는 경우도 JSON에 있기에 없다면 0 넣어주었음
                                    self.turnByturn.append([i.properties.propertiesDescription,String(i.properties.turnType ?? 0)])
                                    DispatchQueue.main.async {
                                        self.turnByturnLabel.text = self.turnByturn[0][0]
                                    }
                                    for j in i.geometry.coordinates {
                                        if self.testArray.count == 2 {
                                            self.loadArrayPoint.append(self.testArray)
                                            self.testArray = []
                                        }
                                        if case .double(let array) = j {
                                            self.testArray.append(array)
                                        }
                                        
                                    }

                                }
                            }
                            print("loadArrayPointCount :",self.loadArrayPoint.count)
                            print("turnByTurnCount: ",self.turnByturn.count)
                            print(self.loadArrayPoint)
                            print(self.turnByturn)
//                            self.makeMapLineToLineString()
                            self.makeMapLineToPoint()
                        }
                        DispatchQueue.main.async {
                            for i in self.loadArrayPoint {
                                self.setMark(CLLocationCoordinate2D(latitude: i[1], longitude: i[0]))
                                self.objFunc11(CLLocationCoordinate2D(latitude: i[1], longitude: i[0]))
                            }
                        }
                        
                    }
                    catch (let err){
                        print("catch :: ", err.localizedDescription)
                    }
                    break
                case .failure(let err):
                    print("응답 코드 :: ", response.response?.statusCode ?? 0)
                    print("에 러 :: ", err.localizedDescription)
                    break
                }
            }
        }
    
}

extension CLLocationCoordinate2D {
    /// Returns distance from coordianate in meters.
    /// - Parameter from: coordinate which will be used as end point.
    /// - Returns: Returns distance in meters.
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: self.latitude, longitude: self.longitude)
        return from.distance(from: to)
    }
}
