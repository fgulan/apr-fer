//
//  NelderMeadSimplex.swift
//  FirstLab
//
//  Created by Filip Gulan on 01/11/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation

class NelderMeadSimplex: Optimizable {

    private let _alpha: Double
    private let _beta: Double
    private let _gamma: Double
    private let _sigma: Double
    private let _e: Double
    var verbose: Bool
    var step: Double = 1.0

    var name: String { return "Nelder-Mead simplex" }

    init(alpha: Double = Constants.NelderMeadSimplex.Alpha,
         beta: Double = Constants.NelderMeadSimplex.Beta,
         gamma: Double = Constants.NelderMeadSimplex.Gamma,
         sigma: Double = Constants.NelderMeadSimplex.Sigma,
         epsilon: Double = Constants.Optimizable.Precision,
         verbose: Bool = false) {
        _alpha = alpha
        _beta = beta
        _gamma = gamma
        _sigma = sigma
        _e = epsilon
        self.verbose = verbose
    }

    func findMinimum(for function: Function, startPoint: [Double]) -> [Double] {
        let cache = function
        var points: [Matrix] = _generateSimplex(startPoint: startPoint, step: step)

        repeat {
            let (_, l, _, h) = _calculateMinMax(for: points, and: cache)
            let xC = _calculateCentroid(for: points, without: points[h])
            let fxC = cache[xC]

            _track("Centroid: \(xC.elements.map({ String(format: "%.4f", $0) })) => f(xC) = \(String(format: "%.4f", fxC))")

            let xR = _reflection(x: points, xC: xC, h: h)
            let fxR = cache[xR]
            if fxR < cache[points[l]] {
                let xE = _expansion(xC: xC, xR: xR)
                let fxE = cache[xE]
                points[h] = fxE < cache[points[l]] ? xE : xR
            } else {
                var notGood: Bool = true
                for i in 0..<points.count {
                    if i != h && fxR < cache[points[i]] {
                        notGood = false
                        break
                    }
                }

                if notGood {
                    if fxR < cache[points[h]] {
                        points[h] = xR
                    }
                    let xK = _contraction(x: points, xC: xC, h: h)
                    let fxK = cache[xK]
                    if fxK < cache[points[h]] {
                        points[h] = xK
                    } else {
                        for i in 0..<points.count {
                            if i != l {
                                points[i] += points[l]
                                points[i] = _sigma * points[i]
                            }
                        }
                    }
                } else {
                    points[h] = xR
                }
            }

            let sum = points.map({ (cache[$0] - fxC)**2 }).reduce(0.0, +) / Double(points.count)
            if sqrt(sum) <= _e {
                return xC.elements
            }
        } while true
    }

    func findMinimum(for function: Function, interval: (left: Double, right: Double)) -> [Double] {
        fatalError("Nelder-Mead simplex doesn't support minimum interval.")
    }

    private func _reflection(x: [Matrix], xC: Matrix, h: Int) -> Matrix {
        return ((1.0 + _alpha) * xC) - (_alpha * x[h])
    }

    private func _expansion(xC: Matrix, xR: Matrix) -> Matrix {
        return ((1.0 - _gamma) * xC) + (_gamma * xR)
    }

    private func _contraction(x: [Matrix], xC: Matrix, h: Int) -> Matrix {
        return ((1.0 - _beta) * xC) + (_beta * x[h])

    }

    private func _generateSimplex(startPoint: [Double], step: Double) -> [Matrix] {
        let dimension = startPoint.count
        let start = Matrix(elements: startPoint, rows: dimension, columns: 1)

        var points = (0..<dimension).map { (i) -> Matrix in
            var point = start.copy()
            point[i, 0] += step
            return point
        }
        points.append(start)
        return points
    }

    private func _calculateCentroid(for points: [Matrix], without point: Matrix) -> Matrix {
        let zero = Matrix(repeating: 0, rows: point.rows, columns: 1)
        return (1.0/Double(points.count - 1)) * (points.reduce(zero, +) - point)
    }

    private func _calculateMinMax(for points: [Matrix], and function: Function) -> (min: Double, l: Int, max: Double, h: Int) {
        var l: Int = 0
        var h: Int = 0
        var min: Double = function.value(at: points[l].elements)
        var max: Double = function.value(at: points[h].elements)

        for i in 1..<points.count {
            let value = function.value(at: points[i].elements)
            if value > max {
                max = value
                h = i
            } else if value < min {
                min = value
                l = i
            }
        }
        return (min, l, max, h)
    }

    private func _track(_ message: String) {
        if verbose {
            print(message)
        }
    }
}
