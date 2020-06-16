//
//  ViewController.swift
//  Cats
//
//  Created by Renata Faria on 15/06/20.
//  Copyright © 2020 renatafaria. All rights reserved.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    
    @IBAction func didPinch(_ sender: Any) {
        if let sender = sender as? UIPinchGestureRecognizer {
            if sender.scale > 1 {
               self.cellSize += 40
            } else {
                self.cellSize -= 40
            }
        }
        UIView.animate(withDuration: 0.3) {
            self.collectionView.layoutMarginsDidChange()
        }
    }
    var cats = [Cat]()
    var cellSize = 80 {
        didSet {
            cellSize = min(cellSize, 400)
            cellSize = max(cellSize, 40)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        self.navigationController?.navigationBar.isHidden = true
    }
    func loadData() {
        let api = CatAPI()
        api.loadCat(success: { [weak self] cats in
            guard let self = self else { return }
            self.cats = cats
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
}


extension MainViewController: UICollectionViewDelegate {
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        cell.setup(with: cats[indexPath.row])
        return cell
    }
    
    
}
