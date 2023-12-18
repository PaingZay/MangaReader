//
//  CustomDetailView.swift
//  EZBook
//
//  Created by Paing Zay on 7/12/23.
//

import UIKit
class CustomDetailView: UIView {

    @IBOutlet weak var synopsis: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var isExpanded = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    private func configureView() {
        guard let view = self.loadViewFromNib(nibName: "CustomDetailView") else {return}
        view.frame = self.bounds
        self.addSubview(view)
        
        //Make Synopsis Label Clickable
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        synopsis.addGestureRecognizer(tapGestureRecognizer)
        synopsis.isUserInteractionEnabled = true
    }
    
    @objc func labelTapped() {
        if self.isExpanded {
            isExpanded = false
            self.synopsis.numberOfLines = 4
        } else {
            isExpanded = true
            self.synopsis.numberOfLines = 0
        }
    }
    
    func configureView(synopsis: String) {
        self.synopsis.text = synopsis
    }
    
    func scrollToTop() {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    
}

