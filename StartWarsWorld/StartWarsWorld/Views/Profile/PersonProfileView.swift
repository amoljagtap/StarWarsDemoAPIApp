//
//  PersonProfileView.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import UIKit

class PersonProfileView: UIView {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dobLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    private func loadViewFromNib() {
        let bundle = Bundle(for: PersonProfileView.self)
        guard let view = bundle.loadNibNamed(PersonProfileView.identifier,
                                             owner: self)?.first as? UIView else {
            fatalError("Failed to initialise PersonProfileView")
        }
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.frame = bounds
        addSubview(view)
    }
    
    func set(name: String, dob: String, gender: String) {
        nameLabel.text = name
        dobLabel.text = "DOB: \(dob)  Gender: \(gender)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = 10.0
    }
}
