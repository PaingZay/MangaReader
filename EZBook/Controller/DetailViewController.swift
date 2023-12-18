//
//  DetailViewController.swift
//  EZBook
//
//  Created by Paing Zay on 26/11/23.
//

import UIKit
import Firebase
import Kingfisher

class DetailViewController: UIViewController {
    @IBOutlet weak var chaptersTableView: UITableView!
    @IBOutlet weak var synopsisView: UIView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var mangaTitle: UILabel!
    @IBOutlet weak var customNavbar: UIView!
    @IBOutlet weak var chaptersTab: UIButton!
    @IBOutlet weak var chaptersView: UIView!
    @IBOutlet weak var customDetailView: CustomDetailView!
    @IBOutlet weak var detailsTab: UIButton!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var ratingScore: UILabel!
    @IBOutlet weak var favouriteCount: UILabel!
    
    
    var mangaID: String?
    var manageSingleManga = ManageSingleManga()
    var fetchedManga: MangaModel?
    var chapterManager = ChapterManager()
    var fetchedChapters: [ChapterModel] = []
    var selectedTab: UIButton?
    var previousTab: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ChaptersTableViewCell", bundle: nil)
        chaptersTableView.register(nib, forCellReuseIdentifier: "reusableChaptersTableViewCell")
        
        chaptersTableView.dataSource = self
        chaptersTableView.delegate = self
        manageSingleManga.delegate = self
        chapterManager.delegate = self
        if let mangaID = mangaID {
            manageSingleManga.fetchManga(id: mangaID)
            chapterManager.fetchChapters(mangaId: mangaID)
        }
        setUpView()
        
        customDetailView.isHidden = true
    }
    
    func setUpView() {
        synopsisView.layer.shadowColor = UIColor.black.cgColor // Shadow color
        synopsisView.layer.shadowOffset = CGSize(width: 0, height: 2) // Shadow offset (x, y)
        synopsisView.layer.shadowOpacity = 0.5 // Shadow opacity
        synopsisView.layer.shadowRadius = 4.0 // Shadow radius
        synopsisView.layer.masksToBounds = false // Allow the shadow to be visible beyond the view's bounds
        synopsisView.alpha = 0.9
        synopsisView.layer.cornerRadius = 5
        
        applyCircularGradient()
    }
    
    func applyCircularGradient() {
            let gradientLayer = CAGradientLayer()
        gradientLayer.frame = coverImage.bounds
            
            let gradientColors = [
                UIColor.clear.cgColor,
                UIColor.black.cgColor,
                UIColor.black.cgColor,
                UIColor.black.cgColor,
                UIColor.clear.cgColor
            ]
            
            gradientLayer.colors = gradientColors
            
            // Define locations to create a circular gradient
            gradientLayer.locations = [0.0, 0.2, 0.5, 0.8, 1.0]
            
            // Adjust the gradient to make it circular
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
            
        coverImage.layer.mask = gradientLayer
        }
    
    var isExpanded = false
    
    @IBAction func didTapReadMore(_ sender: Any) {
        
        isExpanded.toggle() // Toggle label state
        
//        UIView.transition(with: synopsis, duration: 0.3, options: .transitionFlipFromTop) {
//                if self.isExpanded {
//                    // Expand label by setting to 0 for multiline
//                    self.synopsis.numberOfLines = 0
//                    self.readMore.setTitle("Seeless", for: .normal)
//                } else {
//                    // Collapse label to two lines
//                    self.synopsis.numberOfLines = 2
//                    self.readMore.setTitle("Seemore", for: .normal)
//                }
//        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
//        navigationController?.popViewController(animated: true)
    }
    
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedChapters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableChaptersTableViewCell", for: indexPath) as! ChaptersTableViewCell
        
        if let posterImageUrl = fetchedManga?.posterImage, let title = fetchedManga?.title {
            let resource = KF.ImageResource(downloadURL: URL(string: posterImageUrl)!, cacheKey: posterImageUrl)
            cell.posterImage.kf.setImage(with: resource)
            cell.mangaTitle.text = title
        }
        cell.chapter.text = "Chapter \(String(fetchedChapters[indexPath.row].number))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailsToManga", sender: self)
    }
    
}

extension DetailViewController: SingleMangaDelegate {
    func didRetrieveManga(_ manageSingleManga: ManageSingleManga, manga: MangaModel) {
        fetchedManga = manga
        //Do something once fetching is completed
        if let coverImageUrl = fetchedManga?.coverImage {
            let resource = KF.ImageResource(downloadURL: URL(string: coverImageUrl)!, cacheKey: coverImageUrl)
            DispatchQueue.main.async {
                self.coverImage.kf.setImage(with: resource)
            }
        }
        
        if let title = fetchedManga?.title, let synopsis = fetchedManga?.synopsis {
            DispatchQueue.main.async {
                self.mangaTitle.text = title
                self.authorLabel.text = self.fetchedManga?.serialization
                self.ratingScore.text = "\(String(format: "%.1f", self.fetchedManga?.parsedAverageRating ?? 0.0/10))/10"
                self.customDetailView.configureView(synopsis: synopsis)
            }
        }
        if let favouriteCount = fetchedManga?.favoritesCount {
            DispatchQueue.main.async {
                self.favouriteCount.text = self.formatFavouriteCount(favouriteCount: favouriteCount)
            }
        }
    }
    
    func formatFavouriteCount(favouriteCount: Int) -> String {
      if favouriteCount >= 1000 {
        return String(format: "%.1fk", Double(favouriteCount) / 1000.0)
      } else {
        return String(favouriteCount)
      }
    }
    
    func didFailedWithError(error: Error) {
        print("There is no data returned from the model")
    }
}

extension DetailViewController: ChapterManagerDelegate {
    func didUpdateChapters(_ chapterManager: ChapterManager, chapters: [ChapterModel]) {
        fetchedChapters = chapters
        DispatchQueue.main.async {
            self.chaptersTableView.reloadData()
        }
    }

    func didFailedWithErrors(error: Error) {
        print("Unable to fetch chapters of manga id: \(String(describing: mangaID))")
    }
}

extension DetailViewController {
    
    @IBAction func detailsTabPressed(_ sender: Any) {
        chaptersView.isHidden = true
        customDetailView.isHidden = false
        customDetailView.scrollToTop()
        selectedTab = detailsTab
        updateTabState(tab: detailsTab)
    }
    
    @IBAction func chaptersTabPressed(_ sender: Any) {
        chaptersView.isHidden = false
        customDetailView.isHidden = true
        selectedTab = chaptersTab
        updateTabState(tab: chaptersTab)
    }
    
    func updateTabState(tab: UIButton) {
        previousTab?.tintColor = UIColor.white
        previousTab?.backgroundColor = UIColor.clear
        
        selectedTab?.tintColor = UIColor(named: "customDarkness")
        selectedTab?.backgroundColor = UIColor(named: "darkTeal")?.withAlphaComponent(0.8)
        
        previousTab = tab
    }
}


