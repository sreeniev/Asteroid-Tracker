//
//  AsteroidCell.swift
//  Asteroid
//
//  Created by Sreeni E V on 05/09/22.
//

import UIKit

class AsteroidCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
  
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var nameLAbel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
   
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var backgrndView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        idLabel.text = "Loading..."
        nameLAbel.text = ""
        speedLabel.text = "Loading..."
        sizeLabel.text = "Loading..."
        
        backgrndView.layer.cornerRadius=8
        backgrndView.layer.masksToBounds = true
        backgrndView.alpha = 0.80
        contentView.backgroundColor = .clear
    }
   
 
}
