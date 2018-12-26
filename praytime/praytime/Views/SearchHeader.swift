//
//  SearchHeader.swift
//  praytime
//
//  Created by Sameer on 12/25/18.
//  Copyright © 2018 praytime. All rights reserved.
//

import UIKit

class SearchHeader: UIView {
    
    private let locationTitle: String
    
    init(title: String) {
        locationTitle = title
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = .groupTableViewBackground
        addLabel()
    }
    
    func addLabel() {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.text = Strings.headerDistanceText + locationTitle
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    }
}

extension SearchHeader {
    struct Strings {
        static let headerDistanceText = "Prayer times within 50 miles of "
    }
}
