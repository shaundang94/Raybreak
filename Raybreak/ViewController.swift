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
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        metalView.device = MTLCreateSystemDefaultDevice() //create a refrence to the GPU
        metalView.clearColor = Colors.wenderlichGreen
        metalView.delegate = self
        device = metalView.device
        commandQueue = device.makeCommandQueue() //one command queue per app
        
    }

}

extension ViewController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { // is called whenever the view size changes
        
    }
    
    func draw(in view: MTKView) { // called every frame
        guard let drawable = view.currentDrawable,
            let descriptor = view.currentRenderPassDescriptor else {
            return
        }
        let commandBuffer = commandQueue.makeCommandBuffer() //create command buffer to hold command encoder
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        commandEncoder?.endEncoding() //finish encodeing all the commands
        commandBuffer?.present(drawable)
        commandBuffer?.commit() //send to GPU
    }
}
