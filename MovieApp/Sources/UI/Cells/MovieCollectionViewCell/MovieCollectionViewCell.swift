//
//  MovieCollectionViewCell.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

import UIKit

final class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var movieRatingLabel: UILabel!
    @IBOutlet private weak var movieReleaseDateLabel: UILabel!
    @IBOutlet private weak var favButton: UIButton!
 

    var favAction: ((_ id: Int)-> Void)?
    
    private var id: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImageView.layer.cornerRadius = 8.0
        movieImageView.clipsToBounds = true
        containerView.applyDefaultStyle()
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = nil
        movieTitleLabel.text = nil
        movieRatingLabel.text = nil
        movieReleaseDateLabel.text = nil
    }
    
    
    
    func configCell(with movie: MovieCellViewModel){
        self.id = movie.id
        movieImageView.setWith(movie.posterURL)
        movieTitleLabel.text = movie.title
        movieRatingLabel.text = movie.ratingText
        movieReleaseDateLabel.text = movie.releaseDate
        favButton.isSelected = movie.isFavourite
        favButton.tintColor = movie.isFavourite ? .red : .gray
     
    }
    
    
    @IBAction private func favWasPressed(_ sender: UIButton){
        guard let id = id else {return}
        favAction?(id)
    }
}
