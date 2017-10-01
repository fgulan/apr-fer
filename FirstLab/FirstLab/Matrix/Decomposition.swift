//
//  Decomposition.swift
//  FirstLab
//
//  Created by Filip Gulan on 17/10/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation

enum DecompositionError: Error {
    case ZeroElement
    case NonSquare
}

protocol Decomposition {
    mutating func decompose(matrix: inout Matrix) throws -> Matrix
    var permutationMatrix: Matrix { get }
    var name: String { get }
}

struct LUDecomposer: Decomposition {

    private var _size: Int?

    var permutationMatrix: Matrix {
        guard let size = _size else {
            fatalError("Decomposition is not performed!")
        }
        return Matrix(diagonal: 1.0, size: size)
    }

    var name: String {
        return "LU dekomp."
    }

    mutating func decompose(matrix: inout Matrix) throws -> Matrix {
        guard matrix.isSquare else {
            throw DecompositionError.NonSquare
        }
        _size = matrix.rows
        for i in 0..<matrix.rows - 1 {
            guard fabs(matrix[i, i]) > Matrix.epsilon else {
                throw DecompositionError.ZeroElement
            }
            for j in (i + 1)..<matrix.rows {
                matrix[j, i] /= matrix[i, i]
                for k in (i + 1)..<matrix.rows {
                    matrix[j, k] -= matrix[j, i] * matrix[i, k]
                }
            }
        }
        guard fabs(matrix[matrix.rows - 1, matrix.rows - 1]) > Matrix.epsilon else {
            throw DecompositionError.ZeroElement
        }
        return matrix
    }
}


struct LUPDecomposer: Decomposition {

    private var _p: Matrix?

    var permutationMatrix: Matrix {
        guard let p = _p else {
            fatalError("Decomposition is not performed!")
        }
        return p
    }

    var name: String {
        return "LUP dekomp."
    }

    mutating func decompose(matrix: inout Matrix) throws -> Matrix {
        guard matrix.isSquare else {
            throw DecompositionError.NonSquare
        }
        var p = Matrix(diagonal: 1.0, size: matrix.rows)
        for i in 0..<matrix.rows - 1 {
            var maxIndex = i
            for j in (i + 1)..<matrix.rows {
                if fabs(matrix[maxIndex, i]) < fabs(matrix[j, i]) {
                    maxIndex = j
                }
            }
            if maxIndex != i {
                p.swapRows(first: maxIndex, second: i)
                matrix.swapRows(first: maxIndex, second: i)
            }

            guard fabs(matrix[i, i]) > Matrix.epsilon else {
                throw DecompositionError.ZeroElement
            }
            for j in (i + 1)..<matrix.rows {
                matrix[j, i] /= matrix[i, i]
                for k in (i + 1)..<matrix.rows {
                    matrix[j, k] -= matrix[j, i] * matrix[i, k]
                }
            }
        }
        guard fabs(matrix[matrix.rows - 1, matrix.rows - 1]) > Matrix.epsilon else {
            throw DecompositionError.ZeroElement
        }
        _p = p
        return matrix
    }
}

