//
//  ViewController.swift
//  GitHubSearchAPI
//
//  Created by 구본의 on 2023/08/27.
//

import UIKit

class ViewController: UIViewController {
  
  private lazy var searchController = UISearchController(searchResultsController: nil)
  
  private let indicatorView: UIActivityIndicatorView = {
    let indicatorView = UIActivityIndicatorView()
    indicatorView.translatesAutoresizingMaskIntoConstraints = false
    indicatorView.style = .large
    return indicatorView
  }()
  
  private lazy var searchResultTableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(GitHubTableViewCell.self, forCellReuseIdentifier: GitHubTableViewCell.identifier)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 20
    tableView.separatorInset = .zero
    tableView.backgroundColor = .white
    return tableView
  }()
  
  private var searchResultItems: [GitHubSearchItem] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigations()
    setupViews()
    setupLayouts()
  }
  
  private func setupNavigations() {
    title = "SearchMain"
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchResultsUpdater = self
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    navigationItem.searchController?.searchBar.delegate = self
  }
  
  private func setupViews() {
    view.backgroundColor = .white
    view.addSubview(searchResultTableView)
    view.addSubview(indicatorView)
  }
  
  private func setupLayouts() {
    NSLayoutConstraint.activate([
      searchResultTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      searchResultTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      searchResultTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      searchResultTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ])
  }
  
  private func fetchSearchAPI(searchText query: String) {
    Task.detached { [weak self] in
      guard let url = URL(string: "https://api.github.com/search/repositories?q=\(query)") else {
        throw NSError(domain: "Invalid URL", code: 0)
      }
      
      let (data, response) = try await URLSession.shared.data(from: url)
      guard let httpResponse = (response as? HTTPURLResponse) else {
        throw NSError(domain: "HttpResponse Error", code: 0)
      }
      
      guard httpResponse.statusCode == 200 else {
        throw NSError(domain: "StatusCode Error", code: 0)
      }
      
      let searchResult = try JSONDecoder().decode(GitHubSearchResponse.self, from: data)
      
      await self?.setItems(searchResult.items)
    }
  }
  
  @MainActor
  private func setItems(_ items: [GitHubSearchItem]) async {
    searchResultItems = items
    searchResultTableView.reloadData()
  }
}

extension ViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    perform(#selector(searchKeywordBySearchBarInput), with: nil, afterDelay: 0.5)
  }
  
  @objc private func searchKeywordBySearchBarInput() {
    guard let keyword = searchController.searchBar.text else { return }
    print(keyword)
  }
}

extension ViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if let searchText = searchBar.text {
      fetchSearchAPI(searchText: searchText)
    }
    
    searchController.dismiss(animated: true)
  }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchResultItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: GitHubTableViewCell.identifier,
      for: indexPath) as? GitHubTableViewCell
    else {
      return UITableViewCell()
    }
    
    let data = searchResultItems[indexPath.row]
    cell.setupCellConfigure(url: data.html_url)
    return cell
  }
}
