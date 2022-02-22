//
//  StockTableViewCell.swift
//  StonkScreener
//
//  Created by Luka on 19.2.22.
//

import UIKit

protocol FavoritesButtonDelegate {
    func addToFavorites(cell: StockTableViewCell)
}

class StockTableViewCell: UITableViewCell {

    var delegate: FavoritesButtonDelegate?

    private let stockSymbolLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.textAlignment = .left
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let stockCompanyNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .lightText
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textAlignment = .left
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let stockPriceLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .lightText
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textAlignment = .left
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let favoritesButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "heart")!.withTintColor(.systemRed, renderingMode: .alwaysOriginal), for: .normal)
        return btn
    }()

//    private let favoritesButton = FavoritesButton()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        addSubviews()
        addConstraints()
    }

    func setupViews() {
        backgroundColor = .gray
        favoritesButton.addTarget(self, action: #selector(addToFavoritesButtonTapped), for: .touchUpInside)
    }

    private func addSubviews() {
        addSubview(stockSymbolLabel)
        addSubview(stockCompanyNameLabel)
        addSubview(stockPriceLabel)
        contentView.addSubview(favoritesButton)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            stockSymbolLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stockSymbolLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)])

        NSLayoutConstraint.activate([
            stockCompanyNameLabel.topAnchor.constraint(equalTo: stockSymbolLabel.bottomAnchor, constant: 8),
            stockCompanyNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)])
        
        NSLayoutConstraint.activate([
            favoritesButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            favoritesButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)])
        
        NSLayoutConstraint.activate([
            stockPriceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            stockPriceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @objc func addToFavoritesButtonTapped() {
        delegate?.addToFavorites(cell: self)
    }

    func configure(withStock stock: Stock) {
        stockSymbolLabel.text = stock.symbol
        stockCompanyNameLabel.text = stock.companyName
        stockPriceLabel.text = stock.price.description
    }
    
    override func prepareForReuse() {
        stockSymbolLabel.text = ""
        stockCompanyNameLabel.text = ""
        stockPriceLabel.text = ""
        self.favoritesButton.setImage(UIImage(systemName: "heart")!.withTintColor(.systemRed, renderingMode: .alwaysOriginal), for: .normal)
    }

    func favoriteImageClicked(isFavorite: Bool) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        favoritesButton.alpha = 0.3
        UIView.animate(withDuration: 0.3) {
            self.favoritesButton.alpha = 1.0
            if isFavorite {
                self.favoritesButton.setImage(UIImage(systemName: "heart.fill")!.withTintColor(.systemRed, renderingMode: .alwaysOriginal), for: .normal)
            } else {
                self.favoritesButton.setImage(UIImage(systemName: "heart")!.withTintColor(.systemRed, renderingMode: .alwaysOriginal), for: .normal)
            }
        }
    }
    
    func setFavoriteImage(isActive: Bool) {
        if isActive {
            self.favoritesButton.setImage(UIImage(systemName: "heart.fill")!.withTintColor(.systemRed, renderingMode: .alwaysOriginal), for: .normal)
        } else {
            self.favoritesButton.setImage(UIImage(systemName: "heart")!.withTintColor(.systemRed, renderingMode: .alwaysOriginal), for: .normal)
        }
    }
}
