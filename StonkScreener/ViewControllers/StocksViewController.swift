//
//  ViewController.swift
//  StonkScreener
//
//  Created by Luka on 19.2.22.
//

import UIKit

class StocksViewController: UIViewController {
    
    private var tableView: UITableView!
    private let stockCellReuseIdentifier: String = "stockCellReuseIdentifier"
    private var requestInProgress = false
    private let dataModel = StocksDataSource()
    private var searchBar = UISearchBar()
    private var containerView: UIView!
    private var sortByAlphabeticalButton: UIButton!
    private var sortByMarketCapButton: UIButton!
    private var alphabeticalSortingActive = false
    private var marketCapSortingActive = false
    private var tabBarIndex = 0
    private var currentSelectedSortingOption = SortBy.none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupButtons()
        setupTableView()
        configureDataModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        dataModel.tabBarIndex = tabBarController?.selectedIndex ?? 0
        tabBarIndex = tabBarController?.selectedIndex ?? 0
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.sizeToFit()
        searchBar.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width, height: 56)
    }
    
    private func setupViews() {
        view.backgroundColor = .darkGray
        containerView = UIView()
        containerView.backgroundColor = .darkGray
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        searchBar.showsCancelButton = true
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.delegate = self
        searchBar.backgroundColor = .darkGray
        searchBar.backgroundColor = .clear
        searchBar.barStyle = .default
        searchBar.placeholder = "Search stock"
        containerView.addSubview(searchBar)
    }
    
    private func setupButtons() {
        sortByAlphabeticalButton = UIButton()
        sortByAlphabeticalButton.backgroundColor = .darkGray
        sortByAlphabeticalButton.tag = 0
        sortByAlphabeticalButton.translatesAutoresizingMaskIntoConstraints = false
        sortByAlphabeticalButton.setTitle("ABC", for: .normal)
        sortByAlphabeticalButton.addTarget(self, action:#selector(buttonTapped(_ :)), for: .touchUpInside)
        containerView.addSubview(sortByAlphabeticalButton)
        
        NSLayoutConstraint.activate([
            sortByAlphabeticalButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 60),
            sortByAlphabeticalButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            sortByAlphabeticalButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
        
        sortByMarketCapButton = UIButton()
        sortByMarketCapButton.backgroundColor = .darkGray
        sortByMarketCapButton.tag = 1
        sortByMarketCapButton.translatesAutoresizingMaskIntoConstraints = false
        sortByMarketCapButton.setTitle("Market cap", for: .normal)
        sortByMarketCapButton.addTarget(self, action:#selector(buttonTapped(_ :)), for: .touchUpInside)
        containerView.addSubview(sortByMarketCapButton)
        
        NSLayoutConstraint.activate([
            sortByMarketCapButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 60),
            sortByMarketCapButton.leadingAnchor.constraint(equalTo: sortByAlphabeticalButton.trailingAnchor, constant: 20),
            sortByMarketCapButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
        
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero)
        tableView.register(StockTableViewCell.self, forCellReuseIdentifier: stockCellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .darkGray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureDataModel() {
        if !requestInProgress {
            requestInProgress = true
            dataModel.getStocks(isSuccessfull: { [weak self] isSuccessfull in
                self?.requestInProgress = false
                if isSuccessfull {
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                } else {
                    //Here we can handle the error response from the server with the "dataModel.stocksLoadingError" property. Depending on what type of error it is, whether or not the dataModel is completely empty or not, we can decide what to show and how to proceed.
                }
            })
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton){
        switch sender.tag {
        case 0:
            if !marketCapSortingActive {
                alphabeticalSortingActive = !alphabeticalSortingActive
            } else {
                alphabeticalSortingActive = !alphabeticalSortingActive
                marketCapSortingActive = false
            }
        case 1:
            if !alphabeticalSortingActive {
                marketCapSortingActive = !marketCapSortingActive
            } else {
                marketCapSortingActive = !marketCapSortingActive
                alphabeticalSortingActive = false
            }
        default:
          break
        }

        if alphabeticalSortingActive {
            dataModel.sortByOption = .alphabetical
            UIView.animate(withDuration: 0.1) {
                self.sortByAlphabeticalButton.backgroundColor = .gray
            }
        } else {
            UIView.animate(withDuration: 0.1) {
                self.sortByAlphabeticalButton.backgroundColor = .darkGray
            }
        }
        
        if marketCapSortingActive {
            dataModel.sortByOption = .marketCap
            UIView.animate(withDuration: 0.1) {
                self.sortByMarketCapButton.backgroundColor = .gray
            }
        } else {
            UIView.animate(withDuration: 0.1) {
                self.sortByMarketCapButton.backgroundColor = .darkGray
            }
        }
        
        if !alphabeticalSortingActive && !marketCapSortingActive {
            dataModel.sortByOption = .none
        }
        tableView.reloadData()
    }
}

extension StocksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tabBarIndex == 1 && dataModel.getStocksArray().count == 0 {
            return 1
        } else {
            return dataModel.getStocksArray().count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tabBarIndex == 1 && dataModel.getStocksArray().count == 0 {
            //We can create a custom EmptyTableViewCell and modify it however we want.
            let cell = UITableViewCell()
            cell.backgroundColor = .darkGray
            cell.textLabel?.textColor = .white
            cell.textLabel?.text = "No favorite stocks"
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: stockCellReuseIdentifier, for: indexPath as IndexPath) as! StockTableViewCell
        let stockAtIndexPath = dataModel.getStocksArray()[indexPath.row]
        cell.configure(withStock:stockAtIndexPath)
        cell.delegate = self
        if (dataModel.getLocallySavedStock().contains(where: { $0.symbol == stockAtIndexPath.symbol })) {
            cell.setFavoriteImage(isActive: true)
        }
        return cell
    }
}

extension StocksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let stockDetailsViewController = StockDetailsViewController(withStock: dataModel.getStocksArray()[indexPath.row])
        navigationController?.pushViewController(stockDetailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
}

extension StocksViewController: FavoritesButtonDelegate {
    func addToFavorites(cell: StockTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let stockAtIndexPath = dataModel.getStocksArray()[indexPath.row]
            let shouldHighlightFavoriteButton = dataModel.addToFavorites(stock: stockAtIndexPath)
            cell.favoriteImageClicked(isFavorite: shouldHighlightFavoriteButton)
            if (tabBarIndex == 1) {
                if dataModel.getStocksArray().count > 0 {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    tableView.reloadData()
                }
            }
        }
    }
}

extension StocksViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let stockPredicateString = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .alphanumerics) {
            dataModel.filterPredicate = stockPredicateString
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //This is an expensive opperation, we can decide if we want to update the tableView on every text change or only when the user presses the Search button.
        dataModel.filterPredicate = searchText
        tableView.reloadData()
    }
}
