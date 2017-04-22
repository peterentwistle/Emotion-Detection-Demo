//
//  EmotionDetectable.swift
//  Emotion Detect
//
//  Created by Peter Entwistle on 22/04/2017.
//  Copyright © 2017 Peter Entwistle. All rights reserved.
//

protocol EmotionDetectable {
    
    func detectedEmotion(name: String, response: DetectedResult?)
    
}
