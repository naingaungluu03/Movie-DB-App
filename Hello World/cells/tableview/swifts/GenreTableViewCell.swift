
//
//  GenreTableViewCell.swift
//  Hello World
//
//  Created by Harry Jason on 16/05/2021.
//

import UIKit

class GenreTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionViewGenre: UICollectionView!
    @IBOutlet weak var collectionViewMovie: UICollectionView!
    
    var genreList : [GenreVO]? {
        didSet {
            if let _ = genreList {
                //set the first genre
                collectionViewGenre.reloadData()
                
                genreList?.removeAll(where: { genre in
                    let genreId = genre.id
                    if let movieList = movieMap[genreId] {
                        if movieList?.isEmpty ?? false {
                          return true
                        }
                    }else {
                        return true
                    }
                    return false
                })
                if let _ = genreList {
                    if genreList!.count > 0 {
                        onTapGenre(genreList![0].id)
                    }
                }
            }
        }
    }
    
    var selectedMovieList : [MovieResult]? {
        didSet {
            collectionViewMovie.reloadData()
        }
    }
    
    var movieCollection : [MovieResult]? {
        didSet {
            if let _ = movieCollection {
                movieCollection?.forEach({ movie in
                    movie.genreIDS?.forEach({ genreId in
                        if var movieList = movieMap[genreId] {
                            movieList?.insert(movie)
                            movieMap[genreId] = movieList
                        }
                        else {
                            movieMap[genreId] = Set.init([movie])
                        }
                    })
                })
            }
//            onTapGenre(genreList?[0].id ?? 0)
        }
    }
    
    var movieList : [MovieResult]? {
        didSet {
            if let _ = movieList {
                onTapGenre(genreList?[0].id ?? 0)
            }
        }
    }
    
    var movieMap = [Int : Set<MovieResult>?]()
    
    var delegate : ((Int) -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionViewGenre.dataSource = self
        collectionViewGenre.delegate = self
        collectionViewGenre.registerCell(identifier: GenreCollectionViewCell.identifier)
        
        collectionViewMovie.dataSource = self
        collectionViewMovie.delegate = self
        
        collectionViewMovie.registerCell(identifier: PopularFilmCollectionViewCell.identifier)
    }
    
    func onTapGenre(_ genreId : Int){
        self.genreList?.forEach { genreVO in
            if genreId == genreVO.id {
                genreVO.isSelected = true
            }else {
                genreVO.isSelected = false
            }
        }
        //Convert Movie Set from map
        let selectedList = self.movieMap[genreId]?.map({ $0 }) ?? Set<MovieResult>()
        self.selectedMovieList = Array(selectedList)
        self.collectionViewMovie.reloadData()
        self.collectionViewGenre.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension GenreTableViewCell : UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewMovie {
            return selectedMovieList?.count ?? 0
        } else {
            return genreList?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewMovie {
            let cell = collectionView.dequeCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath)
            
            (cell as! PopularFilmCollectionViewCell).data = selectedMovieList?[indexPath.row]
            
            return cell
        }else {
            let cell = collectionView.dequeCell(identifier: GenreCollectionViewCell.identifier, indexPath: indexPath) as! GenreCollectionViewCell
            cell.data =  genreList![indexPath.row]
            cell.onTapGenre = { genreId in
                self.onTapGenre(genreId)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collectionViewMovie {
            return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
        } else {
            return CGSize(
                width: widthOfString(
                    text : genreList![indexPath.row].name,
                    font: UIFont(name: "Geeza Pro Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
                ),
                height: 45
            )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movieId = selectedMovieList?[indexPath.row].id {
            delegate?(movieId)
        }
    }
    
    func widthOfString(text : String, font : UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font : font]
        let textSize = text.size(withAttributes: fontAttributes)
        return textSize.width + 40
    }
    
}
