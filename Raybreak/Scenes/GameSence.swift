//
//  GameSence.swift
//  Raybreak
//
//  Created by shaund on 2020/4/6.
//  Copyright © 2020 demo. All rights reserved.
//

import MetalKit

class GameScene: Scene {
    var quad: Plane
    
    override init(device: MTLDevice, size: CGSize) {
        quad = Plane(device: device, imageName: "picture.png")
        super.init(device: device, size: size)
        add(childNode: quad)
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        quad.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
    }
}
