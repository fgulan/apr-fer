//
//  CoordinateDescent.swift
//  FirstLab
//
//  Created by Filip Gulan on 31/10/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation

class CoordinateDescent: Optimizable {

    private let e: Double
    init(precision: Double = Constants.Optimizable.Precision) {
        e = precision
    }

    var name: String { return "Koordinatni spust" }

    func findMinimum(for function: Function, startPoint: [Double]) -> [Double] {
        let n = startPoint.count
        var x = Matrix(elements: startPoint, rows: n, columns: 1)

        let goldenSection = GoldenSection(verbose: false)
        var lambda = 0.0
        var xOld = x.copy()
        repeat {
            xOld = x.copy()
            for i in 0..<n {
                let lambdaFunction = CustomFunction(function: { (elements) -> Double in
                    let lambda = elements[0]
                    x[i, 0] += lambda
                    let result = function.value(at: x)
                    x[i, 0] -= lambda
                    return result
                })
                let interval = goldenSection.findMinimum(for: lambdaFunction, startPoint: [0])
                lambda = (interval[0] + interval[1])/2
                x[i, 0] += lambda
            }
        } while (x - xOld).norm() > e
        return x.elements
    }

    func findMinimum(for function: Function, interval: (left: Double, right: Double)) -> [Double] {
        fatalError("Coordinate descent is not supported for interval search")
    }
}
