//
//  Types.swift
//  Raybreak
//
//  Created by shaund on 2020/4/6.
//  Copyright © 2020 demo. All rights reserved.
//

import simd //import MetalKit时会自动导入simd，simd里面包含了这些浮点、矢量定义

struct Vertex {
    var position: SIMD3<Float>
    var color: SIMD4<Float>
    var texture: SIMD2<Float>
}
