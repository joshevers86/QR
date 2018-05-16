//
//  ViewController.swift
//  QR
//
//  Created by Jose Navarro Alabarta on 19/2/18.
//  Copyright © 2018 Jose Navarro Alabarta. All rights reserved.

import UIKit
import AVFoundation

class VistaCamara: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var sesion : AVCaptureSession? = nil
    var capa: AVCaptureVideoPreviewLayer? = nil
    var marcoQR : UIView? = nil
    var urls : String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Esto es para eliminar en el boton de retorno el texto Back
        self.title = "QR Principal"
        
        
        let dispositivo = AVCaptureDevice.default(for: AVMediaType.video)
        do {
            
            let entrada = try AVCaptureDeviceInput(device: dispositivo!)
            sesion = AVCaptureSession()
            sesion?.sessionPreset = AVCaptureSession.Preset.photo
            sesion?.addInput(entrada)
            
            let metaDatos = AVCaptureMetadataOutput()
            sesion?.addOutput(metaDatos)
            metaDatos.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDatos.metadataObjectTypes = [.qr]
            capa = AVCaptureVideoPreviewLayer(session: sesion!)
            capa?.frame = view.layer.bounds
            capa?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            capa?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            //agregar la capa de la vista
            view.layer.addSublayer(capa!)
            marcoQR = UIView()
            marcoQR?.layer.borderWidth = 3
            marcoQR?.layer.borderColor = UIColor.red.cgColor
            view.addSubview(marcoQR!)
            
            sesion?.startRunning()
        }catch {
            
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        marcoQR?.frame = CGRect.zero
        if (metadataObjects.isEmpty || metadataObjects.count == 0) {
            return
        }
        
        let objMetadato = metadataObjects.first as? AVMetadataMachineReadableCodeObject
        if objMetadato?.type == .qr {
            let objetoBordes =  capa?.transformedMetadataObject(for: objMetadato! )
            marcoQR?.frame = (objetoBordes?.bounds)!
            if(objMetadato?.stringValue != nil) {
                self.urls = objMetadato?.stringValue
                print("Lectura QR: \(String(describing: self.urls!))")
                
                //AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                //esto pasa a la siguiente vista automaticamente?
                let navegacionControler = self.navigationController
                navegacionControler?.performSegue(withIdentifier: "detalles", sender: self)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !(sesion?.isRunning)! {
            sesion?.startRunning()
            marcoQR?.frame = CGRect.zero
        }
    }
    
   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

