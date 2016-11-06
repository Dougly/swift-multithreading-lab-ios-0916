//
//  ImageViewController.swift
//  swift-multithreading-lab
//
//  Created by Ian Rahman on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import UIKit
import CoreImage


//MARK: Image View Controller

class ImageViewController : UIViewController {
    
    var scrollView: UIScrollView!
    var imageView = UIImageView()
    let picker = UIImagePickerController()
    var activityIndicator = UIActivityIndicatorView()
    let filtersToApply = ["CIBloom",
                          "CIPhotoEffectProcess",
                          "CIExposureAdjust"]
    
    var flatigram = Flatigram()
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var chooseImageButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        setUpViews()
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        selectImage()
    }
    
    
    func startProcess () {
        
        filterButton.isEnabled = false
        chooseImageButton.isEnabled = false
        activityIndicator.startAnimating()
        
        filterImage { (success) in
            print("Success?: \(success)")
            self.flatigram.imageState = .filtered
            self.imageView.image = self.flatigram.image
            self.filterButton.isEnabled = true
            self.chooseImageButton.isEnabled = true
            self.activityIndicator.stopAnimating()
        }
        
        
    }
    
    
    
    @IBAction func filterButtonTapped(_ sender: AnyObject) {
        if flatigram.imageState == .unfiltered {
            startProcess()
        } else {
            presentFilteredAlert()
        }
    }
    
}

extension ImageViewController {
    
    func filterImage(with completion: @escaping (Bool) -> Void) {
        
        let queue = OperationQueue()
        var operations: [FilterOperation] = []
        let totalOperations = filtersToApply.count
        var completedOperations = 0 {
            didSet {
                if totalOperations == completedOperations {
                    print("all operations finished")
                    DispatchQueue.main.async {
                        self.imageView.image = self.flatigram.image
                    }
                    completion(true)
                } else {
                    print("waiting on \(operations.count) operations")
                }

            }
        }
    
        
        queue.name = "Image Filtration Queue"
        queue.qualityOfService = .userInitiated
        queue.maxConcurrentOperationCount = 1
        
        for filter in filtersToApply {
            let operation = FilterOperation(flatigram: self.flatigram, filter: filter)
            operation.completionBlock = {
                DispatchQueue.main.async {
                    print("added \(filter) to image")
                    completedOperations += 1
                }
            }
            operations.append(operation)
        }
        
        queue.addOperations(operations, waitUntilFinished: false)
        
    }
}














        
        


