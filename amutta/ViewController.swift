//
//  ViewController.swift
//  amutta
//
//  Created by kimminho on 2022/11/08.
//

import UIKit
import TMapSDK



class ViewController: UIViewController {
    
    var networkGetData = NetworkGetData.shared
    @IBOutlet weak var mainLabel: UILabel!
    var musicArrays: [Poi] = []
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        print(networkGetData.getData(input: networkGetData.makeStringKoreanEncoded("수원")))
        setupTableView()
        setupDatas()
    }
    
    @IBAction func getButtonClicked(_ sender: Any) {
        print(networkGetData.dataArray)
        
    }//getButtonClicked
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        // Nib파일을 사용한다면 등록의 과정이 필요
        
        tableView.register(UINib(nibName: "MusicCell", bundle: nil), forCellReuseIdentifier: "MusicCell")
        
        //musicTableView.rowHeight = 120
    }
    
    func setupDatas() {
        // 네트워킹의 시작
        networkGetData.fetchMusic(searchTerm: "한강") { result in
            print(#function)
            switch result {
            case .success(let musicDatas):
                // 데이터(배열)을 받아오고 난 후
                self.musicArrays = musicDatas
                // 테이블뷰 리로드
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}//ViewControll


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        return self.musicArrays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell", for: indexPath) as! MusicCell
        
        cell.nameLabel.text = musicArrays[indexPath.row].name
        
        cell.selectionStyle = .none
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    // 테이블뷰 셀의 높이를 유동적으로 조절하고 싶다면 구현할 수 있는 메서드
    // (musicTableView.rowHeight = 120 대신에 사용가능)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
