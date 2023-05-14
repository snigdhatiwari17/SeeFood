//
//  ViewController.swift
//  SeeFood
//
//  Created by Snigdha Tiwari  on 13/05/23.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController() //new image picker controller object
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
      
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        //setup for image picker
        
    }
    
    //delegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage { //downcasting
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CI Image")
            }
            
            detect(image: ciimage)
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func detect(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading Coreml Model failed")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
           
            if let firstResults = results.first {
                if firstResults.identifier.contains("hotdog") {
                    self.navigationItem.title = "Hotdog!"
                } else {
                    self.navigationItem.title = "Not Hotdog!"
                }
            }
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
   

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil) //presents image picker to user
        
    }
    
}


