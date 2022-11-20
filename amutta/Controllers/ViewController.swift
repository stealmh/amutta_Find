//
//  ViewController.swift
//  amutta
//
//  Created by kimminho on 2022/11/08.
//

import UIKit
import TMapSDK
import Alamofire


class ViewController: UIViewController,TMapViewDelegate {
    
    @IBOutlet weak var mapContainerView: UIView!
    var mapView = TMapView()
    let apiKey: String = "l7xx9e936404d40843cd936cffd31172b0ef"
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        postBodyJsonRequest()
        setTMap()
    }

    func setTMap() {
        self.mapView = TMapView(frame: mapContainerView.frame)
        self.mapView.delegate = self
        self.mapView.setApiKey(apiKey)
        
        mapContainerView.addSubview(self.mapView)
        
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
