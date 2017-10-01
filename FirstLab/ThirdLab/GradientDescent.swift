//
//  GradientDescent.swift
//  FirstLab
//
//  Created by Filip Gulan on 13/11/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation

class GradientDescent: Optimizable {

    private let _epsilon: Double
    private var _lastCount: Int = 0

    var online: Bool
    var useNewtonRaphson: Bool

    init(epsilon: Double = Constants.Optimizable.Precision,
         online: Bool = false,
         useNewtonRaphson: Bool = false) {
        _epsilon = epsilon
        self.online = online
        self.useNewtonRaphson = useNewtonRaphson
    }

    var name: String { return "Gradient Descent" }

    func findMinimum(for function: Function, startPoint: [Double]) -> [Double] {
        guard let function = function as? DifferentiableFunction else {
            fatalError("Gradient Descent works only for differentiable function")
        }
        let gs = GoldenSection()

        var point = Matrix(elements: startPoint, rows: startPoint.count, columns: 1)
        var bestPoint = point.copy()
        while true {
            var dx: Matrix = (-1) * function.gradient(at: point)

            if useNewtonRaphson {
                let hessian = function.hessian(at: point)
                if let result = Solver.solve(input: hessian, resultVector: dx) {
                    dx = result
                }
            }

            if dx.norm() < _epsilon || _lastCount > 100 {
                break
            }

            if online {
//                dx = dx.normalize()
                let lambdaFunction = CustomFunction(function: { (lambda) -> Double in
                    return function[point + (lambda[0] * dx)]
                })
                let interval = gs.findMinimum(for: lambdaFunction, startPoint: [0])
                let lambda = (interval[0] + interval[1])/2
                point += (lambda * dx)
            } else {
                point += dx
            }
            if function[bestPoint] > function[point] {
                bestPoint = point
                _lastCount = 0
            } else {
                _lastCount += 1
            }
        }
        _lastCount = 0
        return point.elements
    }

    func findMinimum(for function: Function, interval: (left: Double, right: Double)) -> [Double] {
        fatalError("Gradient Descent doesn't support minimum interval.")
    }
}
