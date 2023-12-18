//
//  DetailContentView.swift
//  EZBook
//
//  Created by Paing Zay on 7/12/23.
//

import UIKit
@IBDesignable

class DetailContentView: UIView {
    
    @IBOutlet weak var synopsis: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    private func configureView() {
        guard let view = self.loadViewFromNib(nibName: "DetailContentView") else {return}
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func configureView(title: String) {
        self.synopsis.text = title
    }
    
}
