//
//  MatrixSubstitution.swift
//  FirstLab
//
//  Created by Filip Gulan on 17/10/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation

extension Matrix {
    
    func substituteForward(with vector: Matrix) throws -> Matrix {
        guard isSquare, rows == vector.rows, vector.columns == 1 else {
            throw MatrixError.InvalidDimension(nil)
        }
        var result = vector
        for i in 0..<(rows - 1) {
            for j in (i + 1)..<rows {
                result[j, 0] -= self[j, i] * result[i, 0]
            }
        }
        return result
    }

    func substituteBackward(with vector: Matrix) throws -> Matrix {
        guard isSquare, rows == vector.rows, vector.columns == 1 else {
            throw MatrixError.InvalidDimension(nil)
        }
        var result = vector
        for i in (0..<rows).reversed() {
            result[i, 0] /= self[i, i]
            for j in (0..<i) {
                result[j, 0] -= self[j, i] * result[i, 0]
            }
        }
        return result
    }
}
