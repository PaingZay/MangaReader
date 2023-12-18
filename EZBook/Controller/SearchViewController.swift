//
//  SearchViewController.swift
//  EZBook
//
//  Created by Paing Zay on 3/12/23.
//

import UIKit

class SearchViewController: UIViewController {

    let recommendationsView = UIView()
    let recommendationTableView = UITableView()
    let suggestionViewBG = UIImageView()
    var searchesManager = SearchesManager()
    @IBOutlet weak var searchCancel: UIButton!
    
    @IBOutlet weak var searchBarContainer: UIView!
    
    var suggestions: [SuggestionModel] = []
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var recentSearchesView: UIView!
    @IBOutlet weak var searchBar: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recommendationTableView.delegate = self
        recommendationTableView.dataSource = self
        searchBar.delegate = self
        setUpViews()
        setUPLayout()
        recommendationTableView.isHidden = true
        searchesManager.delegate = self
    }
    
    func setUpViews() {
        //searchBar
        searchBarContainer.layer.cornerRadius = searchBarContainer.frame.size.height / 20
        searchBar.layer.opacity = 80
        
        //recommendationView
        recommendationsView.backgroundColor = .clear
        view.addSubview(recommendationsView)
        
        recommendationTableView.backgroundColor = .clear
        recommendationsView.addSubview(recommendationTableView)
        
        recommendationTableView.register(UINib(nibName: "RecommendationTableViewCell", bundle: nil), forCellReuseIdentifier: "reusableRecommendationCell")
    }
    
    func setUPLayout() {
        recommendationsView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                recommendationsView.topAnchor.constraint(equalTo: homeView.topAnchor),
                recommendationsView.leadingAnchor.constraint(equalTo: homeView.leadingAnchor),
                recommendationsView.trailingAnchor.constraint(equalTo: homeView.trailingAnchor),
                recommendationsView.bottomAnchor.constraint(equalTo: homeView.bottomAnchor)
            ])
        
        recommendationTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                recommendationTableView.topAnchor.constraint(equalTo: recommendationsView.topAnchor),
                recommendationTableView.leadingAnchor.constraint(equalTo: recommendationsView.leadingAnchor),
                recommendationTableView.trailingAnchor.constraint(equalTo: recommendationsView.trailingAnchor),
                recommendationTableView.bottomAnchor.constraint(equalTo: recommendationsView.bottomAnchor)
            ])

    }
    
    @IBAction func searchCancelPressed(_ sender: Any) {
        recentSearchesView.isHidden = false
        recommendationsView.isHidden = true
        searchBar.text = ""
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = recommendationTableView.dequeueReusableCell(withIdentifier: "reusableRecommendationCell", for: indexPath) as? RecommendationTableViewCell else {
            fatalError("Unable to deqeue CustomCollectionViewCell")
        }
        if let romajiTitle = suggestions[indexPath.row].romajiTitle {
            cell.title.text = romajiTitle
        } else if let englishTitle = suggestions[indexPath.row].englishTitle {
            cell.title.text = englishTitle
        } else {
            cell.title.text = suggestions[indexPath.row].japaneseTitle
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == recommendationTableView) {
            let selectedItemId = suggestions[indexPath.item].id
            
            performSegue(withIdentifier: "SearchToDetail", sender: selectedItemId)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchToDetail" {
            if let destinationVC = segue.destination as? DetailViewController {
                if let selectedID = sender as? String {
                    destinationVC.mangaID = selectedID
                }
            }
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        recommendationsView.isHidden = false
        recommendationTableView.isHidden = false
        recentSearchesView.isHidden = true
        
        if let userInput = searchBar.text {
            if userInput == ""{
                suggestions = []
                DispatchQueue.main.async {
                    self.recommendationTableView.reloadData()
                }
            }
        searchesManager.fetchResults(input: userInput)
            print("Text changed: \(searchBar.text ?? "")")
        }
        return true
    }
}

extension SearchViewController: SearchesManagerDelegate {
    func didUpdateSearches(_ searchesManager: SearchesManager, searchedResults: [MangaModel]) {
        print("Nothing to do right now")
    }
    
    func didUpdateSuggestions(_ searchesManager: SearchesManager, suggestions: [SuggestionModel]) {
        self.suggestions = []
        DispatchQueue.main.async {
            self.recommendationTableView.reloadData()
        }
        self.suggestions = suggestions
        print("Total Suggestions\(suggestions.count)")
        DispatchQueue.main.async {
            self.recommendationTableView.reloadData()
        }
    }
    
    func didFailedWithError(error: Error) {
        print("Search Result Not Found")
    }
    
    
}
