//
//  Components.swift
//  RealityKit-UIPortal
//
//  Created by Guo Rui on 2/2/25.
//  Copyright © 2025 Apple. All rights reserved.
//

/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The app's custom components.
*/

import RealityKit
import RealityKitContent

struct PointOfInterestRuntimeComponent: Component {
    let attachmentTag: ObjectIdentifier
}

struct ControlledOpacityComponent: Component {
    var shouldShow: Bool = false
    
    func opacity(forSliderValue sliderValue: Float) -> Float {
        if !shouldShow {
            return 0.0
        } else {
            return sliderValue
        }
    }
}
