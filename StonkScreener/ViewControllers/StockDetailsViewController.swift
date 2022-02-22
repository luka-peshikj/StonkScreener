//
//  StockDetailsViewController.swift
//  StonkScreener
//
//  Created by Luka on 19.2.22.
//

import UIKit

class StockDetailsViewController: UIViewController {

    private var newsTableView: UITableView!
    private var currentStock: Stock
    private let newsDataModel = NewsDataSource()
    private let newsCellReuseIdentifier: String = "newsCellReuseIdentifier"
    private var requestInProgress = false
    private var currentPage = 0
    
    /// Bonus feature!
    /// With the default implementation, we fetch 1000 news object from a single request. That seems like a lot. Here I've implemented a "paginated" way of displaying news objects. There are 100 news objects per page, so naturally we fetch and present them much quicker. Enable this boolean to check this feature out.
    private var weWantInfiniteScrolling = false

    // MARK: - Lifecycle methods

    init(withStock stock: Stock) {
        currentStock = stock
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTableView()
        
        if weWantInfiniteScrolling {
            configureDataModel(forPage: currentPage)
        } else {
            configureDataModel()
        }
    }
    
    // MARK: - Helper methods

    private func setupViews() {
        view.backgroundColor = .darkGray
        title = "News"
    }
    
    private func setupTableView() {
        newsTableView = UITableView(frame: .zero)
        newsTableView.register(NewsTableViewCell.self, forCellReuseIdentifier: newsCellReuseIdentifier)
        newsTableView.dataSource = self
        newsTableView.delegate = self
        newsTableView.backgroundColor = .darkGray
        newsTableView.alwaysBounceVertical = false
        newsTableView.rowHeight = UITableView.automaticDimension
        newsTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newsTableView)
        
        NSLayoutConstraint.activate([
            newsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            newsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            newsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureDataModel() {
        if !requestInProgress {
            requestInProgress = true
            newsDataModel.getNewsForStockWithSymbol(symbol: currentStock.symbol, isSuccessfull: { [weak self] isSuccessfull in
                self?.requestInProgress = false
                if isSuccessfull {
                    DispatchQueue.main.async {
                        self?.newsTableView.reloadData()
                    }
                } else {
                    //Here we can handle the error response from the server with the "newsDataModel.newsLoadingError" property. Depending on what type of error it is, whether or not the dataModel is completely empty or not, we can decide what to show and how to proceed.
                }
            })
        }
    }
    
    private func configureDataModel(forPage page: Int) {
        if !requestInProgress {
            requestInProgress = true
            newsDataModel.getNewsForStockWithSymbol(symbol: currentStock.symbol, page: currentPage, isSuccessfull: { [weak self] isSuccessfull in
                self?.requestInProgress = false
                if isSuccessfull {
                    DispatchQueue.main.async {
                        self?.newsTableView.reloadData()
                    }
                } else {
                    //Here we can handle the error response from the server with the "newsDataModel.newsLoadingError" property. Depending on what type of error it is, whether or not the dataModel is completely empty or not, we can decide what to show and how to proceed.
                }
            })
        }
    }
}

// MARK: - Delegate methods

extension StockDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsDataModel.getNewsArray().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: newsCellReuseIdentifier, for: indexPath as IndexPath) as! NewsTableViewCell
        let newsAtIndexPath = newsDataModel.getNewsArray()[indexPath.row]
        
        //This is a simple way of implementing infinite scrolling. Of course, this is dependent on how many new items we get in each response, network speed, scrolling speed, the cell height, how many cell are we showing on screen at any time etc.
        if weWantInfiniteScrolling {
            if indexPath.item + 20 > newsDataModel.getNewsArray().count {
                currentPage += 1
                configureDataModel(forPage: currentPage)
            }
        }
        
        cell.configure(withNewsObject: newsAtIndexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let newsAtIndexPath = newsDataModel.getNewsArray()[indexPath.row]
        //Some of the articles had interesting titles, I wanted to read them.
        if let url = URL(string: newsAtIndexPath.url) {
            UIApplication.shared.open(url)
        }
    }
}

extension StockDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90;
    }
}
