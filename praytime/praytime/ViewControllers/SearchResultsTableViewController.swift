//
//  SearchResultsTableViewController.swift
//  praytime
//
//  Created by Sameer on 12/24/18.
//  Copyright © 2018 praytime. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol SearchResultsDelegate {
    func didSelectLocation(title: String)
}

class SearchResultsTableViewController: UITableViewController {

    typealias LocationResult = (title: String, subtitle: String, location: String)
    private var datasource: [LocationResult] = []
    
    var delegate: SearchResultsDelegate?
    
    lazy var searchCompleter: MKLocalSearchCompleter = {
        let completer = MKLocalSearchCompleter()
        completer.filterType = .locationsOnly
        completer.delegate = self
        return completer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        datasource = []
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func update(text: String) {
        if !text.isEmpty {
            searchCompleter.queryFragment = text
        }
    }
}

extension SearchResultsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = datasource[indexPath.row].title
        cell.detailTextLabel?.text = datasource[indexPath.row].subtitle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectLocation(title: !datasource[indexPath.row].subtitle.isEmpty ? datasource[indexPath.row].subtitle : datasource[indexPath.row].title)
    }
}

extension SearchResultsTableViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        datasource = completer.results.map {
            LocationResult(title: $0.title, subtitle: $0.subtitle, location: $0.title)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
