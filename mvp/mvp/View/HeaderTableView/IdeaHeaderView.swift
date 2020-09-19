//
//  IdeaHeaderView.swift
//  mvp
//
//  Created by Ankit Sabharwal on 19/09/20.
//  Copyright © 2020 Ankit Sabharwal. All rights reserved.
//

import UIKit

class IdeaHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func bindData(isFavourite: Bool, title: String) {
        if isFavourite {
            icon.image = UIImage(named: "favourite")
        } else {
            icon.image = UIImage(named: "un-favourite")
        }
        titleLabel.text = title
    }
}
