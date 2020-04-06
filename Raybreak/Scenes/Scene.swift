//
//  Scene.swift
//  Raybreak
//
//  Created by shaund on 2020/4/6.
//  Copyright © 2020 demo. All rights reserved.
//

import MetalKit


class Scene: Node {
    var device: MTLDevice
    var size: CGSize
    var node: Node?
    
    init(device: MTLDevice, size: CGSize) {
        self.device = device
        self.size = size
    }
    
    override func add(childNode: Node) {
        self.node = childNode
    }
}
