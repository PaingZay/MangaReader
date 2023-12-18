//
//  CarouselCell.swift
//  EZBook
//
//  Created by Paing Zay on 18/11/23.
//

import UIKit

class CarouselCell: UICollectionViewCell {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var starStack: UIStackView!
    @IBOutlet weak var fifthStar: UIImageView!
    @IBOutlet weak var scorePoints: UILabel!
    
    var score: Double?
    
    func setStar(score: Double) {
        
    let stars = Int((score/100)*5)
    
    scorePoints.text = "\(String(format: "%.1f", score/10))/10"
        
    for (index, subview) in starStack.arrangedSubviews.enumerated() {
        if let imageView = subview as? UIImageView, index < stars {
            imageView.tintColor = UIColor.yellow
        }
    }}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //RadiusRange depends on the size of image
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
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
       
        // Add the gradient layer as an overlay to the cover image
        coverImage.layer.addSublayer(gradientLayer)
}
}
