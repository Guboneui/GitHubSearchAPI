//
//  SearchRepositoryTest.swift
//  GitHubSearchAPITests
//
//  Created by 구본의 on 2023/08/27.
//

import XCTest
@testable import GitHubSearchAPI

final class SearchRepositoryStub: SearchRepositoryProtocol {
  func fetchSearchAPI(searchText query: String) async throws -> [GitHubSearchItem] {
    return [
      GitHubSearchItem(
        id: 0,
        full_name: "TEST",
        html_url: "testURL@test.com")
    ]
  }
}

final class SearchRepositoryTest: XCTestCase {
  
  private var searchrepository: SearchRepositoryProtocol!
  
  override func setUp() {
    super.setUp()
    self.searchrepository = SearchRepositoryStub()
  }
  
  func testSearch_searchGitHub() async {
    let item = GitHubSearchItem(
      id: 0,
      full_name: "TEST",
      html_url: "testURL@test.com")
    
    
    let result = try? await searchrepository.fetchSearchAPI(searchText: "SnapKit")
    XCTAssertEqual(result?.count ?? -1, 1)
    XCTAssertEqual(result?.first!, item)
  }
}
