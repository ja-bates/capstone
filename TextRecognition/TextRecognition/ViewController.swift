import UIKit
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "starting..."
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton()
        button.setTitle("Take Picture", for: .normal)
        button.backgroundColor = .systemBlue

        button.addTarget(self, action: #selector(didTapTakePicture), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(label)
        view.addSubview(imageView)
        view.addSubview(cameraButton)
        

        //cameraButton.frame = CGRect(x: 20, y: label.frame.maxY + 20, width: view.frame.size.width - 40, height: 50)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = view.frame.size.width - 40
        imageView.frame = CGRect(x: 20, y: view.safeAreaInsets.top, width: size, height: size)
        label.frame = CGRect(x: 20, y: imageView.frame.maxY + 20, width: size, height: 100)
        cameraButton.frame = CGRect(x: 20, y: label.frame.maxY + 20, width: size, height: 50)
    }

    @objc private func didTapTakePicture() {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = false
            present(picker, animated: true)
        } else {
            print("Camera not available")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        imageView.image = image
        recognizeText(image: image)
    }
    
    private func recognizeText(image: UIImage?) {
        guard let cgImage = image?.cgImage else {
            fatalError("could not get CGImage")
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
            }
            
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: ", ")
            
            DispatchQueue.main.async {
                self?.label.text = text
                // Send the recognized text to the server
                self?.sendTextToServer(text: text)
            }
        }
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
    //POST data to server
    private func sendTextToServer(text: String) {
        guard let url = URL(string: "http://172.20.10.8:50000") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = text.data(using: .utf8)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending text to server: \(error)")
                return
            }
            
            // Handle the response from the server here, if necessary
            if let response = response as? HTTPURLResponse {
                print("Server response: \(response.statusCode)")
            }
        }
        
        task.resume()
    }
}

