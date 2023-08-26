//
//  GitHubSearchResponse.swift
//  GitHubSearchAPI
//
//  Created by 구본의 on 2023/08/27.
//

import Foundation

struct GitHubSearchResponse: Codable {
  let total_count: Int
  let incomplete_results: Bool
  let items: [GitHubSearchItem]
}

struct GitHubSearchItem: Codable {
  let id: Int
  let full_name: String
  let html_url: String
}
