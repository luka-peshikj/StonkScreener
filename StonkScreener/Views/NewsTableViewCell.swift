//
//  NewsTableViewCell.swift
//  StonkScreener
//
//  Created by Luka on 19.2.22.
//

import UIKit
import SDWebImage

class NewsTableViewCell: UITableViewCell {
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "placeholder_image")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let newsTitleLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.boldSystemFont(ofSize: 17)
        lbl.textAlignment = .left
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let newsDescriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .lightText
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textAlignment = .left
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .darkGray
        addViews()
        addConstraints()
    }
    
    private func addViews() {
        addSubview(newsImageView)
        addSubview(newsTitleLabel)
        addSubview(newsDescriptionLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            newsImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            newsImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10),
            newsImageView.heightAnchor.constraint(equalToConstant: 90),
            newsImageView.widthAnchor.constraint(equalToConstant: 110)
        ])
        
        NSLayoutConstraint.activate([
            newsTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            newsTitleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 10),
            newsTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            newsDescriptionLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor),
            newsDescriptionLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 10),
            newsDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func configure(withNewsObject news: StockNews) {
        if let image = news.image {
            newsImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "placeholder_image"))
        } else {
            newsImageView.image = UIImage(named: "placeholder_image")
        }
        
        newsTitleLabel.text = news.title
        newsDescriptionLabel.text = news.text
    }
    
    override func prepareForReuse() {
        newsImageView.image = UIImage(named: "placeholder_image")
        newsTitleLabel.text = ""
        newsDescriptionLabel.text = ""
    }
}
