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
    
    //随着图形的增多，有很多重复的顶点，就涉及很多重复的工作
    var vertices: [Float] = [-1, 1, 0, //V0
                             -1, -1, 0, //V1
                             1, -1, 0, //V2
                             1, 1, 0, //V3
    ]
    var indices: [UInt16] = [ //为了减少顶点的传入（传给GPU），我们用索引矩阵。这里的索引矩阵描述了2个三角形和它们的绘制顺序。
        0, 1, 2,
        2, 3, 0
    ]
    var pipelineState: MTLRenderPipelineState?
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    struct Constants {
        var animateBy: Float = 0
    }
    var constants = Constants()
    var time: Float = 0 // how long the app's been running
    
    
    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()
        super.init()
        buildModel()
        buildPipelineState()
    }
    
    private func buildModel() {
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Float>.size, options: [])
        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt16>.size, options: [])
    }
    
    private func buildPipelineState() {
        //把shader存入library
        let library = device.makeDefaultLibrary()
        let vertexFunc = library?.makeFunction(name: "vertex_shader")
        let fragmentFunc = library?.makeFunction(name: "fragment_shader")
        
        //从PipelineDescriptor中生成PipelineState
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
            let indexBuffer = indexBuffer,
            let descriptor = view.currentRenderPassDescriptor else {
            return
        }
        time +=  1 / Float(view.preferredFramesPerSecond) // preferredFramesPerSecond default is 60
        let animateBy = abs(sin(time)/2 + 0.5)
        constants.animateBy = animateBy
        
        let commandBuffer = commandQueue.makeCommandBuffer() //create command buffer to hold command encoder
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        commandEncoder?.setRenderPipelineState(pipelineState)
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        //commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count) // doesn't happen until all the commands are encoded
        commandEncoder?.setVertexBytes(&constants, length: MemoryLayout<Constants>.stride, index: 1)
        commandEncoder?.drawIndexedPrimitives(type: .triangle, indexCount: indices.count, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0)
        commandEncoder?.endEncoding() //finish encodeing all the commands
        commandBuffer?.present(drawable)
        commandBuffer?.commit() //send to GPU
    }
}
