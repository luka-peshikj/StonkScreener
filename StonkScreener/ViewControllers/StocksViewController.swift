//
//  ViewController.swift
//  StonkScreener
//
//  Created by Luka on 19.2.22.
//

import UIKit

class StocksViewController: UIViewController {
    
    private var stocksTableView: UITableView!
    private var countryFilterTableView: UITableView!
    private var containerView: UIView!
    private var sortByAlphabeticalButton: UIButton!
    private var sortByMarketCapButton: UIButton!
    private var filterByCountryButton: UIButton!
    private var searchBar = UISearchBar()
    private let stocksDataModel = StocksDataSource()
    private var countriesDataModel = CountryFilterDataSource()
    private let stockCellReuseIdentifier: String = "stockCellReuseIdentifier"
    private var requestInProgress = false
    private var alphabeticalSortingActive = false
    private var marketCapSortingActive = false
    private var tabBarIndex = 0
    private var currentSelectedSortingOption = SortBy.none
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupButtons()
        setupTableViews()
        configureDataModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        stocksDataModel.tabBarIndex = tabBarController?.selectedIndex ?? 0
        tabBarIndex = tabBarController?.selectedIndex ?? 0
        stocksTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.sizeToFit()
        searchBar.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width, height: 56)
    }
    
    // MARK: - Helper methods

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
        
        filterByCountryButton = UIButton()
        filterByCountryButton.backgroundColor = .darkGray
        filterByCountryButton.tag = 2
        filterByCountryButton.translatesAutoresizingMaskIntoConstraints = false
        filterByCountryButton.setTitle("Filter by country", for: .normal)
        filterByCountryButton.titleLabel?.font = (UIFont.systemFont(ofSize: 14))
        filterByCountryButton.addTarget(self, action:#selector(buttonTapped(_ :)), for: .touchUpInside)
        containerView.addSubview(filterByCountryButton)
        
        NSLayoutConstraint.activate([
            filterByCountryButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 60),
            filterByCountryButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            filterByCountryButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
        
    }
    
    private func setupTableViews() {
        stocksTableView = UITableView(frame: .zero)
        stocksTableView.register(StockTableViewCell.self, forCellReuseIdentifier: stockCellReuseIdentifier)
        stocksTableView.dataSource = self
        stocksTableView.delegate = self
        stocksTableView.alwaysBounceVertical = false
        stocksTableView.rowHeight = UITableView.automaticDimension
        stocksTableView.backgroundColor = .darkGray
        stocksTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stocksTableView)
        
        NSLayoutConstraint.activate([
            stocksTableView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            stocksTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stocksTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stocksTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
        countryFilterTableView = UITableView(frame: .zero)
        countryFilterTableView.register(StockTableViewCell.self, forCellReuseIdentifier: stockCellReuseIdentifier)
        countryFilterTableView.dataSource = self
        countryFilterTableView.delegate = self
        countryFilterTableView.alwaysBounceVertical = false
        countryFilterTableView.rowHeight = UITableView.automaticDimension
        countryFilterTableView.backgroundColor = .darkGray
        countryFilterTableView.translatesAutoresizingMaskIntoConstraints = false
        countryFilterTableView.isHidden = true
        view.addSubview(countryFilterTableView)
        
        NSLayoutConstraint.activate([
            countryFilterTableView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            countryFilterTableView.heightAnchor.constraint(equalToConstant: 300),
            countryFilterTableView.widthAnchor.constraint(equalToConstant: 100),
            countryFilterTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func configureDataModel() {
        if !requestInProgress {
            requestInProgress = true
            stocksDataModel.getStocks(isSuccessfull: { [weak self] isSuccessfull in
                self?.requestInProgress = false
                if isSuccessfull {
                    DispatchQueue.main.async {
                        self?.stocksTableView.reloadData()
                        self?.countriesDataModel.configureDataSource(withStocks: self?.stocksDataModel.getFetchedStocks() ?? [])
                        self?.countryFilterTableView.reloadData()
                    }
                } else {
                    //Here we can handle the error response from the server with the "stocksDataModel.stocksLoadingError" property. Depending on what type of error it is, whether or not the dataModel is completely empty or not, we can decide what to show and how to proceed.
                }
            })
        }
    }
    
    // MARK: - Button Actions

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
        case 2:
            countryFilterTableView.isHidden = !countryFilterTableView.isHidden
            if countryFilterTableView.isHidden {
                if !countriesDataModel.getActiveCountrySet().isEmpty {
                    filterByCountryButton.backgroundColor = .gray
                } else {
                    filterByCountryButton.backgroundColor = .darkGray
                }
            } else {
                filterByCountryButton.backgroundColor = .gray
            }

        default:
          break
        }

        if alphabeticalSortingActive {
            stocksDataModel.sortByOption = .alphabetical
            UIView.animate(withDuration: 0.1) {
                self.sortByAlphabeticalButton.backgroundColor = .gray
            }
        } else {
            UIView.animate(withDuration: 0.1) {
                self.sortByAlphabeticalButton.backgroundColor = .darkGray
            }
        }
        
        if marketCapSortingActive {
            stocksDataModel.sortByOption = .marketCap
            UIView.animate(withDuration: 0.1) {
                self.sortByMarketCapButton.backgroundColor = .gray
            }
        } else {
            UIView.animate(withDuration: 0.1) {
                self.sortByMarketCapButton.backgroundColor = .darkGray
            }
        }
        
        if !alphabeticalSortingActive && !marketCapSortingActive {
            stocksDataModel.sortByOption = .none
        }
        stocksTableView.reloadData()
    }
}

// MARK: - Delegate methods

extension StocksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == stocksTableView {
            if tabBarIndex == 1 && stocksDataModel.getStocksArray().count == 0 {
                return 1
            } else {
                return stocksDataModel.getStocksArray().count
            }
        } else {
            return countriesDataModel.getCountryArray().count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == stocksTableView {
            if tabBarIndex == 1 && stocksDataModel.getStocksArray().count == 0 {
                //We can create a custom EmptyTableViewCell and modify it however we want.
                let cell = UITableViewCell()
                cell.backgroundColor = .darkGray
                cell.textLabel?.textColor = .white
                cell.textLabel?.text = "No favorite stocks"
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: stockCellReuseIdentifier, for: indexPath as IndexPath) as! StockTableViewCell
            let stockAtIndexPath = stocksDataModel.getStocksArray()[indexPath.row]
            cell.configure(withStock:stockAtIndexPath)
            cell.delegate = self
            if (stocksDataModel.getLocallySavedStock().contains(where: { $0.symbol == stockAtIndexPath.symbol })) {
                cell.setFavoriteImage(isActive: true)
            }
            return cell
        } else {
            //We can also create a custom CountryFilterTableViewCell, present the full name of the country, add a checkmark next to it etc...
            let cell = UITableViewCell()
            let countryFilter = countriesDataModel.getCountryArray()[indexPath.row]
            if countriesDataModel.getActiveCountrySet().contains(countryFilter) {
                cell.backgroundColor = .lightGray
            } else {
                cell.backgroundColor = .darkGray
            }
            cell.textLabel?.textColor = .white
            cell.textLabel?.text = countryFilter
            return cell
        }
    }
}

extension StocksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == stocksTableView {
            let stockDetailsViewController = StockDetailsViewController(withStock: stocksDataModel.getStocksArray()[indexPath.row])
            navigationController?.pushViewController(stockDetailsViewController, animated: true)
        } else {
            let selectedCountry = countriesDataModel.getCountryArray()[indexPath.row]
            if countriesDataModel.getActiveCountrySet().contains(selectedCountry) {
                countryFilterTableView.cellForRow(at: indexPath)?.backgroundColor = .darkGray
                countriesDataModel.deleteCountryFromFilter(country: selectedCountry)
            } else {
                countryFilterTableView.cellForRow(at: indexPath)?.backgroundColor = .lightGray
                countriesDataModel.addCountryToFilter(country: selectedCountry)
            }
            stocksDataModel.countriesFilterArray = Array(countriesDataModel.getActiveCountrySet())
            stocksTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == stocksTableView {
            return 60;
        } else {
            return 40
        }
    }
}

extension StocksViewController: FavoritesButtonDelegate {
    func addToFavorites(cell: StockTableViewCell) {
        if let indexPath = stocksTableView.indexPath(for: cell) {
            let stockAtIndexPath = stocksDataModel.getStocksArray()[indexPath.row]
            let shouldHighlightFavoriteButton = stocksDataModel.addToFavorites(stock: stockAtIndexPath)
            cell.favoriteImageClicked(isFavorite: shouldHighlightFavoriteButton)
            if (tabBarIndex == 1) {
                if stocksDataModel.getStocksArray().count > 0 {
                    stocksTableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    stocksTableView.reloadData()
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
            stocksDataModel.filterPredicate = stockPredicateString
            stocksTableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //This is an expensive opperation, we can decide if we want to update the tableView on every text change or only when the user presses the Search button.
        stocksDataModel.filterPredicate = searchText
        stocksTableView.reloadData()
    }
}
