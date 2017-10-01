//
//  UnimodalInterval.swift
//  FirstLab
//
//  Created by Filip Gulan on 31/10/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation

func unimodalInterval(for function: Function, start: Double, step: Double) -> (left: Double, right: Double) {
    var left: Double = start - step
    var right: Double = start + step

    var f0: Double = function[[start]]
    var fLeft: Double = function[[left]]
    var fRight: Double = function[[right]]

    var temp: Double = start
    var k: UInt = 1

    if f0 < fRight && f0 < fLeft {
        return (left, right)
    } else if f0 > fRight {
        repeat {
            left = temp
            temp = right
            f0 = fRight
            k *= 2
            right = start + step * Double(k)
            fRight = function[[right]]
        } while f0 > fRight
    } else {
        repeat {
            right = temp
            temp = left
            f0 = fLeft
            k *= 2
            left = start - step * Double(k)
            fLeft = function[[left]]
        } while f0 > fLeft
    }
    return (left, right)
}
