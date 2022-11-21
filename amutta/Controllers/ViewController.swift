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
    
    
    
    //CoreLocation
    var locationManager = CLLocationManager()
    var myLocationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.255776, longitude: 127.106359)
    //

    //TMAP
    @IBOutlet weak var mapContainerView: UIView!
    var mapView = TMapView()
    let apiKey: String = "l7xx9e936404d40843cd936cffd31172b0ef"
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(destination)
        print(getLat)
        print(getLon)
        postBodyJsonRequest()
        setTMap()
        setMyLocation()
    }

    @IBAction func testTapped(_ sender: UIButton) {
        
        
        setZoom()
        
    }
    func setTMap() {
        self.mapView = TMapView(frame: mapContainerView.frame)
        self.mapView.delegate = self
        self.mapView.setApiKey(apiKey)
        
        mapContainerView.addSubview(self.mapView)
    }
    
    func setMyLocation() {
        //대리자 설정
        locationManager.delegate = self
        //거리 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //위치 사용 허용 알림
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            print("[Fail] 위치 서비스 off 상태")
        }
    }
    
    func setZoom() {
        self.mapView.setCenter(myLocationCoordinate)
        self.mapView.setZoom(15)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("위치 업데이트!")
            print("위도 : \(location.coordinate.latitude)")
            print("경도 : \(location.coordinate.longitude)")
            myLocationCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("[Fail] 위치 가져오기 실패")
    }
    
    
    
    
    
    
    
    
    

    func postBodyJsonRequest(){

            // [http 요청 주소 지정]
            let url = "https://apis.openapi.sk.com/tmap/routes/pedestrian?version=1&callback=function"
            
            
            // [http 요청 헤더 지정]
            let header : HTTPHeaders = [
                "accept": "application/json",
                "Content-Type" : "application/json",
                "appKey": "l7xx846db5f3bc1e48d29b7275a745d501c8"
                
            ]
            
            
            // [http 요청 파라미터 지정 실시]
            let bodyData : Parameters = [
                  "startX": 126.92365493654832,
                  "startY": 37.556770374096615,
//                  "angle": 20,
//                  "speed": 30,
//                  "endPoiId": "10001",
                  "endX": 126.92432158129688,
                  "endY": 37.55279861528311,
                  "passList": "126.92774822,37.55395475_126.92577620,37.55337145",
                  "reqCoordType": "WGS84GEO",
                  "startName": "%EC%B6%9C%EB%B0%9C",
                  "endName": "%EB%8F%84%EC%B0%A9",
                  "searchOption": "0",
                  "resCoordType": "WGS84GEO",
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
                switch response.result {
                case .success(let res):
                    do {
                        
                        print("")
                        print("====================================")
//                        print("[\(self.ACTIVITY_NAME) >> postBodyJsonRequest() :: Post Body Json 방식 http 응답 확인]")
                        print("-------------------------------")
                        print("응답 코드 :: ", response.response?.statusCode ?? 0)
                        print("-------------------------------")
                        print("응답 데이터 :: ", String(data: res, encoding: .utf8) ?? "")
                        print("====================================")
                        print("")
                        
                        // [비동기 작업 수행]
                        DispatchQueue.main.async {
                            
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
