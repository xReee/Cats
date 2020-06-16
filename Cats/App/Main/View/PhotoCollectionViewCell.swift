//
//  PhotoCollectionViewCell.swift
//  Cats
//
//  Created by Renata Faria on 16/06/20.
//  Copyright © 2020 renatafaria. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imgCat: UIImageView!
    
    func setup(with cat: Cat) {
        self.imgCat.loadImageUsingCache(withUrl: cat.imgURL ?? "")
    }
    
}
