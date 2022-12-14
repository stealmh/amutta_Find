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
        
        // π 1) (λ¨μ)μμΉλ°μ μ¬μ©
        searchController.searchBar.delegate = self

    }
}
extension SearchViewController: UISearchBarDelegate {

    // μ μ κ° κΈμλ₯Ό μλ ₯νλ μκ°λ§λ€ νΈμΆλλ λ©μλ
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        print(searchText)
        // λ€μ λΉ λ°°μ΄λ‘ λ§λ€κΈ° β­οΈ
        networkGetData.dataArray = []

        // λ€νΈμνΉ μμ
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

    // κ²μ(Search) λ²νΌμ λλ μλ νΈμΆλλ λ©μλ
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let text = searchController.searchBar.text else {
//            return
//        }
//        print(text)
//        // λ€μ λΉ λ°°μ΄λ‘ λ§λ€κΈ° β­οΈ
//        self.musicArrays = []
//
//        // λ€νΈμνΉ μμ
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

