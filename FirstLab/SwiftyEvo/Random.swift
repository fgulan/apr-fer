//
//  Dice.swift
//  FirstLab
//
//  Created by Filip Gulan on 17/12/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation
import GameplayKit

public typealias Probability = Double

@inline(__always) public func coinFlip() -> Bool {
    return arc4random_uniform(2) == 0
}

@inline(__always) public func roll(probability: Probability) -> Bool {
    if (probability == 1.0) {
        return true
    } else if (probability == 0.0) {
        return false
    }

    let roll = randomP()
    return probability > roll
}

private var nextNextGaussian: Double? = {
    srand48(Int(arc4random())) //initialize drand48 buffer at most once
    return nil
}()

func nextGaussian() -> Double {
    if let gaussian = nextNextGaussian {
        nextNextGaussian = nil
        return gaussian
    } else {
        var v1, v2, s: Double

        repeat {
            v1 = 2 * drand48() - 1
            v2 = 2 * drand48() - 1
            s = v1 * v1 + v2 * v2
        } while s >= 1 || s == 0

        let multiplier = sqrt(-2 * log(s)/s)
        nextNextGaussian = v2 * multiplier
        return v1 * multiplier
    }
}

@inline(__always) func randomP() -> Probability {
    return random(from:0.0, to: 1.0)
}

@inline(__always) func random(from: Int, to: Int) -> Int {
    return from + Int(arc4random_uniform(UInt32(to-from)))
}

@inline(__always) func random(from:Float, to: Float) -> Float {
    return from + (to-from)*(Float(arc4random()) / Float(UInt32.max))
}

@inline(__always) func random(from:Double, to: Double) -> Double {
    return from + (to-from)*(Double(arc4random()) / Double(UInt32.max))
}

func pickRandom<T>(from array: Array<T>) -> T {
    return array[Int(arc4random_uniform(UInt32(array.count)))]
}

@inline(__always) func withProbability<Result>(probability: Probability, f: () -> Result) -> Result? {
    if roll(probability: probability) {
        return f()
    }

    return nil
}

@inline(__always) func chooseWithProbability<Result>(probability: Probability, f: () -> Result, g: () -> Result) -> Result {
    if roll(probability: probability) {
        return f()
    } else {
        return g()
    }
}
