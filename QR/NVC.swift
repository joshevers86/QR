//
//  NVC.swift
//  QR
//
//  Created by Jose Navarro Alabarta on 28/2/18.
//  Copyright © 2018 Jose Navarro Alabarta. All rights reserved.
//

import UIKit

class NVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let vOrigen = sender as! VistaCamara
        //destino de la transicion
        let vc = segue.destination as! VC
        vOrigen.sesion?.stopRunning()
        vc.urls = vOrigen.urls
        
    }
    

}
