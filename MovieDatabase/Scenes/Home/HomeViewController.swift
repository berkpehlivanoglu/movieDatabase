//
//  HomeViewController.swift
//  MovieDatabase
//
//  Created by Berk Pehlivanoğlu on 27.09.2022.
//
import UIKit
import Moya

final class HomeViewController: UIViewController, Layouting, AlertShowing {

    typealias ViewType = HomeView

    var movies: [Result] = []
    var searchedMovies: [Result] = []
    var page = 1

    override func loadView() {
        view = ViewType.create()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setGridAndListView(false)
        fetchMovie(page)
    }
    
}

// MARK: - Setup Helper
extension HomeViewController {

    func setupView() {
        title = "Movies"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        navigationItem.searchController = layoutableView.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = layoutableView.barButtonItem
        
        layoutableView.searchController.searchBar.delegate = self
        setupButtonTargets()
    }
    
    func setGridAndListView(_ gridViewSelected: Bool) {
        if gridViewSelected {
            layoutableView.tableView.alpha = 0
            layoutableView.collectionView.alpha = 1
        } else {
            layoutableView.tableView.alpha = 1
            layoutableView.collectionView.alpha = 0
        }
    }

}

// MARK: - UISearchControllerDelegate, UISearchBarDelegate
extension HomeViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count ?? 0 >= 3 {
            self.searchingMovies(searchBar.text ?? "")
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchedMovies = movies
        layoutableView.tableView.reloadData()
        layoutableView.collectionView.reloadData()
    }
}

// MARK: - SetupButtonTargets
extension HomeViewController {
    func setupButtonTargets() {
        layoutableView.loadMoreButton.addTarget(self, action: #selector(didTapLoadMoreButton), for: .touchUpInside)
    }
}

// MARK: - SetupButtonActions
extension HomeViewController {
    @objc func didTapLoadMoreButton() {
        page += 1
        self.fetchMovie(page)
    
    }
}

// MARK: - Networking
extension HomeViewController {
    
    func fetchMovie(_ page: Int) {

        API.movieProvider.request(.topRated(page: page)) { [weak self] result in

            guard let self = self else { return }

            switch result {
            case .failure(let error):
                self.showAlert(title: Strings.appTitle, message: error.localizedDescription)

            case .success(let response):

                if let errorData = try? response.map(Error.self) {
                    self.showAlert(title: Strings.appTitle, message: errorData.statusMessage)
                    return
                }
                guard let data = try? response.map(Movie.self) else {
                    return
                }
                guard data.results.count > 0 else {
                    print("Movie not found")
                    return
                }
                for results in data.results {
                    self.movies.append(results)
                }
                self.searchedMovies = self.movies
                print(self.movies.count)
                self.layoutableView.tableView.dataSource = self
                self.layoutableView.tableView.delegate = self
                
                self.layoutableView.collectionView.dataSource = self
                self.layoutableView.collectionView.delegate = self
                
                self.layoutableView.tableView.reloadData()
                self.layoutableView.collectionView.reloadData()
                if page > 1 {
                    let row = IndexPath(row: self.movies.count-20, section: 0)
                    self.layoutableView.tableView.scrollToRow(at: row, at: .top, animated: true)
                    self.layoutableView.collectionView.scrollToItem(at: IndexPath(item: self.movies.count-20, section: 0), at: .top, animated: true)
                }

            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedMovies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 136
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableCell", for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
        cell.configure(movie: self.searchedMovies, index: indexPath.row)
        cell.accessoryType = .disclosureIndicator
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard movies.count > 0 else { return }
        let movieDetailViewController = DetailViewController(movie: searchedMovies[indexPath.row])
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionCell", for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(movie: self.searchedMovies, index: indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard movies.count > 0 else { return }
        let movieDetailViewController = DetailViewController(movie: searchedMovies[indexPath.item])
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

// MARK: - SearchingMovies
extension HomeViewController {
    func searchingMovies(_ searchWith: String) {
        let searchText = searchWith.lowercased()
        searchedMovies.removeAll()
        searchedMovies = self.movies.filter({ $0.title.lowercased().contains(searchText)})
        layoutableView.tableView.reloadData()
        layoutableView.collectionView.reloadData()
    }
}
