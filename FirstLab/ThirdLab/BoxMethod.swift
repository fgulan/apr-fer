//
//  BoxMethod.swift
//  FirstLab
//
//  Created by Filip Gulan on 16/11/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation

enum BoxError: Error {
    case Constraints
}
typealias ExplicitConstraint = (bottom: Matrix, top: Matrix)
typealias ImplicitConstraint = (Matrix) -> Bool

class BoxMethod: Optimizable {

    var name: String { return "Box" }

    private let _implicit: ImplicitConstraint
    private let _explicit: ExplicitConstraint
    private let _precision: Double
    private let _alpha: Double

    init(explicit: ExplicitConstraint, implicit: @escaping (Matrix) -> Bool,
         precision: Double = 1e-6, alpha: Double = 1.3) {
        _explicit = explicit
        _implicit = implicit
        _precision = precision
        _alpha = alpha
    }

    func findMinimum(for function: Function, startPoint: [Double]) -> [Double] {
        let start: Matrix = Matrix(elements: startPoint, rows: startPoint.count, columns: 1)
        if !_satisfyExplicit(point: start) || !_implicit(start) {
            print("Pocetna tocka ne zadovoljava implicitna ni eksplicitna ogranicenja.")
            return [Double(NSNotFound)]
        }
        var simplex = _constructBox(from: start)
        var bestCentroid: Matrix = start
        var callCount = 0
        repeat {
            let (h, h2) = _getMaximumIndexes(for: simplex, and: function)
            let xC = _calculateCentroid(for: simplex, without: simplex[h])
            var xR = _reflection(xH: simplex[h], xC: xC)

            // Pomakni prema eksplicitnim granicama
            for i in 0..<xR.rows {
                if xR[i, 0] < _explicit.bottom[i, 0] {
                    xR[i, 0] = _explicit.bottom[i, 0]
                } else if xR[i, 0] > _explicit.top[i, 0] {
                    xR[i, 0] = _explicit.top[i, 0]
                }
            }
            while !_implicit(xR) {
                xR = 0.5 * (xR + xC)
            }
            if function[xR] > function[simplex[h2]] {
                xR = 0.5 * (xR + xC)
            }
            simplex[h] = xR


            let fxC = function[xC]
            let sum = simplex.map({ (function[$0] - fxC)**2 }).reduce(0.0, +) / Double(simplex.count)
            if sqrt(sum) <= _precision || callCount > 10000 {
                return xC.elements
            }

            if fxC < function[bestCentroid] {
                bestCentroid = xC
                callCount = 0
            } else {
                callCount += 1
            }
        } while true
    }

    private func _constructBox(from startPoint: Matrix) -> [Matrix] {
        let n = startPoint.rows
        let k = 2 * n

        var centroid = startPoint.copy()
        var points: [Matrix] = []
        points.append(centroid)
        for _ in 1..<k {
            var point = Matrix.random(with: _explicit, dimension: n)
            while !_implicit(point) {
                point = 0.5 * (point + centroid)
            }
            points.append(point)
            centroid = _calculateCentroid(for: points)
        }
        return points
    }

    private func _calculateCentroid(for points: [Matrix], without point: Matrix) -> Matrix {
        let zero = Matrix(repeating: 0, rows: point.rows, columns: 1)
        return (1.0/Double(points.count - 1)) * (points.reduce(zero, +) - point)
    }

    private func _calculateCentroid(for points: [Matrix]) -> Matrix {
        let zero = Matrix(repeating: 0, rows: points[0].rows, columns: 1)
        return (1.0/Double(points.count)) * (points.reduce(zero, +))
    }

    private func _reflection(xH: Matrix, xC: Matrix) -> Matrix {
        return ((1.0 + _alpha) * xC) - (_alpha * xH)
    }

    private func _getMaximumIndexes(for points: [Matrix], and function: Function) -> (h: Int, h2: Int) {
        var h: Int = 0
        var max: Double = function.value(at: points[h].elements)

        var h2: Int = 1
        var max2: Double = function.value(at: points[h2].elements)

        for i in 1..<points.count {
            let value = function.value(at: points[i].elements)
            if value > max {
                max2 = max
                h2 = h
                max = value
                h = i
            } else if value > max2 {
                max2 = value
                h2 = i
            }
        }
        return (h, h2)
    }

    private func _satisfyExplicit(point: Matrix) -> Bool {
        for i in 0..<point.rows {
            if point[i, 0] > _explicit.top[i, 0] || point[i, 0] < _explicit.bottom[i, 0] {
                return false
            }

        }
        return true
    }
    func findMinimum(for function: Function, interval: (left: Double, right: Double)) -> [Double] {
        fatalError("Unsupported")
    }
}

extension Matrix {
    static func random(with constraint: ExplicitConstraint, dimension: Int) -> Matrix {
        let offset = constraint.top - constraint.bottom
        let matrix = constraint.bottom + (Double.random() * offset)
        return matrix
    }
}
