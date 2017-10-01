//
//  Trapezoidal.swift
//  FirstLab
//
//  Created by Filip Gulan on 07/01/2017.
//  Copyright © 2017 Filip Gulan. All rights reserved.
//

import Foundation

class Trapezoidal: DiffSolver {
    private var R: Matrix?
    private var S: Matrix?

    override init(matrixA: Matrix, matrixB: Matrix, matrixX0: Matrix, T: Double, tMax: Double, printIter: Int) {
        super.init(matrixA: matrixA, matrixB: matrixB, matrixX0: matrixX0, T: T, tMax: tMax, printIter: printIter)
        let identity = Matrix(diagonal: 1.0, size: matrixA.rows)
        let A_ = (T/2.0) * matrixA
        let tmp1 = identity - A_
        let tmp2 = identity + A_
        if let inv = tmp1^ {
            R = inv * tmp2
            S = (T/2.0) * (inv * matrixB)
        }
    }

    override func getNext(for xK: Matrix) -> Matrix? {
        guard let R = R, let S = S else {
            return nil
        }
        return (R * xK) + S
    }
}
