//
//  HookeJeves.swift
//  FirstLab
//
//  Created by Filip Gulan on 01/11/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation

class HookeJeves: Optimizable {

    private let _precision: Double
    private let _dx: Double
    var verbose: Bool

    init(precision: Double = Constants.Optimizable.Precision,
         initialStep: Double = Constants.HookeJeves.InitialStep,
         verbose: Bool = false) {
        _precision = precision
        _dx = initialStep
        self.verbose = verbose
    }

    var name: String { return "Hooke-Jeves" }

    func findMinimum(for function: Function, startPoint: [Double]) -> [Double] {
        let cache = CacheFunction(function: function)
        var start: Matrix = Matrix(elements: startPoint, rows: startPoint.count, columns: 1)
        var base = start.copy()
        var dx = _dx
        repeat {
            let new = _explore(input: start, dx: dx, f: cache)

            _track("bazna: \(base.elements) => \(cache[base])")
            _track("pocetna: \(start.elements) => \(cache[start])")
            _track("nova: \(new.elements) => \(cache[new])")

            if cache[new] < cache[base] {
                start = (2 * new) - base
                base = new
            } else {
                dx /= 2.0
                start = base.copy()
            }
        } while dx >= _precision
        
        return base.elements
    }

    private func _explore(input: Matrix, dx: Double, f: Function) -> Matrix {
        var x = input.copy()
        for i in 0..<x.rows {
            let p = f[x]
            x[i, 0] += dx
            var n = f[x]

            if n > p {
                x[i, 0] -= 2 * dx
                n = f[x]
                if n > p {
                    x[i, 0] += dx
                }
            }
        }
        return x
    }

    func findMinimum(for function: Function, interval: (left: Double, right: Double)) -> [Double] {
        fatalError("")
    }

    private func _track(_ message: String) {
        if verbose {
            print(message)
        }
    }
}
