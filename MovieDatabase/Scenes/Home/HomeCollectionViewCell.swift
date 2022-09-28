//
//  HomeCollectionViewCell.swift
//  MovieDatabase
//
//  Created by Berk Pehlivanoğlu on 27.09.2022.
//

import UIKit
import Kingfisher

final class HomeCollectionViewCell: UICollectionViewCell, Layoutable {
    
    // MARK: - Initilization
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var stackView: UIView = {
        let view = UIView()
        view.addSubview(titleLabel)
        view.addSubview(movieImageView)
        return view
    }()
    
    func setupViews() {
        addSubview(stackView)
    }
    
    func setupLayout() {
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        movieImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(movieImageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(movieImageView.snp.bottom).offset(preferredSpacing * 0.25)
            make.leading.equalTo(movieImageView.snp.leading)
            make.trailing.equalTo(movieImageView.snp.trailing)
            make.centerX.equalToSuperview()
        }
    }
}
// MARK: - Configure
extension HomeCollectionViewCell {
    func configure(movie: [Result], index: Int) {
        movieImageView.kf.indicatorType = .activity
        let path = movie[index].posterPath
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)")
        movieImageView.kf.setImage(with: url)
        titleLabel.text = "\(movie[index].title) (\(movie[index].releaseDate.dropLast(6)))"
    }
}
