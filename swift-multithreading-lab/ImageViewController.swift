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
    
    func startProcess() {
        
        filterButton.isEnabled = false
        chooseImageButton.isEnabled = false
        activityIndicator.startAnimating()
        
        filterImage { (result) in
            OperationQueue.main.addOperation {
                result ? print("Image successfully filtered") : print("Image filtering did not complete")
                self.imageView.image = self.flatigram.image
                self.activityIndicator.stopAnimating()
                self.filterButton.isEnabled = true
                self.chooseImageButton.isEnabled = true
            }
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
        
        queue.name = "Image Filtration Queue"
        queue.qualityOfService = .userInitiated
        queue.maxConcurrentOperationCount = 1
        
        
        for filter in self.filtersToApply {
            
            let filterer = FilterOperation(flatigram: self.flatigram, filter: filter)
            
            filterer.completionBlock = {
                
                if filterer.isCancelled {
                    completion(false)
                    return
                }
                
                if queue.operationCount == 0 {
                    DispatchQueue.main.async {
                        self.flatigram.imageState = .filtered
                        completion(true)
                    }
                }
                
                queue.addOperation(filterer)
                print("Added FilterOperation with \(filter) to \(queue.name!)")
            }
            
            
            
            print("**** operation count: \(queue.operations.count)")
            
            
            
            
        }
        
        
    }
}
