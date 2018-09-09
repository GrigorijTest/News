//
//  NewsCell.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 09.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import UIKit

final class NewsCell: UITableViewCell {

    static let rowHeight: CGFloat = 120
    
    // MARK: - Properties
    
    private let nameLabel = UILabel()
    private let subtextLabel = UILabel()
    private let dateLabel = UILabel()
    private let rightOffset: CGFloat = 20
    private let leftOffset: CGFloat = -5
    
    
    // MARK: - Init
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        drawSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private methods
    
    private func drawSelf() {
        nameLabel.numberOfLines = 1
        nameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: rightOffset).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: NewsCell.rowHeight/4).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width*2/3).isActive = true
        
        subtextLabel.numberOfLines = 2
        subtextLabel.adjustsFontSizeToFitWidth = true
        subtextLabel.minimumScaleFactor = 0.5
        subtextLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtextLabel)
        subtextLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: rightOffset).isActive = true
        subtextLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: leftOffset).isActive = true
        subtextLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        subtextLabel.heightAnchor.constraint(equalToConstant: NewsCell.rowHeight/2)
        
        dateLabel.numberOfLines = 1
        dateLabel.font = UIFont.italicSystemFont(ofSize: 14)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textAlignment = .right
        dateLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        contentView.addSubview(dateLabel)
        dateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: leftOffset).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 2*rightOffset).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: subtextLabel.bottomAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: NewsCell.rowHeight/6).isActive = true
    }
    
}


// MARK: - Setupable
extension NewsCell: Setupable {
    
    func setup(_ object: Any) {
        guard let setupModel = object as? ItemOfNews else {
            return
        }
        
        nameLabel.text = setupModel.name
        subtextLabel.text = setupModel.text
        dateLabel.text = "\(setupModel.milliseconds)"
    }
    
}

