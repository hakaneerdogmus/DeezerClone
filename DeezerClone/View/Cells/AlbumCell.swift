//
//  AlbumCell.swift
//  DeezerClone
//
//  Created by Hakan ERDOĞMUŞ on 1.12.2023.
//

import UIKit
import SnapKit
import AVFoundation
import CoreData

class AlbumCell: UICollectionViewCell {
    
    static let reuseID = "AlbumCell"
    
    private var isBool: Bool!
    private var posterImageView: PosterImageView!
    private var songName: UILabel!
    private var songDuration: UILabel!
    private var favoriteIcon: UIButton!
    private var audioPlayer: AVPlayer!
    //CoreData veriable
    private var duration: Int?
    private var preview: String?
    private var title: String?
    private var albumCover: String?
    private var songId: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        configurePosterImageView()
        configureSongName(songTitle: "")
        configureSongDuration(songTime: "")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        posterImageView.cancelDownloading()
        songName.text = nil
        songDuration.text = nil
        isBool = false
        favoriteIcon.setImage(nil, for: .normal)
        CoreData.shared.favoriteGetCoreData()
    }
    //MARK: Cell Setting
    private func configureCell() {
        backgroundColor = .systemGray3
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    //MARK: Get Album Image
    func setCell(albumId: AlbumData) {
        posterImageView.downloadAlbumsImage(albumId: albumId)
    }
    //MARK: Poster Image Setting
    private func configurePosterImageView() {
        posterImageView = PosterImageView(frame: .zero)
        addSubview(posterImageView)
        posterImageView.layer.cornerRadius = 10
        posterImageView.clipsToBounds = true
        posterImageView.backgroundColor = .white
        posterImageView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width * 0.3)
        }
    }
    //MARK: Get Somg Name
    func setAlbumName(albumData: AlbumData) {
        configureSongName(songTitle: albumData._songTitle)
    }
    //MARK: Song Name Setting
    private func configureSongName(songTitle: String) {
        songName = UILabel(frame: .zero)
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
    func setSongDuration(songTime: AlbumData) {
        configureSongDuration(songTime: formatDuration(time: songTime._songDuration))
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
    //MARK: RealmData variable assignment
    func setCoreData(albumData: AlbumData) {
        self.duration = albumData._songDuration
        self.preview = albumData._preview
        self.title = albumData._songTitle
        self.albumCover = albumData.album?._cover
        self.songId = albumData._songId
    }
    //MARK: Favorite Icon
    func favIcon(albumData: AlbumData) {
        favoriteIcon = UIButton(frame: .zero)
        addSubview(favoriteIcon)
        favoriteIcon.translatesAutoresizingMaskIntoConstraints = false
        favoriteIcon.addTarget(self, action: #selector(favTapButton), for: .touchUpInside)
        DispatchQueue.main.async {
            self.favoriteIcon.isSelected = CoreData.shared.songIdArray.contains(albumData._songId) ? true : false
            self.isBool = CoreData.shared.songIdArray.contains(albumData._songId) ? true : false
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
    
    @objc func favTapButton() {
        favoriteIcon.isSelected.toggle()
        print(favoriteIcon.isSelected)
        self.favoriteIcon.reloadInputViews()
            // Gerekirse UI güncellemelerini burada yapabilirsiniz
            DispatchQueue.main.async {
                if self.favoriteIcon.isSelected {
                    if(CoreData.shared.songIdArray.contains(self.songId!) == false) {
                        CoreData.shared.saveCoreData(duration: self.duration!, preview: self.preview!, title: self.title!, albumCover: self.albumCover!, songId: self.songId!)
                        print("Kaydedildi")
                    }
                    if let heartImage = UIImage(systemName: "heart.fill") {
                        let resizedHeartImage = heartImage.withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .regular))
                        self.favoriteIcon.setImage(resizedHeartImage, for: .normal)
                    }
                } else {
                    CoreData.shared.deleteCoreData(songId: self.songId!)
                    print("Silindi")
                    if let heartImage = UIImage(systemName: "heart") {
                        let resizedHeartImage = heartImage.withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .regular))
                        self.favoriteIcon.setImage(resizedHeartImage, for: .normal)
                }
            }
        }
    }
}

