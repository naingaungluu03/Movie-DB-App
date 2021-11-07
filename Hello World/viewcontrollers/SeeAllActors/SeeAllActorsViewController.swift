//
//  SeeAllActorsViewController.swift
//  Hello World
//
//  Created by Harry Jason on 11/07/2021.
//

import UIKit

class SeeAllActorsViewController: UIViewController {
    
    
    @IBOutlet weak var collectionViewActors: UICollectionView!
    
    private let networkAgent = AlamofireNetworkAgent.shared
    private let actorModel = ActorModelImpl.sharedModel
    
    private var actorList : [ActorInfoResponse] = []
    private var totalPages = 1
    private var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        fetchActorList()
    }
    
    private func fetchActorList() {
        actorModel.getActorList(pageNo: currentPage)
        { result in
            switch result {
            case .success(let actorListResponse) :
                self.actorList.append(contentsOf: actorListResponse.results ?? [ActorInfoResponse]())
                self.collectionViewActors.reloadData()
                self.totalPages = actorListResponse.totalPages ?? 1
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    private func setupCollectionView() {
        collectionViewActors.delegate = self
        collectionViewActors.dataSource = self
        collectionViewActors.registerCell(identifier: BestActorsCollectionViewCell.identifier)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SeeAllActorsViewController : UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actorList.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeCell(identifier: BestActorsCollectionViewCell.identifier, indexPath: indexPath) as! BestActorsCollectionViewCell
        cell.data = actorList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isLastItem = (indexPath.row == (actorList.count - 1))
                let hasNextPage = ( totalPages - currentPage ) > 0
                if isLastItem && hasNextPage {
                    currentPage += 1
                    fetchActorList()
                }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = actorList[indexPath.row].id {
            navigateToActorDetails(actorId: id)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = ((collectionView.frame.width - 32 ) / 3)
        let height  : CGFloat = width * (3 / 2)
        return CGSize(width: width , height: height)
    }
    
}
