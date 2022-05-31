//
//  ViewController.swift
//  Randomie
//
//  Created by Nguyen NGO on 23/05/2022.
//

import UIKit
import Vision
import PhotosUI

class RandomViewController: UIViewController {
    
    

    @IBOutlet weak var imageView: UIImageView!
    var imageOrientation = CGImagePropertyOrientation(.up)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add imageView tap gesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView

        // TODO: add action when tapped
        
        // Return when no image found in imageView
        if (imageView.image == nil) { return }
        
        // Return when no sublayers found
        guard let sublayers = tappedImage.layer.sublayers else { return }
        
        
        
        print(sublayers.count)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        showImagePickerOptions()
    }
    
    //MARK: - Faces Detection Functions
    func detectImage(with cgimage: CGImage) {
        let request = VNDetectFaceRectanglesRequest(completionHandler: self.handleFaceDetectionRequest)
        
        let handler = VNImageRequestHandler(cgImage: cgimage, orientation: imageOrientation, options: [:])
        
        // Perform request
        DispatchQueue.global().async {
            do {
                try handler.perform([request])
            } catch {
                fatalError("Error performing request")
            }
        }
        
    }
    
    private func handleFaceDetectionRequest(request: VNRequest?, error: Error?) {
        if let requestError = error as NSError? {
            print(requestError)
            return
        }
        
        DispatchQueue.main.async {
            guard let image = self.imageView.image else { return }
            guard let cgImage = image.cgImage else { return }
            
            let imageRect = self.determineScale(cgImage: cgImage, imageViewFrame: self.imageView.frame)
            
            self.imageView.layer.sublayers = nil
            
            
            if let results = request?.results as? [VNFaceObservation] {
                results.forEach { (observation) in
                    let faceRect = self.convertUnitToPoint(originalImageRect: imageRect, targetRect: observation.boundingBox)
                    
                    let emojiRect = CGRect(x: faceRect.origin.x,
                                           y: faceRect.origin.y,
                                           width: faceRect.size.width,
                                           height: faceRect.size.height * 1.5)
                    
                    let textLayer = CATextLayer()
                    textLayer.string = "🎃"
                    textLayer.fontSize = faceRect.width
                    textLayer.shadowColor = CGColor(srgbRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                    textLayer.shadowRadius = 3
                    textLayer.shadowOpacity = 0.3
                    textLayer.frame = emojiRect
                    textLayer.contentsScale = UIScreen.main.scale
                    
                    self.imageView.layer.addSublayer(textLayer)
                }
            }
        }
        
    }
    
    //MARK: - Show Bottom Sheet Options
    func showImagePickerOptions() {
        let alert = UIAlertController(title: "Pick a photo", message: "Choose a photo from Library or Camera", preferredStyle: .actionSheet)
        
        // Camera button
        let cameraAction = UIAlertAction(title: "Take a photo", style: .default) { [weak self] (action) in
            guard let self = self else { return }

            self.prensentCameraPicker()
        }
        
        // Library button
        let libraryAction = UIAlertAction(title: "Import from Library", style: .default) { [weak self] (action) in
            guard let self = self else { return }
            
            self.presentLibraryPicker()
        }
        
        // Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        
        alert.view.layoutIfNeeded() //avoid Snapshotting error
        self.present(alert, animated: true, completion: nil)
    }
    
    func prensentCameraPicker() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        cameraPicker.allowsEditing = false
        
        self.present(cameraPicker, animated: true, completion: nil)
    }
    
    func presentLibraryPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = PHPickerFilter.images
        let pickerViewController = PHPickerViewController(configuration: config)
        pickerViewController.delegate = self
        
        self.present(pickerViewController, animated: true, completion: nil)
    }
    
}

//MARK: - PHPicker Delegate Method
extension RandomViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        // Dismiss the controller
        picker.dismiss(animated: true, completion: nil)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                if let userPickedImage = object as? UIImage {
                    
                    // Do not put this in the async process
                    // the handler needs to know the image orientation to detect objects
                    self.imageOrientation = CGImagePropertyOrientation(userPickedImage.imageOrientation)
                    
                    // Use UIImage
                    DispatchQueue.main.async {
                        self.imageView.image = userPickedImage
                    }
                    
                    guard let cgImage = userPickedImage.cgImage else {
                        fatalError("Error converting CGImage from userPickedImage")
                    }
                    
                    // Detect Image
                    self.detectImage(with: cgImage)
                    
                }
            })
        }
    }
    
}

//MARK: - UIImagePicker Delegate method
extension RandomViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Get image from camera
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Dismiss the controller
        picker.dismiss(animated: true, completion: nil)
        
        if let userCapturedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            // Do not put this in the async process
            // the handler needs to know the image orientation to detect objects
            self.imageOrientation = CGImagePropertyOrientation(userCapturedImage.imageOrientation)
            
            DispatchQueue.main.async {
                self.imageView.image = userCapturedImage
            }
            
            guard let cgImage = userCapturedImage.cgImage else {
                fatalError("Error converting CGImage from userCapturedImage")
            }
            
            // Detect Image
            self.detectImage(with: cgImage)
            
        }
    }
}
