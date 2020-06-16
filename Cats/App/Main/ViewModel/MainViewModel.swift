//
//  MainViewModel.swift
//  Cats
//
//  Created by Renata Faria on 16/06/20.
//  Copyright © 2020 renatafaria. All rights reserved.
//

import Foundation

class MainViewModel {
    
    private var cats = [Cat]()
    
    func loadData(didLoad: @escaping (()->Void) ) {
        CatAPI.loadCat(onComplete: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
            case .success(let cats):
                self.cats = cats
                didLoad()
            }
        })
    }
    
    var cellsCount: Int {
        return self.cats.count
    }
    func cat(for indexPath: IndexPath) -> Cat {
        return self.cats[indexPath.row]
    }
    func catTitle(for indexPath: IndexPath) -> String {
        return self.cats[indexPath.row].title ?? ""
    }
    func catOriginalLink(for indexPath: IndexPath) -> String {
        return self.cats[indexPath.row].originURL ?? ""
    }
}

