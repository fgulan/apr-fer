//
//  Operators.swift
//  FirstLab
//
//  Created by Filip Gulan on 05/11/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation

precedencegroup ExponentiativePrecedence {
    associativity: left
    higherThan: MultiplicationPrecedence
}

infix operator **: ExponentiativePrecedence
func **(left: Double, right: Double) -> Double {
    return pow(left, right)
}

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

public extension Int {
    /// SwiftRandom extension
    public static func random(lower: Int = 0, _ upper: Int = 100) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
}

public extension Double {
    /// SwiftRandom extension
    public static func random(lower: Double = 0, _ upper: Double = 1) -> Double {
        return (Double(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }
}

public extension Float {
    /// SwiftRandom extension
    public static func random(lower: Float = 0, _ upper: Float = 1) -> Float {
        return (Float(arc4random_uniform(100)) / 0xFFFFFFFF) * (upper - lower) + lower
    }
}

public extension CGFloat {
    /// SwiftRandom extension
    public static func random(lower: CGFloat = 0, _ upper: CGFloat = 1) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
    }
}
