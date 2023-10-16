//
//  FilmTileCollectionViewCell.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import UIKit

class FilmTileCollectionViewCell: UICollectionViewCell {

    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    func set(title: String, releaseDate: String) {
        titleLabel.text = title
        releaseDateLabel.text = releaseDate
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 8
    }

}
