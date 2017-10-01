//
//  Matrix.swift
//  Matrix
//
//  Created by Filip Gulan on 05/10/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation
import Accelerate

enum MatrixError: Error {
    case InvalidDimension(String?)
}

public struct Matrix: Hashable {
    static let epsilon: Double = 1e-9
    private var _elements = [Double]()

    public var hashValue: Int {
        return _elements.count
    }

    // MARK: - Public properties -
    let rows: Int
    let columns: Int
    var elements: [Double] { return _elements }
    var isSquare: Bool { return rows == columns }

    init(rows: Int, columns: Int) {
        self.init(repeating: 0.0, rows: rows, columns: columns)
    }

    init(elements: [Double], rows: Int, columns: Int) {
        guard elements.count > 0 else {
            fatalError("Matrix cannot be empty")
        }
        self.rows = rows
        self.columns = columns
        _elements = elements
    }

    init(repeating: Double, rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        self._elements = [Double](repeating: repeating, count: rows * columns)
    }

    init(diagonal: Double, size: Int) {
        self.rows = size
        self.columns = size
        self._elements = [Double](repeating: 0.0, count: size * size)
        for i in 0..<size {
            self[i, i] = diagonal
        }
    }
    
    // MARK: - Subscript definition -
    
    public subscript(row: Int, column: Int) -> Double {
        get {
            return _elements[row * columns + column]
        }
        set {
            _elements[row * columns + column] = newValue
        }
    }

    public subscript(row: Int) -> [Double] {
        get {
            return [Double](_elements[(row * columns)..<(row * columns + columns)])
        }
        set {
            guard newValue.count == columns else {
                fatalError("Invalid row size!")
            }
            let offset = row * columns
            for i in 0..<newValue.count {
                _elements[offset + i] = newValue[i]
            }
        }
    }

    func copy() -> Matrix {
        return Matrix(elements: elements, rows: rows, columns: columns)
    }

    mutating func swapRows(first: Int, second: Int) {
        precondition(first < rows && second < rows, "Invalid index!")
        let secondRow = self[second]
        self[second] = self[first]
        self[first] = secondRow
    }

    func toString() -> String {
        var description = ""
        for i in 0..<rows {
            let contents = (0..<columns).map{"\(self[i, $0])"}.joined(separator: " ")
            description += "\(contents)\n"
        }
        return description.trimmingCharacters(in: ["\n"])
    }

    func lowerTriangularMatrix() throws -> Matrix {
        guard isSquare else {
            throw MatrixError.InvalidDimension("Lower triangular matrix is defined only for square matrix")
        }
        var result = self
        for i in 0..<rows {
            result[i, i] = 1
            for j in (i + 1)..<rows {
                result[i, j] = 0
            }
        }
        return result
    }

    func upperTriangularMatrix() throws -> Matrix {
        guard isSquare else {
            throw MatrixError.InvalidDimension("Lower triangular matrix is defined only for square matrix")
        }
        var result = self
        for i in 1..<rows {
            for j in 0..<i {
                result[i, j] = 0
            }
        }
        return result
    }


    func norm() -> Double {
        var sum: Double = 0.0
        for i in 0..<rows {
            for j in 0..<columns {
                sum += self[i, j] * self[i, j]
            }
        }
        return sqrt(sum)
    }

    func normalize() -> Matrix {
        let norm = self.norm()
        var result = self.copy()
        for i in 0..<rows {
            for j in 0..<columns {
                result[i, j] /= norm
            }
        }
        return result
    }
}

// MARK: - Printable -

extension Matrix: CustomStringConvertible {
    public var description: String {
        var description = ""
        for i in 0..<rows {
            let contents = (0..<columns).map{"\(self[i, $0])"}.joined(separator: " ")
            switch (i, rows) {
            case (0, 1):
                description += "\t\t( \(contents) )"
            case (0, _):
                description += "\t\t⎛ \(contents) ⎞"
            case (rows - 1, _):
                description += "\t\t⎝ \(contents) ⎠"
            default:
                description += "\t\t⎜ \(contents) ⎥"
            }
            description += "\n"
        }
        return description.trimmingCharacters(in: ["\n"])
    }
}

// MARK: - Equatable -

public func ==(lhs: Matrix, rhs: Matrix) -> Bool {
    guard lhs.rows == rhs.rows && lhs.columns == rhs.columns else {
        return false
    }
    for i in 0..<lhs.rows {
        for j in 0..<lhs.columns {
            if fabs(lhs[i, j].distance(to: rhs[i, j])) > Matrix.epsilon {
                return false
            }
        }
    }
    return true
}

// MARK: - Operators

// Using accelerate framework
func *(lhs: Matrix, rhs: Matrix) -> Matrix {
    precondition(lhs.columns == rhs.rows, "Left side matrix columns count must be equal to right side matrix rows count.")
    var elements = [Double](repeating: 0.0, count: lhs.rows * rhs.columns)
    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans,
                Int32(lhs.rows), Int32(rhs.columns),
                Int32(lhs.columns), 1.0, lhs.elements,
                Int32(lhs.columns), rhs.elements,
                Int32(rhs.columns), 0.0,
                &(elements), Int32(rhs.columns))
    return Matrix(elements: elements, rows: lhs.rows, columns: rhs.columns)
}

func *(lhs: Double, rhs: Matrix) -> Matrix {
    var result = Matrix(rows: rhs.rows, columns: rhs.columns)
    for i in 0..<result.rows {
        for j in 0..<result.columns {
            result[i, j] = lhs * rhs[i, j]
        }
    }
    return result
}

func /(lhs: Matrix, rhs: Matrix) -> Matrix {
    precondition(lhs.columns == rhs.rows, "Left side matrix columns count must be equal to right side matrix rows count.")
    var result = Matrix(rows: lhs.rows, columns: rhs.columns)
    for i in 0..<result.rows {
        for j in 0..<result.columns {
            result[i, j] = (0..<lhs.columns).reduce(0.0, {$0 + lhs[i, $1] * rhs[$1, j] })
        }
    }
    return result
}

func +(lhs: Matrix, rhs: Matrix) -> Matrix {
    precondition(lhs.columns == rhs.columns && lhs.rows == rhs.rows, "Matrix dimensions are not the same")
    var result = Matrix(rows: lhs.rows, columns: lhs.columns)
    for i in 0..<result.rows {
        for j in 0..<result.columns {
            result[i, j] = lhs[i, j] + rhs[i, j]
        }
    }
    return result
}

func -(lhs: Matrix, rhs: Matrix) -> Matrix {
    precondition(lhs.columns == rhs.columns && lhs.rows == rhs.rows, "Matrix dimensions are not the same")
    var result = Matrix(rows: lhs.rows, columns: lhs.columns)
    for i in 0..<result.rows {
        for j in 0..<result.columns {
            result[i, j] = lhs[i, j] - rhs[i, j]
        }
    }
    return result
}

func +=(lhs: inout Matrix, rhs: Matrix) {
    precondition(lhs.columns == rhs.columns && lhs.rows == rhs.rows, "Matrix dimensions are not the same")
    for i in 0..<lhs.rows {
        for j in 0..<lhs.columns {
            lhs[i, j] = lhs[i, j] + rhs[i, j]
        }
    }
}

func -=(lhs: inout Matrix, rhs: Matrix) {
    precondition(lhs.columns == rhs.columns && lhs.rows == rhs.rows, "Matrix dimensions are not the same")
    for i in 0..<lhs.rows {
        for j in 0..<lhs.columns {
            lhs[i, j] = lhs[i, j] - rhs[i, j]
        }
    }
}

postfix operator ^
postfix func ^(lhs: Matrix) -> Matrix? {
    precondition(lhs.columns == lhs.rows, "Matrix is not square!")

    var lu = lhs.copy()
    var decomposer = LUPDecomposer()
    let size = lhs.rows
    do {
        _ = try decomposer.decompose(matrix: &lu)
        let permutation = decomposer.permutationMatrix
        var inv = Matrix(diagonal: 1.0, size: size)
        for i in 0..<size {
            var vector = Matrix(repeating: 0.0, rows: size, columns: 1)
            vector[i, 0] = 1.0
            let forwardSubs = try lu.substituteForward(with: permutation * vector)
            let backwardSubs = try lu.substituteBackward(with: forwardSubs)
            for j in 0..<size {
                inv[j, i] = backwardSubs[j, 0]
            }
        }
        return inv
    } catch _ {
        return nil
    }
}

postfix operator ~
postfix func ~(lhs: Matrix) -> Matrix {
    var result = Matrix(rows: lhs.columns, columns: lhs.rows)
    for i in 0..<result.rows {
        for j in 0..<result.columns {
            result[i, j] = lhs[j, i]
        }
    }
    return result
}

prefix operator -
prefix func -(lhs: Matrix) -> Matrix {
    var result = Matrix(rows: lhs.rows, columns: lhs.columns)
    for i in 0..<result.rows {
        for j in 0..<result.columns {
            result[i, j] = -result[i, j]
        }
    }
    return result
}

