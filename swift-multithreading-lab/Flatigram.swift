//
//  Flatigram.swift
//  swift-multithreading-lab
//
//  Created by Douglas Galante on 11/5/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

enum ImageState {
    case filtered
    case unfiltered
}


class Flatigram {
    
    var image: UIImage?
    var imageState: ImageState = .unfiltered
    
}



