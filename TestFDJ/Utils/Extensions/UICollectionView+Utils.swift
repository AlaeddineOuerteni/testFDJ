//
//  UICollectionView+Utils.swift
//  TestFDJ
//
//  Created by Alaeddine Ouertani on 10/06/2023.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(
            cellClass,
            forCellWithReuseIdentifier: String(describing: cellClass)
        )
    }

    func findCell<T>(indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue a cell of \(String(describing: T.self))")
        }
        return cell
    }
}
