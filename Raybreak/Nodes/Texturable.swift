//
//  Texturable.swift
//  Raybreak
//
//  Created by shaund on 2020/4/6.
//  Copyright © 2020 demo. All rights reserved.
//

import MetalKit

protocol Texturable {
    var texture: MTLTexture? {get set}
}

extension Texturable {
    func setTexture(device: MTLDevice, imageName: String) -> MTLTexture? {
        let textureLoader = MTKTextureLoader(device: device)
        var texture: MTLTexture?
        let textureLoaderOptions: [MTKTextureLoader.Option: Any]
        if #available(iOS 10.0, *) {
            let origin = MTKTextureLoader.Origin.bottomLeft
            textureLoaderOptions = [MTKTextureLoader.Option.origin: origin]
        } else {
            textureLoaderOptions = [:]
        }
        if let textureURL = Bundle.main.url(forResource: imageName, withExtension: nil) {
            do {
                texture = try textureLoader.newTexture(URL: textureURL, options: textureLoaderOptions)
            } catch {
                print("texture not created")
            }
        }
        return texture
    }
}
