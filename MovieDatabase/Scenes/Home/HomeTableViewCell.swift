//
//  HomeTableViewCell.swift
//  MovieDatabase
//
//  Created by Berk Pehlivanoğlu on 27.09.2022.
//

import UIKit
import Kingfisher

final class HomeTableViewCell: UITableViewCell, Layoutable {
    
    // MARK: - Initilization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()

    func setupViews() {
        addSubview(movieImageView)
        addSubview(titleLabel)

    }

    func setupLayout() {
        movieImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(preferredSpacing * 0.8)
            make.leading.equalToSuperview()
            make.height.width.equalTo(104)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(movieImageView.snp.trailing).offset(preferredSpacing * 0.4)
            make.width.equalTo(preferredSpacing * 10.2)
            make.top.equalToSuperview().inset(preferredSpacing * 1.2)
        }
        
    }

}

// MARK: - Configure
extension HomeTableViewCell {
    func configure(movie: [Result], index: Int) {
        movieImageView.kf.indicatorType = .activity
        let path = movie[index].posterPath
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)")
        movieImageView.kf.setImage(with: url)
        titleLabel.text = "\(movie[index].title) (\(movie[index].releaseDate.dropLast(6)))"
    }
}

