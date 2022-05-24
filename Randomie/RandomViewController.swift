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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        showImagePickerOptions()
    }
    
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
        picker.dismiss(animated: true, completion: nil)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        // Use UIImage
                        self.imageView.image = image
                    }
                }
            })
        }
    }
    
}

//MARK: - UIImagePicker Delegate method
extension RandomViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Get image from camera
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userCapturedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            imageView.image = userCapturedImage
            
            guard let ciImage = CIImage(image: userCapturedImage) else { fatalError("Could not convert to CIImage") }
            
            //TODO: detectImage
            print(ciImage)
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
