//
//  ArtistsCell.swift
//  DeezerClone
//
//  Created by Hakan ERDOĞMUŞ on 1.12.2023.
//

import UIKit
import SnapKit

class ArtistsCell: UICollectionViewCell {
    
    static let reuseID = "ArtistsCell"
    
    private var posterImageView: PosterImageView!
    private var labelText: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        configurePosterImageView()
        configureLabelText(text: "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        posterImageView.cancelDownloading()
        labelText.text = nil
    }
    //MARK: Hücre ayarı
    private func configureCell() {
        backgroundColor = .systemGray3
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    func setCell(artistsImage: ArtistsData) {
        posterImageView.downloadArtistsImage(artists: artistsImage)
    }
    private func configurePosterImageView() {
        posterImageView = PosterImageView(frame: .zero)
        addSubview(posterImageView)
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    func setLabelText(nameArtists: ArtistsData) {
        configureLabelText(text: nameArtists._name)
    }
    private func configureLabelText(text: String) {
        labelText = UILabel(frame: .zero)
        posterImageView.addSubview(labelText)
        labelText.translatesAutoresizingMaskIntoConstraints = false
        labelText.text = text
        labelText.textColor = .white
        labelText.textAlignment = .center
        labelText.font = .boldSystemFont(ofSize: 20)
        labelText.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(-30)
            make.bottom.equalTo(posterImageView.snp.bottom).offset(-10)
            make.centerX.equalToSuperview()
        }
    }
}
