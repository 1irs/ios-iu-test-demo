//
//  SearchViewController.swift
//  bizi-baza
//
//  Created by Vladimir Obrizan on 21.05.2020.
//  Copyright © 2020 Design and Test Lab. All rights reserved.
//

import UIKit


@objc protocol SuggestService {
    func suggest(query: String, completion: @escaping (_ suggestions: [String], _ error: Error?) -> Void)
}

@objc protocol SearchVCDelegate {
    func didSelect(_ : DNTLSearchViewController, suggestion: String)
    func didSelect(_ : DNTLSearchViewController, custom: String)
    func didCancel(_ : DNTLSearchViewController)
}


@objc class DNTLSearchViewController: UITableViewController {
    
    @objc var suggestionService: SuggestService?
    
    @objc var searchVCDelegate: SearchVCDelegate?
    
    var data: [String] = []
    
    var nomatchesView: UIView?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search categories"
        searchController.searchBar.delegate = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        nomatchesView = UIView(frame: view.frame)
        nomatchesView!.backgroundColor = .clear
        nomatchesView?.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap)
        ))

        let matchesLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 26))
        matchesLabel.font = UIFont(name: "SourceSansPro-Regular", size: 18)
        matchesLabel.numberOfLines = 1
        matchesLabel.lineBreakMode = .byWordWrapping
        matchesLabel.textColor = .darkGray
        matchesLabel.backgroundColor = .clear
        matchesLabel.textAlignment = .center;
        matchesLabel.text = "Item coming soon! Tap to add."
        
        nomatchesView!.isHidden = true
        nomatchesView!.addSubview(matchesLabel)
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = CGPoint(x: view.frame.width / 2, y: 22)
        
        tableView.insertSubview(nomatchesView!, belowSubview:tableView)
        tableView.insertSubview(activityIndicator, belowSubview:tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nomatchesView!.isHidden = data.count != 0 || searchController.searchBar.text?.count == 0
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel!.text = data[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchVCDelegate?.didSelect(self, suggestion: data[indexPath.row])
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            searchVCDelegate?.didSelect(self, custom: searchController.searchBar.text!)
        }
    }
}


extension DNTLSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let query = searchBar.text!
        activityIndicator.startAnimating()
        suggestionService?.suggest(query: query, completion: { (suggestions: [String], error: Error?) in
            self.activityIndicator.stopAnimating()
            self.data = suggestions
            self.tableView.reloadData()
        })
    }
}


extension DNTLSearchViewController: UISearchBarDelegate {
 
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchVCDelegate?.didCancel(self)
    }
}
