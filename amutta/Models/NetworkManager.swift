//
//  NetworkGetData.swift
//  amutta
//
//  Created by kimminho on 2022/11/09.
//

import Foundation

enum NetworkError: Error {
    case networkError
    case dataError
    case parseError
}



class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    typealias NetworkCompletion = (Result<[Poi], NetworkError>) -> Void
    
    var dataArray = [String]()

    func makeStringKoreanEncoded(_ string: String) -> String {
                return string.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? string
            }
    
    
//    func fetchMusic(searchTerm: String, completion: @escaping NetworkCompletion) {
//        let urlString = "\(MusicApi.requestUrl)\(MusicApi.mediaParam)&term=\(searchTerm)"
//        print(urlString)
//        //유레카 !
//        performRequest(with: urlString) {result in
//            completion(result)
//        }
//    }
    
        func fetchMusic(searchTerm: String, completion: @escaping NetworkCompletion) {
            //searchTerm : 서울
            func fetchEncoded(_ string: String) -> String {
                return string.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? string
            }
            let urlString = "https://apis.openapi.sk.com/tmap/pois?version=1&searchKeyword=\(fetchEncoded(searchTerm))&searchType=all&searchtypCd=A&reqCoordType=WGS84GEO&resCoordType=WGS84GEO&page=1&count=20&multiPoint=Y&poiGroupYn=N"
            print(urlString)
            //유레카 !
            performRequest(with: urlString) {result in
                completion(result)
            }
        }
    
    private func performRequest(with urlString: String, completion: @escaping NetworkCompletion) {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest.init(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("l7xx9e936404d40843cd936cffd31172b0ef", forHTTPHeaderField: "appKey")
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)

        
        let task = session.dataTask(with: request) { (data, response, error) in
            //에러가 nil이 아니라는 것 = [에러]라는 것
            if error != nil {
                print(error!)
                completion(.failure(.networkError))
                return
            }
            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }
            //메서드를 실행해서 결과를 받음
            if let musics = self.parseJSON(safeData) {
                print("Parse 실행")
                completion(.success(musics))
            } else {
                print("Parse 실패")
                completion(.failure(.parseError))
            }
            
        }
        task.resume()
    }
    
    private func parseJSON(_ musicData: Data) -> [Poi]? {
        
        do {
            let musicData = try JSONDecoder().decode(DataHere.self, from: musicData)
            return musicData.searchPoiInfo.pois.poi
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getData(input: String) {
        if let url = URL(string: "https://apis.openapi.sk.com/tmap/pois?version=1&searchKeyword=\(input)&searchType=all&searchtypCd=A&reqCoordType=WGS84GEO&resCoordType=WGS84GEO&page=1&count=20&multiPoint=Y&poiGroupYn=N"){
            
            var request = URLRequest.init(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("l7xx9e936404d40843cd936cffd31172b0ef", forHTTPHeaderField: "appKey")
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request){ (data, response, error) in
                
                guard let data = data else { return }
                
                let decoder = JSONDecoder()
                if let json = try? decoder.decode(DataHere.self, from: data) {
                    DispatchQueue.main.async {
                        for i in json.searchPoiInfo.pois.poi {
                            self.dataArray.append(i.name)
                        }
                    }

                }
                
            }.resume()
        }
    }
    
    
    
    
    
}
