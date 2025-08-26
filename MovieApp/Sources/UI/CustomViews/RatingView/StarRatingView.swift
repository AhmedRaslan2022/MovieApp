//
//  StarRatingView.swift
//
//  Created by Guido on 7/1/20.
//  Copyright © applified.life - All rights reserved.
//

import UIKit

@IBDesignable
class StarRatingView: UIView {

    @IBInspectable var rating: Float = 0 {
        didSet {
            setStarsFor(rating: rating)
        }
    }
    
    @IBInspectable var starColor: UIColor = UIColor.systemOrange {
        didSet {
            for starImageView in [hStack?.star1ImageView, hStack?.star2ImageView, hStack?.star3ImageView, hStack?.star4ImageView, hStack?.star5ImageView] {
                starImageView?.tintColor = starColor
            }
        }
    }

    fileprivate var hStack: StarRatingStackView?

    fileprivate let fullStarImage: UIImage = UIImage(systemName: "star.fill")!
    fileprivate let emptyStarImage: UIImage = UIImage(systemName: "star")!

    convenience init(frame: CGRect, rating: Float, color: UIColor) {
        self.init(frame: frame)
        self.setupView(rating: rating, color: color)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView(rating: self.rating, color: self.starColor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView(rating: 0, color: UIColor.systemOrange)
    }
    
    fileprivate func setupView(rating: Float, color: UIColor) {
        let bundle = Bundle(for: StarRatingStackView.self)
        let nib = UINib(nibName: "StarRatingStackView", bundle: bundle)
        let viewFromNib = nib.instantiate(withOwner: self, options: nil)[0] as! StarRatingStackView
        self.addSubview(viewFromNib)
        
        viewFromNib.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[v]|",
                options: [],
                metrics: nil,
                views: ["v": viewFromNib]
            )
        )
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[v]|",
                options: [],
                metrics: nil,
                views: ["v": viewFromNib]
            )
        )
        
        self.hStack = viewFromNib
        self.rating = rating
        self.starColor = color
        
        self.isMultipleTouchEnabled = false
        self.hStack?.isUserInteractionEnabled = false
    }
    
    fileprivate func setStarsFor(rating: Float) {
        let starImageViews = [hStack?.star1ImageView, hStack?.star2ImageView, hStack?.star3ImageView, hStack?.star4ImageView, hStack?.star5ImageView]
        let fullStars = Int(rating)
        for i in 1...5 {
            if i <= fullStars {
                starImageViews[i - 1]?.image = fullStarImage
            } else {
                starImageViews[i - 1]?.image = emptyStarImage
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touched(touch: touch)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touched(touch: touch)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touched(touch: touch)
    }

    fileprivate func touched(touch: UITouch) {
        guard let hs = self.hStack else { return }
        let touchX = touch.location(in: hs).x
        let ratingFromTouch = 5 * touchX / hs.frame.width
        var roundedRatingFromTouch = Float(Int(ratingFromTouch + 0.5)) // Always round to full stars
        roundedRatingFromTouch = max(1, min(roundedRatingFromTouch, 5)) // Clamp between 1 and 5
        self.rating = roundedRatingFromTouch
    }
}
