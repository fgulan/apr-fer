//
//  DiffSolver.swift
//  FirstLab
//
//  Created by Filip Gulan on 07/01/2017.
//  Copyright © 2017 Filip Gulan. All rights reserved.
//

import Foundation

typealias DiffResult = (point: Matrix, time: Double)

class DiffSolver {
    internal let matrixA: Matrix
    internal let matrixB: Matrix
    internal let matrixX0: Matrix
    internal let T: Double
    internal let tMax: Double
    internal let printIter: Int

    init(matrixA: Matrix, matrixB: Matrix, matrixX0: Matrix,
         T: Double, tMax: Double, printIter: Int) {
        self.matrixA = matrixA
        self.matrixB = matrixB
        self.matrixX0 = matrixX0
        self.T = T
        self.tMax = tMax
        self.printIter = printIter
    }

    func run() -> [DiffResult]? {
        var results = [DiffResult]()
        results.append(DiffResult(matrixX0, 0.0))

        var t = 0.0
        var iter: Int = 1

        while true {
            t += T
            if t > tMax {
                break
            }
            guard let nextX = getNext(for: results.last!.point) else {
                print("Unable to solve.")
                return nil
            }
            results.append(DiffResult(nextX, t))
            if iter % printIter == 0 {
                print("t = \(t), X_\(iter) =\n \(nextX)")
            }
            iter += 1
        }
        return results
    }

    func getNext(for xK: Matrix) -> Matrix? {
        fatalError("Abstract method")
    }
}
