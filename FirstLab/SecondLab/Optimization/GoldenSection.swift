//
//  GoldenSection.swift
//  FirstLab
//
//  Created by Filip Gulan on 31/10/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation

class GoldenSection: Optimizable {

    private let e: Double
    var verbose: Bool

    init(precision: Double = Constants.Optimizable.Precision, verbose: Bool = false) {
        e = precision
        self.verbose = false
    }

    var name: String { return "Zlatni rez" }

    func findMinimum(for function: Function, startPoint: [Double]) -> [Double] {
        guard startPoint.count == 1 else {
            fatalError("Golden section method works only for one-variable functions")
        }
        let interval = unimodalInterval(for: function, start: startPoint[0], step: Constants.GoldenSection.Step)
        return findMinimum(for: function, interval: interval)
    }

    func findMinimum(for function: Function, interval: (left: Double, right: Double)) -> [Double] {
        let f = function
        let k: Double = Constants.GoldenSection.Ratio
        var a: Double = interval.left
        var b: Double = interval.right
        var c: Double = b - k * (b - a)
        var d: Double = a + k * (b - a)

        var fC = f[[c]]
        var fD = f[[d]]

        while b - a > e {
            _track("a: \(a) => \(f[[a]])")
            _track("c: \(c) => \(f[[c]])")
            _track("d: \(d) => \(f[[d]])")
            _track("b: \(b) => \(f[[b]])")

            if fC < fD {
                b = d
                d = c
                c = b - k * (b - a)
                fD = fC
                fC = f[[c]]
            } else {
                a = c
                c = d
                d = a + k * (b - a)
                fC = fD
                fD = f[[d]]
            }
        }
        return [a, b]
    }

    private func _track(_ message: String) {
        if verbose {
            print(message)
        }
    }
}
