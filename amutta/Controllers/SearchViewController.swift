//
//  SearchViewController.swift
//  amutta
//
//  Created by kimminho on 2022/11/12.
//

import UIKit



class SearchViewController: UIViewController, UISearchControllerDelegate {

    @IBOutlet weak var checkDestinationLabel: UILabel!
    @IBOutlet weak var checkLatLabel: UILabel!
    @IBOutlet weak var CheckLonLabel: UILabel!
    let searchController = UISearchController(searchResultsController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchTableViewController") as! SearchTableViewController)
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()

    }
    
    
    func setupSearchBar() {
        self.title = "Music Search"
        navigationItem.searchController = searchController
        // 🍎 2) 서치(결과)컨트롤러의 사용 (복잡한 구현 가능)
        //     ==> 글자마다 검색 기능 + 새로운 화면을 보여주는 것도 가능
        searchController.searchResultsUpdater = self
        
        // 첫글자 대문자 설정 없애기
        searchController.searchBar.autocapitalizationType = .none
    }

}


extension SearchViewController: UISearchResultsUpdating {
    // 유저가 글자를 입력하는 순간마다 호출되는 메서드 ===> 일반적으로 다른 화면을 보여줄때 구현
    func updateSearchResults(for searchController: UISearchController) {
        print("서치바에 입력되는 단어", searchController.searchBar.text ?? "")
        // 글자를 치는 순간에 다른 화면을 보여주고 싶다면 (컬렉션뷰를 보여줌)
        let vc = searchController.searchResultsController as! SearchTableViewController
        // 컬렉션뷰에 찾으려는 단어 전달
        vc.searchTerm = searchController.searchBar.text ?? ""
    }
}
