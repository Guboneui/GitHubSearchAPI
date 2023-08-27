//
//  SearchRepository.swift
//  GitHubSearchAPI
//
//  Created by 구본의 on 2023/08/27.
//

import Foundation

protocol SearchRepositoryProtocol {
  func fetchSearchAPI(searchText query: String) async throws -> [GitHubSearchItem]
}

class SearchRepository: SearchRepositoryProtocol {
  
  func fetchSearchAPI(searchText query: String) async throws -> [GitHubSearchItem] {
    
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
    print(searchResult.items.count)
    return searchResult.items
  }
}
