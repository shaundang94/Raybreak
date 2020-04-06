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
    
    var scene: Scene?
    var plane: Plane!
    
    var pipelineState: MTLRenderPipelineState?
    
    
    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()
        plane = Plane(device: device)
        super.init()
        buildPipelineState()
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
        
        //对顶点位置和颜色进行描述
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        
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
            let indexBuffer = plane.indexBuffer,
            let descriptor = view.currentRenderPassDescriptor else {
            return
        }
        plane.time +=  1 / Float(view.preferredFramesPerSecond) // preferredFramesPerSecond default is 60
        let animateBy = abs(sin(plane.time)/2 + 0.5)
        plane.constants.animateBy = animateBy
        
        let commandBuffer = commandQueue.makeCommandBuffer() //create command buffer to hold command encoder
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        commandEncoder?.setRenderPipelineState(pipelineState)
        commandEncoder?.setVertexBuffer(plane.vertexBuffer, offset: 0, index: 0)
        //commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count) // doesn't happen until all the commands are encoded
        commandEncoder?.setVertexBytes(&plane.constants,
                                       length: MemoryLayout<Plane.Constants>.stride,
                                       index: 1)
        commandEncoder?.drawIndexedPrimitives(type: .triangle,
                                              indexCount: plane.indices.count,
                                              indexType: .uint16,
                                              indexBuffer: indexBuffer,
                                              indexBufferOffset: 0)
        commandEncoder?.endEncoding() //finish encodeing all the commands
        commandBuffer?.present(drawable)
        commandBuffer?.commit() //send to GPU
    }
}
