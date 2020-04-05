//
//  Renderer.swift
//  Raybreak
//
//  Created by shaund on 2020/4/5.
//  Copyright © 2020 demo. All rights reserved.
//

import MetalKit

class Renderer: NSObject {
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var vertices: [Float] = [0, 1, 0,
                             -1, -1, 0,
                             1, -1, 0]
    var pipelineState: MTLRenderPipelineState?
    var vertexBuffer: MTLBuffer?
    
    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()
        super.init()
        buildModel()
        buildPipelineState()
    }
    
    private func buildModel() {
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Float>.size, options: [])
    }
    
    private func buildPipelineState() {
        //把shader存入library
        let library = device.makeDefaultLibrary()
        let vertexFunc = library?.makeFunction(name: "vertex_shader")
        let fragmentFunc = library?.makeFunction(name: "fragment_shader")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunc
        pipelineDescriptor.fragmentFunction = fragmentFunc
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error as NSError {
            print("shaund> error:\(error.localizedDescription)")
        }
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { // is called whenever the view size changes
        
    }
    
    func draw(in view: MTKView) { // called every frame
        guard let drawable = view.currentDrawable,
            let pipelineState = pipelineState,
            let descriptor = view.currentRenderPassDescriptor else {
            return
        }
        let commandBuffer = commandQueue.makeCommandBuffer() //create command buffer to hold command encoder
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        commandEncoder?.setRenderPipelineState(pipelineState)
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count) // doesn't happen until all the commands are encoded
        commandEncoder?.endEncoding() //finish encodeing all the commands
        commandBuffer?.present(drawable)
        commandBuffer?.commit() //send to GPU
    }
}
