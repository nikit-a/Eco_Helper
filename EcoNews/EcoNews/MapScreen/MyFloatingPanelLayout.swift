//
//  MyFloatingPanelLayout.swift
//  EcoHelper
//
//  Created by Никита Ткаченко on 30.04.2021.
//

import Foundation
import FloatingPanel
class MyFloatingPanelLayout: FloatingPanelLayout {
    internal let position: FloatingPanelPosition = .bottom
    internal let initialState: FloatingPanelState = .tip
    internal var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 80.0, edge: .top, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 40.0, edge: .bottom, referenceGuide: .safeArea)
        ]
    }
}
