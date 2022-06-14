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
import Floaty

class RandomViewController: UIViewController {
    
    // Temp Timer for the randomize button effect
    private var tempTimerBtnEffect : Timer?

    @IBOutlet weak var imageView: UIImageView!
    
    private var imageOrientation = CGImagePropertyOrientation(.up)
    private var winnerFound = false
    private var isButtonRandomCreated = false
    private var usedImages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupFloaty()
    }
    
    //MARK: - Setup UI
    func setup() {
        guard let navBar = navigationController?.navigationBar else { return }
        
        // Create gradient color based on Chameleon
        let gradientColor = GradientColor(.topToBottom, frame: UIScreen.main.bounds, colors: Array(arrayLiteral: K.Palette.firstColor, K.Palette.secondColor, K.Palette.thirdColor))
        
        // Config NavBar
        navBar.tintColor = K.Palette.activeTextColor
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: K.Palette.activeTextColor,
                                      NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)]
        view.backgroundColor = gradientColor
        
        // Config UIImageView shadow
        imageView.customizeImageViewShadow()
    }
    
    func setupFloaty() {
        let floaty = Floaty()
        let itemTakePhotos = FloatyItem()
        let itemImportPhotos = FloatyItem()
        
        // Default Floaty
        floaty.size = self.view.frame.width * K.Button.FloatyButton.buttonScaleVsScreen
        floaty.paddingY = self.view.frame.height * K.Button.FloatyButton.buttonScaleVsScreen
        floaty.customizeFloaty()
        
        // Button config
        itemTakePhotos.size = floaty.size
        itemTakePhotos.customizeItem(title: "Take a photo",
                                     icon: UIImage(systemName: "camera.fill")!)
        
        itemImportPhotos.size = floaty.size
        itemImportPhotos.customizeItem(title: "Import from Photos",
                                       icon: UIImage(systemName: "photo.fill.on.rectangle.fill")!)
        
        // TODO: add button handler
        itemTakePhotos.handler = { (item) in
            self.prensentCameraPicker()
        }
        itemImportPhotos.handler = { (item) in
            self.presentLibraryPicker()
        }
        
        floaty.addItem(item: itemTakePhotos)
        floaty.addItem(item: itemImportPhotos)
        
        view.addSubview(floaty)
        
    }
    
    //MARK: - Randomize Button Functions
    func createRandomizeButton() {
        
        // Do not create if existed
        if (isButtonRandomCreated) { return }
        
        DispatchQueue.main.async { [weak self] in
            let buttonRandomize = LoadyButton()
            
            buttonRandomize.frame.size.width = K.Button.RandomButton.width
            buttonRandomize.frame.size.height = K.Button.RandomButton.height
            buttonRandomize.frame = CGRect(
                x: (self?.view.frame.size.width)!/2 - buttonRandomize.frame.size.width/2,
                y: (self?.view.frame.size.height)! * 0.75,
                width: buttonRandomize.frame.width,
                height: buttonRandomize.frame.height)
            
            // Loading Top-line effect
            buttonRandomize.setAnimation(LoadyAnimationType.topLine())
            buttonRandomize.loadingColor = UIColor.white
            
            // Apply customized setting for the button
            buttonRandomize.customizeRandomButton()
            buttonRandomize.addTarget(self, action: #selector(self?.buttonRandomizePressed(_:)), for: .touchUpInside)
            
            // Do not create button if it exists already
            self?.isButtonRandomCreated = true
            self?.view.addSubview(buttonRandomize)
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
        guard let sublayers = imageView.layer.sublayers else {
            button.stopLoading()
            return
            
        }
        
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
    
    //MARK: - Present Pickers
    
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
    
    //MARK: - Create alert with messages
    func showAlert(title: String, msg: String, actionTitle: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - PHPicker Delegate Method
extension RandomViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        // Dismiss the controller
        picker.dismiss(animated: true, completion: nil)
        
        for result in results {
            
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                
                // Bugs occured when the picker could not load the image
                // eg: optimized storage with iCloud case
                if error != nil {
                    DispatchQueue.main.async {
                        self.showAlert(title: "Error :(", msg: "Could not load image, please try with another one", actionTitle: "OK")
                    }
                    return
                }
                
                if let userPickedImage = object as? UIImage {
                    
                    // Do not put this in the async process
                    // the handler needs to know the image orientation to detect objects
                    self.imageOrientation = CGImagePropertyOrientation(userPickedImage.imageOrientation)
                    
                    // Use UIImage
                    DispatchQueue.main.async {
                        self.imageView.image = userPickedImage.withRoundedCorners()
                    }
                    
                    guard let cgImage = userPickedImage.cgImage else {
                        DispatchQueue.main.async {
                            self.showAlert(title: "Error :(", msg: "An error occured while processing the image, please try again.", actionTitle: "OK")
                        }
                        return
                    }
                    
                    // Detect Image
                    self.detectImage(with: cgImage)
                    self.createRandomizeButton()
                    
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
                self.imageView.image = userCapturedImage.withRoundedCorners()
            }
            
            guard let cgImage = userCapturedImage.cgImage else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error :(", msg: "An error occured while processing the image, please try again.", actionTitle: "OK")
                }
                return
            }
            
            // Detect Image
            self.detectImage(with: cgImage)
            self.createRandomizeButton()
            
        }
        
    }
}
