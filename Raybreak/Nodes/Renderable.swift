//
//  Renderable.swift
//  Raybreak
//
//  Created by shaund on 2020/4/6.
//  Copyright © 2020 demo. All rights reserved.
//

import MetalKit

protocol Renderable {
    var pipelineState: MTLRenderPipelineState! { get }
    var fragmentFunctionName: String { get }
    var vertexFunctionName: String { get }
    var vertexDescriptor: MTLVertexDescriptor { get }
}
