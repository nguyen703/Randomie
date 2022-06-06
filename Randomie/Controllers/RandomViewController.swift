//
//  ViewController.swift
//  Randomie
//
//  Created by Nguyen NGO on 23/05/2022.
//

import UIKit
import Vision
import PhotosUI
import Loady
import ChameleonFramework

class RandomViewController: UIViewController {
    
    // Temp Timer for the randomize button effect
    var tempTimerBtnEffect : Timer?

    @IBOutlet weak var imageView: UIImageView!
    
    var imageOrientation = CGImagePropertyOrientation(.up)
    var winnerFound = false
    var isButtonRandomCreated = false
    var usedImages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setup()
    }
    
    func setup() {
        guard let navBar = navigationController?.navigationBar else { return }
        
        
        // Create gradient color based on Chameleon
        let gradientColor = GradientColor(.topToBottom, frame: UIScreen.main.bounds, colors: Array(arrayLiteral: K.Palette.firstColor, K.Palette.secondColor, K.Palette.thirdColor))
        
        navBar.tintColor = K.Palette.activeTextColor
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: K.Palette.activeTextColor,
                                      NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)]
        view.backgroundColor = gradientColor
    }
    
    //MARK: - addButtonPressed Function
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        showImagePickerOptions()
    }
    
    //MARK: - Randomize Button Functions
    func createRandomizeButton() {
        
        // Do not create if existed
        if (isButtonRandomCreated) { return }
        
        DispatchQueue.main.async {
            let buttonRandomize = LoadyButton()
            
            buttonRandomize.frame.size.width = K.Button.RandomButton.width
            buttonRandomize.frame.size.height = K.Button.RandomButton.height
            buttonRandomize.frame = CGRect(
                x: self.view.frame.size.width/2 - buttonRandomize.frame.size.width/2,
                y: self.view.frame.size.height * 0.75,
                width: buttonRandomize.frame.width,
                height: buttonRandomize.frame.height)
            
            // Loading Top-line effect
            buttonRandomize.setAnimation(LoadyAnimationType.topLine())
            buttonRandomize.loadingColor = UIColor.white
            
            // Apply customized setting for the button
            buttonRandomize.customizeButton()
            buttonRandomize.addTarget(self, action: #selector(self.buttonRandomizePressed(_:)), for: .touchUpInside)
            
            // Do not create button if it exists already
            self.isButtonRandomCreated = true
            self.view.addSubview(buttonRandomize)
        }
    }
    
    
    // Add action to button
    @objc func buttonRandomizePressed(_ sender: UIButton) {
        guard let button = sender as? LoadyButton else { return }
        
        // Check if winner is found
        // Check before random
        if !isValidImage(img: imageView) { return }
        if (winnerFound) { return }
        
        button.addTouchedEffect()
        
        button.startLoading()
        var percent: CGFloat = 0
        
        self.tempTimerBtnEffect?.invalidate()
        self.tempTimerBtnEffect = nil
        
        self.tempTimerBtnEffect = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){(t) in
            percent += CGFloat.random(in: 5...10)
            
            button.update(percent: percent)
            if percent > 105 {
                percent = 100
                self.tempTimerBtnEffect?.invalidate()
            }
        }
        
        self.tempTimerBtnEffect?.fire()
        
        /*
        ////////////////////
        // TRIGGER RANDOMIZE
        ////////////////////
        */
        
        
        // Return when no sublayers found
        guard let sublayers = imageView.layer.sublayers else { return }
        
        sublayers.forEach { layer in
            self.animateRandomLayer(layer: layer,
                                    duration: K.Animation.animDuration,
                                    repeatDuration: K.Animation.animRepeatDuration)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + K.Animation.animFindWinnerAfter) {
            button.stopLoading() // Stop button loading animation when show result
            self.findWinner(sublayers)
        }
    }
    
    // Animation for all layers
    func animateRandomLayer(layer: CALayer, after: CFTimeInterval = 0.0, duration: CFTimeInterval, repeatDuration: CFTimeInterval) {
        let animation = CABasicAnimation(keyPath: "opacity")
        
        animation.fromValue = 1.0
        animation.toValue = 0.1
        animation.duration = duration
        animation.beginTime = CACurrentMediaTime() + after
        animation.fillMode = .removed
        animation.repeatDuration = repeatDuration
        
        layer.add(animation, forKey: nil)
    }
    
    func findWinner(_ layers: [CALayer]) {
        let randomIndex = Int.random(in: 0..<layers.count)
        layers.forEach { layer in
            if layer != layers[randomIndex] {
                layer.opacity = 0.0
            } else {
                animateRandomLayer(layer: layer,
                                   duration: K.Animation.animFindWinnerDuration,
                                   repeatDuration: K.Animation.animFindWinnerRepeatDuration)
            }
        }
        
        // Once the function is called, set winnerFound to true
        winnerFound = true
    }
    
    // Check if ImageView is not null
    func isValidImage(img: UIImageView) -> Bool {
        
        if (imageView.image == nil) { return false }
        
        if usedImages.contains(img.image!.description) {
            return false
        } else {
            usedImages.append(img.image!.description)
            winnerFound = false
            return true
        }
        
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
            
            // Determine scale of the image in ImageView
            let imageRect = self.determineScale(cgImage: cgImage, imageViewFrame: self.imageView.frame)
            
            self.imageView.layer.sublayers = nil
            
            // Each result is equal to a face in the image
            if let results = request?.results as? [VNFaceObservation] {
                results.forEach { (observation) in
                    let faceRect = self.convertUnitToPoint(originalImageRect: imageRect, targetRect: observation.boundingBox)
                    
                    let emojiRect = CGRect(x: faceRect.origin.x,
                                           y: faceRect.origin.y + faceRect.size.height, // emoji starts from the chin
                                           width: faceRect.size.width * 2,
                                           height: faceRect.size.height * 2)
                    
                    let textLayer = CATextLayer()
                    textLayer.string = K.Layer.layerEmoji // Mofify the emoji in the Constants file
                    textLayer.fontSize = faceRect.width
                    textLayer.shadowColor = K.Layer.layerShadowColor
                    textLayer.shadowRadius = K.Layer.layerShadowRadius
                    textLayer.shadowOpacity = K.Layer.layerShadowOpacity
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
                    self.createRandomizeButton()
                    
                } else { // Error occured when getting image
                    
                    if self.imageView.image != nil {
                        self.createRandomizeButton()
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
            self.createRandomizeButton()
            
        } else { // Error occured when getting image
            
            if self.imageView.image != nil {
                self.createRandomizeButton()
            }
            
        }
        
    }
}
