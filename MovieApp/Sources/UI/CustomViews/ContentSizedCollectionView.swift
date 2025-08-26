//
//  ContentSizedCollectionView.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

import UIKit

class CollectionViewContentSized: UICollectionView {
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
