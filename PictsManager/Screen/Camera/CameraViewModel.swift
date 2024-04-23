//
//  CameraViewModel.swift
//  PictsManager
//
//  Created by Stevens on 19/03/2024.
//

import SwiftUI
import Foundation
import AVFoundation
import OSLog

class CameraViewModel {

    var session: AVCaptureSession?
    var delegate: AVCapturePhotoCaptureDelegate?
    
    let output = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    func start(delegate: AVCapturePhotoCaptureDelegate, completion: @escaping (Error?) -> ()) {
        self.delegate = delegate
        checkPermissions(completion: completion)
    }
    
    private func checkPermissions(completion: @escaping (Error?) -> ()) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self?.setupCamera(completion: completion)
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera(completion: completion)
        @unknown default:
            break
        }
    }
    
    private func setupCamera(completion: @escaping (Error?) -> ()) {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }

                if session.canAddOutput(output) {
                    session.addOutput(output)
                }

                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session

                DispatchQueue.global().async {
                    session.startRunning()
                    DispatchQueue.main.async {
                        self.session = session
                    }
                }
            } catch {
                completion(error)
            }
        }
    }

    func switchCamera() {
        guard let currentCameraInput: AVCaptureInput = session?.inputs.first else {
            return
        }

        session?.beginConfiguration()
        defer { session?.commitConfiguration() }

        session?.removeInput(currentCameraInput)

        if let input = currentCameraInput as? AVCaptureDeviceInput {
            let newCameraDevice = input.device.position == .back ? getCamera(with: .front) : getCamera(with: .back)
            let newVideoInput = try? AVCaptureDeviceInput(device: newCameraDevice!)
            if session?.canAddInput(newVideoInput!) == true {
                session?.addInput(newVideoInput!)
            } else {
                print("Impossible d'ajouter l'entrée pour la nouvelle caméra")
                session?.addInput(currentCameraInput)
            }
        }
    }

    func getCamera(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified).devices
        for device in devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }


    
    func capturePhoto(with settings: AVCapturePhotoSettings = AVCapturePhotoSettings()) {
          output.capturePhoto(with: settings, delegate: self.delegate!)
      }
    
    
    func uploadImage(paramName: String, fileName: String, image: UIImage) {
        guard let url = URL(string: Api.Picture.uploadPicture) else {
            Logger.camera.error("Invalid URL")
            return
        }

        guard let imageData = image.pngData() else {
            Logger.camera.error("Image could not be converted to PNG data")
            return
        }

        let boundary = UUID().uuidString
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let token = UserSessionManager.shared.getToken()
        if token == nil {
            Logger.camera.error("Token is null")
            return
        }
        
        urlRequest.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(imageData)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        URLSession.shared.uploadTask(with: urlRequest, from: data) { responseData, response, error in
                    if let error = error {
                        Logger.camera.error("Failed to upload image: \(error)")
                    } else if let jsonData = responseData, let json = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
                        Logger.camera.info("\(json)")
                    }
                }.resume()
    }
    
}
