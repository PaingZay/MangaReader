//
//  HomeVC.swift
//  EZBook
//
//  Created by Paing Zay on 18/11/23.
//

import UIKit
import Kingfisher
import Firebase

class HomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var recentReleaseCollectionView: UICollectionView!
    @IBOutlet weak var mostPopularColletionView: UICollectionView!
    @IBOutlet weak var topRatedCollectionView: UICollectionView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var username: UILabel!
    
    var imageArray = [UIImage(named: "NormalPunch"),UIImage(named: "Book002"),UIImage(named: "Book003")]
    
    var comingSoonArray = [UIImage(named: "FubukiCover"),UIImage(named: "FubukiCover"),UIImage(named: "FubukiCover"),UIImage(named: "FubukiCover")]
    
    var recentReleaseArray = [UIImage(named: "Genos1"),UIImage(named: "Genos2"),UIImage(named: "Genos3")]
    
    var mangaManager = MangaManager()
    
    var topRatedMangas: [MangaModel] = []
    var recentReleasedMangas: [MangaModel] = []
    var popularMangas: [MangaModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "EZBooks"
        
        profilePicture.layer.cornerRadius = 10 // Set your desired corner radius
        profilePicture.clipsToBounds = true// Do any additional setup after loading the view.
        
        //CarouselViewRegistration
        mostPopularColletionView.dataSource = self
        mostPopularColletionView.delegate = self
        mostPopularColletionView.register(UINib(nibName: "CarouselCell", bundle: nil), forCellWithReuseIdentifier: "CarouselCellIdentifier")
        //End
        
        //ComingSoonViewRegistration
        topRatedCollectionView.dataSource = self
        topRatedCollectionView.delegate = self
        topRatedCollectionView.register(UINib(nibName: "CarouselCell2", bundle: nil), forCellWithReuseIdentifier: "CarouselCellIdentifier2")
        //End
        
        //RecentRelease
        recentReleaseCollectionView.dataSource = self
        recentReleaseCollectionView.delegate = self
        recentReleaseCollectionView.register(UINib(nibName: "CarouselCell2", bundle: nil), forCellWithReuseIdentifier: "CarouselCellIdentifier2")
        //End
        
        
        //The following is API fetching
        mangaManager.delegate = self
        mangaManager.fetchBooks(filter: .highestRated)
        mangaManager.fetchBooks(filter: .mostPopular)
        mangaManager.fetchBooks(filter: .recentRelease)
//      mangaManager.delegate = self /* FOUND THE ERROR I DUNNO WHY self declaration as delegate after fetching api has issues */
        
        setUpView()
        
        if let user = Auth.auth().currentUser {
                self.username.text = user.email
                } else {
                    print("No user signed in")
                }
    }
    
    func setUpView() {
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        headerView.layer.shadowOpacity = 0.5
        headerView.layer.shadowRadius = 4.0
        headerView.layer.masksToBounds = false
        headerView.layer.cornerRadius = 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (collectionView == mostPopularColletionView) {
            return popularMangas.count
        }
            
        if (collectionView == topRatedCollectionView) {
            return topRatedMangas.count
        }
        
        if (collectionView == recentReleaseCollectionView) {
//            return recentReleaseArray.count
            return recentReleasedMangas.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let defaultCell = UICollectionViewCell()
        
        if (collectionView == recentReleaseCollectionView) {
            guard let cell = recentReleaseCollectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCellIdentifier2", for: indexPath) as? CarouselCell2 else {
                fatalError("Unable to dequeue CustomCollectionViewCell")
            }
            if let coverImageUrl = recentReleasedMangas[indexPath.row].coverImage {
                let resource = KF.ImageResource(downloadURL: URL(string: coverImageUrl)!, cacheKey: coverImageUrl)
                cell.coverImage.kf.setImage(with: resource)
            } else {
                cell.coverImage.contentMode = .scaleAspectFit
            }
            if let title = recentReleasedMangas[indexPath.row].title {
                cell.title.text = title
            }
            return cell
        }
        
        if (collectionView == mostPopularColletionView) {
            guard let cell = mostPopularColletionView.dequeueReusableCell(withReuseIdentifier: "CarouselCellIdentifier", for: indexPath) as? CarouselCell else {
                fatalError("Unable to dequeue CustomCollectionViewCell")
            }
            if let coverImageUrl = popularMangas[indexPath.row].coverImage {
                let resource = KF.ImageResource(downloadURL: URL(string: coverImageUrl)!, cacheKey: coverImageUrl)
                cell.coverImage.kf.setImage(with: resource)
            }
            
            cell.title.text = popularMangas[indexPath.row].title
            if let averageRating = popularMangas[indexPath.row].averageRating {
                if let convertedAvgRating = Double(averageRating) {
                    
                    cell.setStar(score: convertedAvgRating)
                }
            }
            return cell
        }
        
        if (collectionView == topRatedCollectionView) {
            print("I am here")
            guard let cell = topRatedCollectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCellIdentifier2", for: indexPath) as? CarouselCell2 else {
                fatalError("Unable to dequeue CustomCollectionViewCell")
            }

            if let coverImageUrl = topRatedMangas[indexPath.row].coverImage {
                let resource = KF.ImageResource(downloadURL: URL(string: coverImageUrl)!, cacheKey: coverImageUrl)
                cell.coverImage.kf.setImage(with: resource)
            }
            
            if let title = topRatedMangas[indexPath.row].title {
                cell.title.text = title
            }
            
            return cell
        }
        
        return defaultCell
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        performSegue(withIdentifier: "HomeToSearch", sender: self)
    }
    
}

extension HomeVC: MangaDelegate {
    func didUpdateRecentRelease(_ magaManager: MangaManager, mangas: [MangaModel]) {
        recentReleasedMangas = mangas
        DispatchQueue.main.async {
            self.recentReleaseCollectionView.reloadData()
        }
    }
    
    func didUpdateHighRatedMangas(_ mangaManager: MangaManager, mangas: [MangaModel]) {
        topRatedMangas = mangas
        DispatchQueue.main.async {
            self.topRatedCollectionView.reloadData()
        }
    }
    
    func didFailedWithError(error: Error) {
        print("There is no data returned from the model")
    }

    func didUpdatePopularMangas(_ MangaManager: MangaManager, mangas: [MangaModel]) {
        popularMangas = mangas
        DispatchQueue.main.async {
            self.mostPopularColletionView.reloadData()
        }
    }
}

extension HomeVC {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (collectionView == mostPopularColletionView) {
            let selectedItemID = popularMangas[indexPath.item].id // Replace with your data source and property for ID
                performSegue(withIdentifier: "HomeToDetail", sender: selectedItemID)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToDetail" {
            if let destinationVC = segue.destination as? DetailViewController {
                if let selectedID = sender as? String {
                    destinationVC.mangaID = selectedID
                }
            }
        }
    }
}

extension HomeVC {
//    func loadUserData(){
//        nothing = []
//        db.collection()
//    }
}
