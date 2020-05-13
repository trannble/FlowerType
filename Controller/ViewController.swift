//
//  ViewController.swift
//  FlowerType
//
//  Created by Tran Le on 5/7/20.
//  Copyright © 2020 TL Inc. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var flowerImageView: UIImageView!
    @IBOutlet weak var flowerDescription: UILabel!

    let imagePicker = UIImagePickerController()
    
    var wikiManager = WikiManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        
        wikiManager.delegate = self
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //info contains the image user picked
        
        //get image user has selected and convert to UIImage
        if let userImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            //set storyboard imageView as userImage
            flowerImageView.image = userImage
            
            guard let ciImage = CIImage(image: userImage) else {
                fatalError("Could not convert UIImage to CIImage")
            }
            
            detect(image: ciImage)

        }
        
        //dismiss imagePicker once picked
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: FlowerClassifier().model) else {
            fatalError("CoreML Flower Classifier Model failed to load")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            //gets first result (highest probability)
            guard let classification = request.results?.first as? VNClassificationObservation else {
                fatalError("Could not classify image.")
            }
            
            self.navigationItem.title = classification.identifier.capitalized
            
            self.wikiManager.fetchFlower(flowerName: classification.identifier)
                        
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
        try handler.perform([request])
        }
        catch {
            print(error)
        }
        
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil )
    }
    
}

//MARK: - WikiManagerDelegate

extension ViewController: WikiManagerDelegate {
    
    func didUpdateWiki(_ wiki: WikiManager, description: String) {
        
        //updates when information from Wikipedia updated
        DispatchQueue.main.async {
            self.flowerDescription.text = description
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
    
}

