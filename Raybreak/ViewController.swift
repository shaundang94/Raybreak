//
//  ViewController.swift
//  Raybreak
//
//  Created by shaund on 2020/4/5.
//  Copyright © 2020 demo. All rights reserved.
//

import UIKit
import MetalKit

enum Colors {
    static let wenderlichGreen = MTLClearColor(red: 0, green: 0.4, blue: 0.21, alpha: 1)
}
class ViewController: UIViewController {
    var metalView: MTKView {
        return view as! MTKView
    }
    var renderer: Renderer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        metalView.device = MTLCreateSystemDefaultDevice() //create a refrence to the GPU
        renderer = Renderer(device: metalView.device!)
        metalView.clearColor = Colors.wenderlichGreen
        metalView.delegate = self.renderer
    }

}


