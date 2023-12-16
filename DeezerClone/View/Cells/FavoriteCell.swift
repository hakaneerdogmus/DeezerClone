//
//  FavoriteCell.swift
//  DeezerClone
//
//  Created by Hakan ERDOĞMUŞ on 3.12.2023.
//

import UIKit
import SnapKit
import AVFoundation
import CoreData

extension Notification.Name {
    static let favoriteStatusDidChange = Notification.Name("FavoriteStatusDidChange")
}

class FavoriteCell: UICollectionViewCell {
    static let reuseID = "FavoriteCell"
    
    private var posterImageView: PosterImageView!
    private var collectionView: UICollectionView!
    private var songName: UILabel!
    private var songDuration: UILabel!
    private var favoriteIcon: UIButton!
    private var audioPlayer: AVPlayer!
    var isBool: Bool?
    private var songId: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        configurePosterImageView()
        configureSongName(songTitle: "")
        configureSongDuration(songTime: "")
        favIcon(songId: 0)
        CoreData.shared.favoriteGetCoreData()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        songName.text = ""
        songDuration.text = ""
    }
    //MARK: Cell Setting
    private func configureCell() {
        backgroundColor = .systemGray3
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    //MARK: Get song image
    func setImageCell(songImage: String) {
        posterImageView.downloadFavoriteImage(songImage: songImage)
    }
    //MARK: Poster Image Setting
    private func configurePosterImageView() {
        posterImageView = PosterImageView(frame: .zero)
        addSubview(posterImageView)
        posterImageView.layer.cornerRadius = 10
        posterImageView.clipsToBounds = true
        posterImageView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width * 0.3)
        }
    }
    //MARK: Get Somg Name
    func setSongName(songName: String) {
        configureSongName(songTitle: songName )
    }
    //MARK: Song Name Setting
    private func configureSongName(songTitle: String) {
        songName = UILabel()
        addSubview(songName)
        songName.translatesAutoresizingMaskIntoConstraints = false
        songName.clipsToBounds = true
        songName.text = songTitle
        songName.font = .systemFont(ofSize: 20)
        songName.numberOfLines = 0
        songName.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width * 0.6)
            make.top.equalToSuperview().offset(15)
            make.left.equalTo(posterImageView.snp.right).offset(30)
        }
    }
    //MARK: Get Song Duration
    func setSongDuration(songTime: Int) {
        configureSongDuration(songTime: formatDuration(time: songTime))
    }
    private func formatDuration(time: Int) -> String {
        var stringTime: String = ""
        if(time / 60 < 10) {
            stringTime = "0\(time / 60):"
        } else {
            stringTime = "\(time / 60):"
        }
        if(time % 60 < 10) {
            stringTime += "0\(time % 60)\""
        } else {
            stringTime += "\(time % 60)\""
        }
        return stringTime
    }
    //MARK: Song Duration Setting
    private func configureSongDuration(songTime: String) {
        songDuration = UILabel(frame:  .zero)
        addSubview(songDuration)
        songDuration.translatesAutoresizingMaskIntoConstraints = false
        songDuration.text = songTime
        songDuration.font = .boldSystemFont(ofSize: 15)
        songDuration.textColor = .gray
        songDuration.snp.makeConstraints { make in
            make.top.equalTo(songName.snp.bottom).offset(20)
            make.left.equalTo(posterImageView.snp.right).offset(30)
        }
    }
    //MARK: Set Favorite Icon
    func setFavIcon(songId: Int) {
        favIcon(songId: songId)
    }
    //MARK: RealmData variable assignment
    func setCoreData(songId: Int) {
        self.songId = songId
    }
    //MARK: Favorite Icon
    private func favIcon(songId: Int) {
        favoriteIcon = UIButton(frame: .zero)
        addSubview(favoriteIcon)
        favoriteIcon.translatesAutoresizingMaskIntoConstraints = false
        favoriteIcon.addTarget(self, action: #selector(favoriteTapButton), for: .touchUpInside)
        self.favoriteIcon.isSelected = CoreData.shared.songIdArray.contains(songId) ? true : false
        DispatchQueue.main.async {
            self.isBool = CoreData.shared.songIdArray.contains(songId) ? true : false
            if ((self.isBool == true) ) {
                if let heartImage = UIImage(systemName: "heart.fill") {
                    let resizedHeartImage = heartImage.withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .regular))
                    self.favoriteIcon.setImage(resizedHeartImage, for: .normal)
                }
            } else {
                if let heartImage = UIImage(systemName: "heart") {
                    let resizedHeartImage = heartImage.withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .regular))
                    self.favoriteIcon.setImage(resizedHeartImage, for: .normal)
                }
            }
        }
        self.favoriteIcon.sizeToFit()
        self.favoriteIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(55)
            make.right.equalToSuperview().offset(-10)
        }
    }
    @objc func favoriteTapButton() {
        favoriteIcon.isSelected.toggle()
        print(favoriteIcon.isSelected)
        self.isBool?.toggle()
        DispatchQueue.main.async { [self] in
            NotificationCenter.default.post(name: .favoriteStatusDidChange, object: self)
                if self.favoriteIcon.isSelected {
                    if let heartImage = UIImage(systemName: "heart.fill") {
                        let resizedHeartImage = heartImage.withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .regular))
                        self.favoriteIcon.setImage(resizedHeartImage, for: .normal)
                    }
                } else {
                    CoreData.shared.deleteCoreData(songId: self.songId!)
                    CoreData.shared.favoriteGetCoreData()
                    print("Silindi")
                    print(self.songId!)
                    if let heartImage = UIImage(systemName: "heart") {
                        let resizedHeartImage = heartImage.withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .regular))
                        self.favoriteIcon.setImage(resizedHeartImage, for: .normal)
                }
            }
        }
    }
}
