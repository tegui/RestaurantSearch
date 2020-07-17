//
//  CuisineSearchViewController.swift
//  RestaurantSearch
//
//  Created by Julian Amortegui on 10/13/19.
//  Copyright © 2019 Julian Amortegui. All rights reserved.
///** tegui.me **/

import UIKit

protocol RestaurantSearchDelegate {
    func updateCurrentCity(with city: City)
    func updateResultsData()
    func enableActivityIndicator(_ status: Bool)
}

// DataSource and Delegate references has been added in storyboard or XIB

class RestaurantSearchViewController: UIViewController {
    
    private enum Config {
        static let viewTitle            = "Restaurant Search"
        static let currentCity          = "Current City: "
        static let selectCity           = "Select City"
        static let defaultCusines       = "All cuisines"
        
        static let fetchingCity         = "Fetching your city information"
        static let fetchingRestaurants  = "Fetching near restaurants and cuisines"
        
        static let cellHeight: CGFloat  = 80
    }
    
    static let reuseIdentifier = String(describing: RestaurantSearchViewController.self)
    
    // MARK: - Class Properties
    
    @IBOutlet private weak var citySearchTextField: UITextField!
    @IBOutlet private weak var currentCityButton: UIButton!
    @IBOutlet private weak var resultsTableView: UITableView!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var activityBackground: UIView!
    @IBOutlet private weak var activityView: UIActivityIndicatorView!
    @IBOutlet private weak var loaderReasonLabel: UILabel!
    @IBOutlet private weak var loaderReasonContainerView: UIView!
    
    private var viewModel = RestaurantSearchViewModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        registerCells()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.configureLocationManager()
    }
    
    // MARK: - Auxiliary Methods
    
    private func setupUI() {
        title = Config.viewTitle
        currentCityButton.setTitle("\(Config.currentCity)\(Config.selectCity)", for: .normal)
        activityView.isHidden = true
        
        loaderReasonLabel.isHidden = true
        loaderReasonLabel.text = Config.fetchingCity
        loaderReasonContainerView.isHidden = true
    }
    
    private func registerCells() {
        let cellNib = UINib(nibName: ResultCell.reuseIdentifier, bundle: nil)
        resultsTableView.register(cellNib, forCellReuseIdentifier: ResultCell.reuseIdentifier)
    }
    
    private func enableUserInteraction(_ status: Bool) {
        citySearchTextField.isUserInteractionEnabled = status
        searchButton.isUserInteractionEnabled = status
    }
    
    // MARK: - Actions
    
    @IBAction private func currentCityAction(_ sender: UIButton) {
        // The idea of this is open a new view and ask for specific locations
        // Not implemented yet...
        // maybe in the future...
        // maybe not :)
    }
    
    @IBAction private func searchAction(_ sender: UIButton) {
        view.endEditing(true)
        loaderReasonLabel.text = Config.fetchingRestaurants
        
        guard var searchQuery = citySearchTextField.text else { return }
        
        if searchQuery == Config.defaultCusines {
            searchQuery = String()
        }
        
        if searchQuery.isEmpty {
            citySearchTextField.text = Config.defaultCusines
        }
        
        enableActivityIndicator(true)
        viewModel.fetchNearRestaurants(with: searchQuery)
    }
}

// MARK: - Extensions

extension RestaurantSearchViewController: RestaurantSearchDelegate {
    func updateCurrentCity(with city: City) {
        currentCityButton.setTitle("\(Config.currentCity)\(city.name)", for: .normal)
    }
    
    func updateResultsData() {
        resultsTableView.reloadData()
    }
    
    func enableActivityIndicator(_ status: Bool) {
        activityBackground.isHidden = !status
        activityView.isHidden = !status
        loaderReasonLabel.isHidden = !status
        loaderReasonContainerView.isHidden = !status
        
        enableUserInteraction(!status)
    }
}

extension RestaurantSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultCell.reuseIdentifier, for: indexPath)
        let item = viewModel.searchResults[indexPath.row]
        
        guard let resultCell = cell as? ResultCell else { return cell }
        resultCell.updateCellContent(with: item)
        
        return resultCell
    }
}

extension RestaurantSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Config.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let restaurant = viewModel.searchResults[indexPath.row].restaurant else { return }
        
        let detail = RestaurantDetailViewController(nibName: RestaurantDetailViewController.reuseIdentifier, bundle: nil)
        detail.restaurant = restaurant
        
        navigationController?.pushViewController(detail, animated: true)
    }
}
