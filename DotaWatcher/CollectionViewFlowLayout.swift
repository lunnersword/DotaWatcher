//
//  CollectionViewFlowLayout.swift
//  DotaWatcher
//
//  Created by lunner on 9/22/15.
//  Copyright © 2015 lunner. All rights reserved.
//

import UIKit

class CollectionViewFlowLayout: UICollectionViewFlowLayout {
	
	init(itemSize: CGSize, headHeight: CGFloat) {
		super.init()
		scrollDirection = .Vertical
		minimumInteritemSpacing = 5.0
		minimumLineSpacing = 5.0
		
		headerReferenceSize = CGSizeMake(headHeight, headHeight)
		footerReferenceSize = CGSizeZero
		
		sectionInset = UIEdgeInsetsMake(10, 2, 15, 10)
		
		
		self.itemSize = itemSize
		
	}
	required init(coder: NSCoder) {
		fatalError("NSCodeing not supported")
	}

}
