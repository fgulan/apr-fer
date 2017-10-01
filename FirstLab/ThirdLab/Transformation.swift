//
//  Transformation.swift
//  FirstLab
//
//  Created by Filip Gulan on 02/12/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation


class Transformation: Optimizable {

    var name: String { return "Transformation" }

    private let _inequalities: [Function]
    private let _equations: [Function]

    private let _precision: Double
    private let _step: Double

    init(inequalities: [Function],
         equations: [Function],
         precision: Double = 1e-6,
         step: Double = 1.0) {

        _inequalities = inequalities
        _equations = equations
        _precision = precision
        _step = step
    }

    func findMinimum(for function: Function, startPoint: [Double]) -> [Double] {

        var t = _step
        let optMethod = HookeJeves()
        var start : Matrix = Matrix(elements: _getRealStartPoint(for: function, startPoint: startPoint),
                                    rows: startPoint.count, columns: 1)
        while true {
            let transformed = CustomFunction(function: { (x) -> Double in
                var value = function[x]
                for constraint in self._inequalities {
                    let cs = constraint[x]
                    value -= (1.0/t) * log2(cs)/M_LOG2E
                }
                for constraint in self._equations {
                    let cs = constraint[x]
                    value += t * cs * cs
                }
                return value
            })

            let nextPoint = optMethod.findMinimum(for: transformed, startPoint: start.elements)

            let next = Matrix(elements: nextPoint, rows: nextPoint.count, columns: 1)
            let dx = start - next
            if dx.norm() < _precision {
                return next.elements
            }
            start = next
            t *= 10
        }
    }

    private func _getRealStartPoint(for function: Function, startPoint: [Double]) -> [Double] {
        var newFunctions: [Function] = [Function]()
        for constraint in _inequalities {
            if constraint[startPoint] < 0 {
                newFunctions.append(constraint)
            }
        }
        if newFunctions.isEmpty {
            return startPoint
        }
        let newFunction = CustomFunction { (x) -> Double in
            var value = 0.0
            for fc in newFunctions {
                value -= fc[x]
            }
            if value > 0 {
                return value
            } else {
                return 0
            }
        }
        let hj = HookeJeves()
        let newPoint = hj.findMinimum(for: newFunction, startPoint: startPoint)
        print("\t\tDana pocetna tocka ne zadovoljava nejednadzbe. Nova tocka: \(newPoint)")
        return newPoint
    }

    func findMinimum(for function: Function, interval: (left: Double, right: Double)) -> [Double] {
        fatalError("Not supported")
    }

}
