//
//  CarouselCell2.swift
//  EZBook
//
//  Created by Paing Zay on 19/11/23.
//

import UIKit

class CarouselCell2: UICollectionViewCell {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        coverImage.layer.cornerRadius = coverImage.frame.size.height / 25
        
        // Create a gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = coverImage.bounds
       
        // Define the colors for the gradient (transparent to black)
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
       
        // Define the locations for the gradient colors
        gradientLayer.locations = [0.0, 1.0]
       
        // Set the gradient direction from top to bottom
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.1)
       
        // Add the gradient layer as an overlay to the cover image
        coverImage.layer.addSublayer(gradientLayer)
    }

}
