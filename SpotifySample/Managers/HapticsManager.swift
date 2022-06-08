//
//  HapticsManager.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/04/02.
//

import Foundation
import UIKit

final class HapticsManager {
    static let shared = HapticsManager()
    private init() {}
    
    public func vibrateForSelection(){
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
    
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType){
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
}
