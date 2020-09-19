//
//  IdeaTableViewCell.swift
//  mvp
//
//  Created by Ankit Sabharwal on 19/09/20.
//  Copyright © 2020 Ankit Sabharwal. All rights reserved.
//

import UIKit

class IdeaTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initAppearance()
    }

    private func initAppearance() {
        favouriteButton.setImage(UIImage(named: "favourite"), for: .selected)
        favouriteButton.setImage(UIImage(named: "un-favourite"), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func favouritePressed(_ sender: UIButton) {
        
    }
    
    func setupCell(ideaViewModel: IdeaViewModel) {
        titleLabel.text = ideaViewModel.ideaTitle
        descLabel.text = ideaViewModel.ideaDescription
        favouriteButton.isSelected = ideaViewModel.isFavourite

    }
}
