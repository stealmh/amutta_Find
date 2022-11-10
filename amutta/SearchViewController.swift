//
//  SearchViewController.swift
//  amutta
//
//  Created by kimminho on 2022/11/09.
//

import UIKit

class SearchViewController: UIViewController {
    
    
    var networkGetData = NetworkGetData()
    let searchController = UISearchController()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupSearchBar()

        // Do any additional setup after loading the view.
    }
    
    func setupSearchBar() {
        self.title = "Music Search"
        navigationItem.searchController = searchController
        
        // 🍏 1) (단순)서치바의 사용
        searchController.searchBar.delegate = self

    }
}
extension SearchViewController: UISearchBarDelegate {

    // 유저가 글자를 입력하는 순간마다 호출되는 메서드
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        print(searchText)
        // 다시 빈 배열로 만들기 ⭐️
        networkGetData.dataArray = []

        // 네트워킹 시작
        networkManager.fetchMusic(searchTerm: searchText) { result in
            switch result {
            case .success(let musicDatas):
                self.musicArrays = musicDatas
                DispatchQueue.main.async {
                    self.musicTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    // 검색(Search) 버튼을 눌렀을때 호출되는 메서드
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let text = searchController.searchBar.text else {
//            return
//        }
//        print(text)
//        // 다시 빈 배열로 만들기 ⭐️
//        self.musicArrays = []
//
//        // 네트워킹 시작
//        networkManager.fetchMusic(searchTerm: text) { result in
//            switch result {
//            case .success(let musicDatas):
//                self.musicArrays = musicDatas
//                DispatchQueue.main.async {
//                    self.musicTableView.reloadData()
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//        self.view.endEditing(true)
//    }
}









extension SearchViewController: UITableViewDelegate{

}

extension SearchViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        cell.searchLabel.text = networkGetData.dataArray[indexPath.row]
        return cell
    }
    

}

