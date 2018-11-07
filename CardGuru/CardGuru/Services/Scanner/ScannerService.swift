//
//  ScannerService.swift
//  CardGuru
//
//  Created by Vova on 10/17/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import Foundation
import AVFoundation

protocol ScannerServiceDelegate: class {
    func get(barcode: String)
}

final class ScannerService: NSObject {
    
    static let shared = ScannerService()
    private override init() {}
    
    var session: AVCaptureSession?
    weak var delegate: ScannerServiceDelegate?
    let queue = DispatchQueue(label: "com.CardGuru.camera.queue")
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private let supportedTypes = [ AVMetadataObject.ObjectType.upce,
                                   AVMetadataObject.ObjectType.code39,
                                   AVMetadataObject.ObjectType.code39Mod43,
                                   AVMetadataObject.ObjectType.code93,
                                   AVMetadataObject.ObjectType.code128,
                                   AVMetadataObject.ObjectType.ean8,
                                   AVMetadataObject.ObjectType.ean13
    ]
    
    func setupSession(with completion: ((Bool) -> ())) {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            session = AVCaptureSession()
            if let captureDevice = AVCaptureDevice.default(for: .video),
                let input = try? AVCaptureDeviceInput(device: captureDevice) {
                session?.addInput(input)
                let captureMetadataOutput = AVCaptureMetadataOutput()
                session?.addOutput(captureMetadataOutput)
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: queue)
                captureMetadataOutput.metadataObjectTypes = supportedTypes
                completion(true)
            }
        } else {
            completion(false)
        }
    }
    
    func setupVideoLayer() -> CALayer? {
        if let session = self.session {
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            return videoPreviewLayer
        }
        return nil
    }
}

// MARK: - Extensions

extension ScannerService: AVCaptureMetadataOutputObjectsDelegate {
    
    //MARK: - AVCaptureMetadataOutputObjectsDelegate
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count != 0 {
            
            guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
                supportedTypes.contains(metadataObject.type) else {
                    return
            }
            if let barcode = metadataObject.stringValue {
                self.delegate?.get(barcode: barcode)
                session?.stopRunning()
            }
        } else {
            print("scanning...")
        }
    }
}
