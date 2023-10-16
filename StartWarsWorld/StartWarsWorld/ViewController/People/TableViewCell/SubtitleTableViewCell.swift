//
//  SubtitleTableViewCell.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import UIKit

class SubtitleTableViewCell: UITableViewCell {

    func configure(titleText: String?, subtitleText: String?, image: UIImage? = UIImage(systemName: "person.fill")) {
        var newContent = defaultContentConfiguration()
        newContent.text = titleText
        newContent.secondaryText = subtitleText
        newContent.image = image
        contentConfiguration = newContent
    }
}
