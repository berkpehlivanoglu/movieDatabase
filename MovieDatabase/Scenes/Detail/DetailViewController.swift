//
//  DetailViewController.swift
//  MovieDatabase
//
//  Created by Berk Pehlivanoğlu on 28.09.2022.
//

import UIKit

final class DetailViewController: UIViewController, Layouting, AlertShowing {
    // MARK: - Initialization
    typealias ViewType = DetailView
    
    override func loadView() {
        view = ViewType.create()
    }
    
    private var movie: Result?
    private var movieDetail: MovieDetail?
    
    convenience init(movie: Result) {
        self.init()
        self.movie = movie
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMovieDetail(id: movie?.id ?? 0)
    }
    
}
// MARK: - SetupHelper
extension DetailViewController {
    func setupView() {
        title = movie?.title
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .black
    }
}
// MARK: - Networking
extension DetailViewController {
    func fetchMovieDetail(id: Int) {
        layoutableView.setLoading(true)

        API.movieProvider.request(.showDetail(id: id)) { [weak self] result in

            guard let self = self else { return }
            self.layoutableView.setLoading(false)

            switch result {
            case .failure(let error):
                self.showAlert(title: Strings.appTitle, message: error.localizedDescription)

            case .success(let response):

                if let errorData = try? response.map(Error.self) {
                    self.showAlert(title: Strings.appTitle, message: errorData.statusMessage)
                    return
                }
                guard let data = try? response.map(MovieDetail.self) else {
                    return
                }
                self.movieDetail = data
                guard let movieDetail = self.movieDetail else { return }
                self.layoutableView.configure(movie: movieDetail)
                self.layoutableView.endEditing(true)
            }
        }
    }
}
