//
//  ViewController.swift
//  PhotoCollection
//
//  Created by SasikumarSubramaniyam on 19/04/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var viewModel: PhotoViewModel?
    private var page: Int = 1
    private var isPageRefreshing: Bool = false
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpCollectionView()
        setUpViewModel()
    }
    
    // This function used to setup the collectionview with collectionview cell
    private func setUpCollectionView() {
        collectionView.register(UINib(nibName: Constants.nibId, bundle: nil), forCellWithReuseIdentifier: Constants.cellId)
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        flowLayout.sectionInset = sectionInsets
        collectionView.contentSize = CGSize(width: collectionView.frame.width/4, height: 200)
        collectionView.collectionViewLayout = flowLayout
    }
    
    // This function used to setup the View Model
    private func setUpViewModel() {
        viewModel = PhotoViewModel()
        fetchPhotosListData(with: page)
    }
    
    // This function used get the success or failure response from the news list api
    private func fetchPhotosListData(with pageNumber: Int) {
        viewModel?.getImageList(with: pageNumber, completionHandler: { [weak self] isSuccess, error in
            if let isSuccess, isSuccess == true {
                self?.isPageRefreshing = false
                self?.collectionView.reloadData()
            } else {
                if let error {
                    switch error {
                    case .network(let message):
                        self?.showAlertMessage(with: Constants.error, message: message)
                    case .request(let message):
                        self?.showAlertMessage(with: Constants.error, message: message)
                    case .other(let message):
                        self?.showAlertMessage(with: Constants.error, message: message)
                    }
                }
            }
        })
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfRows ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellId, for: indexPath)
        if let imageCell = cell as? PhotoViewCell {
            if let urlString = viewModel?.fetchPhotoURL(with: indexPath.row),
               let url = URL(string: urlString) {
                imageCell.imageView.downloadPhoto(url)
            } else {
                imageCell.imageView.image = UIImage(named: Constants.placeHolder)
            }
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       if(collectionView.contentOffset.y >= (collectionView.contentSize.height - collectionView.bounds.size.height)) {
           if !isPageRefreshing {
               isPageRefreshing = true
               page = page + 1
               fetchPhotosListData(with: page)
           }
       }
   }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
