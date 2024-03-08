//
//  ViewController.swift
//  TextRecognition
//
//  Created by James Bates on 2023-10-16.
//

import Vision
import UIKit

class ViewController: UIViewController {
    
    // Define a UILabel to display recognized text
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 // Allow multiple lines
        label.textAlignment = .center // Center-align text
        label.text = "starting..." //Initial text
        return label
    }()
    
    // Define a UIImageView to display the image
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "example1") // Set initial image
        imageView.contentMode = .scaleAspectFit //Scale image to fit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Add label and imageView as subviews to the view controller's view
        view.addSubview(label)
        view.addSubview(imageView)
        
        // Perform text recognition on the image
        recognizeText(image: imageView.image)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Set frames for imageView and label after layout calculations
        imageView.frame = CGRect(x: 20, y: view.safeAreaInsets.top, width: view.frame.size.width-40, height: view.frame.size.width-40)
        label.frame = CGRect(x: 20, y: view.frame.size.width + view.safeAreaInsets.top, width: view.frame.size.width-40, height: 300)
    }

    // Function to recognize text in an image using Vision framework
    private func recognizeText(image: UIImage?) {
        guard let cgImage = image?.cgImage else{
            fatalError("could not get CGImage") } // Exit if there's no CGImage
        
        // Create a handler for the CGImage
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        // Create a text recognition request with a completion handler
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else{
                return
            }
            
            // Extract text from the top candidate of each observation
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: ", ")
            
            // Update UI on the main thread
            DispatchQueue.main.async {
                self?.label.text = text
            }
        }
        
        // Perform the text recognition request
        do {
            try handler.perform([request])
        }
        catch {
            // Hanndle errors - print(error)
            label.text = "\(error)"
        }
        
    }

}

