//
//  PetitionCell.swift
//  WhitehousePetitions
//
//  Created by Giovanna Pezzini on 16/01/21.
//

import UIKit

class PetitionCell: UITableViewCell {

    static let reuseID = "PetitionCell"
    let view = UIView()
    let titleLabel = UILabel()
    let bodyLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        guard let imageView = imageView else { return }
        imageView.frame = CGRect(x: contentView.frame.width - 28, y: (contentView.frame.height / 2) - 8, width: 16, height: 16)
    }
    
    func set(petition: Petition) {
        titleLabel.text = petition.title
        if petition.body == "" {
            bodyLabel.text = "No description."
        } else {
            bodyLabel.text = petition.body
        }
    }
    
    func configure() {
        let icon = UIImage(systemName: "chevron.right")
        guard let imageView = imageView else { return }
        imageView.image = icon
        imageView.contentMode = .scaleAspectFit
        
        backgroundColor = .clear
        clipsToBounds = true
        selectionStyle = .blue
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0.44, green: 0.56, blue: 0.69, alpha: 1.00).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 4
    }
    
    func layoutUI() {
        addSubview(view)
        addSubview(titleLabel)
        addSubview(bodyLabel)
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.lineBreakMode = .byTruncatingTail
        bodyLabel.numberOfLines = 2
        bodyLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            bodyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        ])
    }
}
