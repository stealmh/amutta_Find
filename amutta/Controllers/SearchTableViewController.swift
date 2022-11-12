//
//  SearchTableViewController.swift
//  amutta
//
//  Created by kimminho on 2022/11/12.
//

//
//  SearchViewController.swift
//  amutta
//
//  Created by kimminho on 2022/11/12.
//

import UIKit

final class SearchTableViewController: UIViewController {

    @IBOutlet weak var searchTableView: UITableView!
    let networkManager = NetworkManager.shared
    var musicArrays: [Poi] = []
    
    var searchTerm: String? {
        didSet {
            setupDatas()
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
//        setupDatas()
    }
    
    func setupTableView() {
        searchTableView.dataSource = self
        searchTableView.delegate = self
        // Nib파일을 사용한다면 등록의 과정이 필요
        
        searchTableView.register(UINib(nibName: "MusicCell", bundle: nil), forCellReuseIdentifier: "MusicCell")
        
        //musicTableView.rowHeight = 120
    }
    
    func setupDatas() {
        // 옵셔널 바인딩
        guard let term = searchTerm else { return }
        print("네트워킹 시작 단어 \(term)")
        
        // (네트워킹 시작전에) 다시 빈배열로 만들기
        self.musicArrays = []
        
        // 네트워킹 시작 (찾고자하는 단어를 가지고)
        networkManager.fetchMusic(searchTerm: term) { result in
            switch result {
            case .success(let musicDatas):
                // 결과를 배열에 담고
                self.musicArrays = musicDatas
                // 컬렉션뷰를 리로드 (메인쓰레드에서)
                DispatchQueue.main.async {
                    self.searchTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
  
}

extension SearchTableViewController: UITableViewDataSource {
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

extension SearchTableViewController: UITableViewDelegate {
    // 테이블뷰 셀의 높이를 유동적으로 조절하고 싶다면 구현할 수 있는 메서드
    // (musicTableView.rowHeight = 120 대신에 사용가능)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


