//
//  HomeView.swift
//  MovieDatabase
//
//  Created by Berk Pehlivanoğlu on 27.09.2022.
//

import UIKit

final class HomeView: UIView, Layoutable {
    
    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "homeTableCell")
        tableView.keyboardDismissMode = .interactive
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        return tableView
    }()
    
    lazy var barButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "rectangle.grid.3x2.fill"), style: .plain, target: self, action: #selector(didTapListItem))
        return item
    }()
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        let width = UIScreen.main.bounds.size.width - preferredSpacing * 3
        layout.itemSize = CGSize(width: floor(width/2), height: width/1.5)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "homeCollectionCell")
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .prominent
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.sizeToFit()
        return searchController
    }()
    
    lazy var loadMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle(Strings.loadMore, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK: - Setups
    func setupViews() {
        backgroundColor = .white
        addSubview(tableView)
        addSubview(collectionView)
        addSubview(loadMoreButton)
        
    }
    
    func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(preferredSpacing)
            make.bottom.equalTo(loadMoreButton.snp.top).offset(-preferredSpacing)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(preferredSpacing)
            make.bottom.equalTo(loadMoreButton.snp.top).offset(-preferredSpacing)
            
        }
        
        loadMoreButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(preferredSpacing * 3)
            make.leading.trailing.equalToSuperview().inset(preferredSpacing)
        }
    }
}

// MARK: - BarButtonItemAction
extension HomeView {
    @objc func didTapGridItem() {
        tableView.alpha = 1
        collectionView.alpha = 0
        barButtonItem.image = UIImage(systemName: "rectangle.grid.3x2.fill")
        barButtonItem.action = #selector(didTapListItem)
    }
    @objc func didTapListItem() {
        tableView.alpha = 0
        collectionView.alpha = 1
        barButtonItem.image = UIImage(systemName: "list.bullet")
        barButtonItem.action = #selector(didTapGridItem)
    }
}
