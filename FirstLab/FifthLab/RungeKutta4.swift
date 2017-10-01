//
//  RungeKutta4.swift
//  FirstLab
//
//  Created by Filip Gulan on 07/01/2017.
//  Copyright © 2017 Filip Gulan. All rights reserved.
//

import Foundation

class RungeKutta4: DiffSolver {

    override func getNext(for xK: Matrix) -> Matrix? {
        let halfT = T / 2.0
        let m1 = (matrixA * xK) + matrixB
        let m2 = (matrixA * (xK + (halfT * m1))) + matrixB
        let m3 = (matrixA * (xK + (halfT * m2))) + matrixB
        let m4 = (matrixA * (xK + (T * m3))) + matrixB
        return xK + ((T / 6.0) * (m1 + (2 * m2) + (2 * m3) + m4))
    }
}
