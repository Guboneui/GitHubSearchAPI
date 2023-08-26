//
//  GitHubTableViewCell.swift
//  GitHubSearchAPI
//
//  Created by 구본의 on 2023/08/27.
//

import UIKit

class GitHubTableViewCell: UITableViewCell {
  
  static let identifier: String = "GitHubTableViewCell"
  
  private let urlLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
    setupLayouts()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    urlLabel.text = nil
  }
  
  private func setupViews() {
    contentView.addSubview(urlLabel)
  }
  
  private func setupLayouts() {
    NSLayoutConstraint.activate([
      urlLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      urlLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      urlLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
      urlLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
    ])
  }
  
  func setupCellConfigure(url: String) {
    urlLabel.text = url
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
