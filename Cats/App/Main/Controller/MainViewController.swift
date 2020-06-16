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
               self.cellSize += 10
            } else {
                self.cellSize -= 10
            }
        }
        UIView.animate(withDuration: 0.3) {
            self.collectionView.layoutMarginsDidChange()
        }
    }
    var cellSize = 80 {
        didSet {
            cellSize = min(cellSize, 400)
            cellSize = max(cellSize, 40)
        }
    }
    var viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.loadData()
    }
    func loadData() {
        self.viewModel.loadData(didLoad: { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
    
}


extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let text = "Veja a foto do \(viewModel.catTitle(for: indexPath)) no imgur!"
        let link = NSURL(string: viewModel.catOriginalLink(for: indexPath)) as Any
        let shareAll = [text, link] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
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
        return self.viewModel.cellsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        cell.setup(with: viewModel.cat(for: indexPath))
        return cell
    }
    
    
}
