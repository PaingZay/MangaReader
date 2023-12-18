//
//  MangaReaderViewController.swift
//  EZBook
//
//  Created by Paing Zay on 25/11/23.
//

import UIKit
import PDFKit

class MangaReaderViewController: UIViewController {

    var pdfDocument: PDFDocument?
    var currentPage = 0
    
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var currentPageIndicator: UITextField!
    @IBOutlet weak var totalPagesIndicator: UITextField!
    @IBOutlet weak var backToFirstPageButton: UIButton!
    @IBOutlet weak var previousPageButton: UIButton!
    @IBOutlet weak var skipToLastButton: UIButton!
    @IBOutlet weak var nextPageButton: UIButton!
    
    @IBOutlet weak var bg: UIView!
    var defScaleFactor = CGFloat()
    var defMinScaleFactor = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//         Load your PDF document
        if let documentURL = Bundle.main.url(forResource: "OPM", withExtension: "pdf") {
            pdfDocument = PDFDocument(url: documentURL)
            if let pdfDocument = pdfDocument {
                pdfView.document = pdfDocument
                pdfView.layoutDocumentView()
                pdfView.autoScales = true
                //Set default width and height or pdf view
                //But this is a shortcut I'll have to find better way
                defScaleFactor = pdfView.scaleFactor
                defMinScaleFactor = pdfView.minScaleFactor
                
                // Set the PDFView's background color
                pdfView.backgroundColor = UIColor(named: "customDarkness") ?? .black
                
    //          Navigate to current page or first page
                showPage(page: currentPage)
            }
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                    pdfView.addGestureRecognizer(tapGesture)
    }
    
    //Navigate to the current page
    func showPage(page: Int) {
            guard let pdfDocument = pdfDocument, page < pdfDocument.pageCount else {
                return
            }
            
            if let currentPage = pdfDocument.page(at: page) {
                let pageRect = currentPage.bounds(for: .mediaBox)
                if pageRect.size.width > pageRect.size.height {
                    
                    pdfView.displayMode = .singlePage// Display single page
                    
                    // Calculate the scale to fit the width of the page in the view
                    let widthScale = pdfView.bounds.width / pageRect.size.width
                    pdfView.scaleFactor = widthScale
                    pdfView.minScaleFactor = widthScale // Set minScaleFactor to the calculated widthScale
                } else {
                    pdfView.scaleFactor = defScaleFactor
                    pdfView.minScaleFactor = defMinScaleFactor
                    pdfView.displayMode = .singlePage// Display single page
                }
                
                pdfView.go(to: currentPage)
                
                updateUI()
            }
        
    func updateUI() {
        currentPageIndicator.text = String(currentPage + 1)
        totalPagesIndicator.text = String(pdfDocument.pageCount)
        
        skipToLastButton.isHidden = currentPage + 1 == pdfDocument.pageCount ? true : false
        nextPageButton.isHidden = currentPage + 1 == pdfDocument.pageCount ? true : false
        
        previousPageButton.isHidden = currentPage == 0 ? true : false
        backToFirstPageButton.isHidden = currentPage == 0 ? true : false
        }
    }

    //Update current page when click next
    @IBAction func nextPage(_ sender: Any) {
        if(currentPage < pdfDocument!.pageCount - 1) {
            currentPage += 1
            showPage(page: currentPage)
        }
    }
    
    @IBAction func skipLastPage(_ sender: Any) {
        if currentPage < pdfDocument!.pageCount - 1 {
            currentPage = pdfDocument!.pageCount - 1
            showPage(page: currentPage)
        }
    }
    
    @IBAction func backFirstPage(_ sender: Any) {
        if currentPage > 0 {
            currentPage = 0
            showPage(page: currentPage)
        }
    }
    
    //Update current page when click previous
    @IBAction func previousPage(_ sender: Any) {
            if currentPage > 0 {
                currentPage -= 1
                showPage(page: currentPage)
            }
    }
    
    // Handle tap gesture on PDFView to navigate to the next page
   @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
       if currentPage < (pdfDocument?.pageCount ?? 0) - 1 {
           currentPage += 1
           showPage(page: currentPage)
       }
   }
}
