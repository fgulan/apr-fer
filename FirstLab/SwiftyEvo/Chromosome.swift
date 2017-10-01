//
//  Chromosome.swift
//  FirstLab
//
//  Created by Filip Gulan on 17/12/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation

public final class DoubleChromosome: IndividualType {

    public var point: Matrix
    public var fitness: Double

    init(point: Matrix, fitness: Double) {
        self.point = point
        self.fitness = fitness
    }
}

public final class BinaryChromosome: IndividualType {

    static var oneChar: Character = Character("1")
    static var zeroChar: Character = Character("0")

    public var point: Matrix {
        get {
            return convertBinaryToMatrix(points: binaryPoint, length: length, top: top, bottom: bottom)
        }
        set {
            binaryPoint = convertMatrixToBinary(matrix: newValue, length: length, top: top, bottom: bottom)
        }
    }
    public var fitness: Double

    var top: Double
    var bottom: Double

    var binaryPoint: [Int]
    var dimension: Int
    var length: Int

    init(precision: Int, dimension: Int, top: Double, bottom: Double) {
        self.dimension = dimension
        self.length = Int(log(floor(1.0 + (top - bottom) * pow(10.0, Double(precision)))) / log(2)) + 1;
        self.binaryPoint = []
        let maxValue: Int = Int(powf(2, Float(self.length))) - 1
        for _ in 0..<dimension {
            let value: Int = random(from: 0, to: maxValue)
            self.binaryPoint.append(value)
        }

        self.fitness = 0.0;
        self.top = top
        self.bottom = bottom
    }

    func getBinarySlow(index: Int) -> [Int] {
        let value = binaryPoint[index]
        var binaryString: String = String(value, radix: 2)

        while length - binaryString.characters.count > 0 {
            binaryString = "0" + binaryString
        }

        var binary: [Int] = []
        for char in binaryString.characters {
            if char == BinaryChromosome.zeroChar {
                binary.append(0)
            } else {
                binary.append(1)
            }
        }
        return binary
    }

    // .vs.

    func getBinary(index: Int) -> [Int] {
        var n = binaryPoint[index]
        var masks = [Int](repeating: 0, count: length)
        var mask = 1
        while n > 0 {
            if n & mask > 0 {
                let p = Int(log2(Double(mask)))
                masks[length - p - 1] = 1
                n -= mask
            }
            mask <<= 1
        }
        return masks
    }
}

func convertBinaryToMatrix(points: [Int], length: Int, top: Double, bottom: Double) -> Matrix {
    var result = Matrix(rows: points.count, columns: 1)
    for (index, point) in points.enumerated() {
        result[index, 0] = convertFromBinary(b: point, length: length, top: top, bottom: bottom)
    }
    return result
}

func convertMatrixToBinary(matrix: Matrix, length: Int, top: Double, bottom: Double) -> [Int] {
    var points: [Int] = []
    for i in 0..<matrix.rows {
        let value: Int = convertToBinary(x: matrix[i, 0], length: length, top: top, bottom: bottom)
        points.append(value)
    }
    return points
}

func convertToBinary(x: Double, length: Int, top: Double, bottom: Double) -> Int {
    let value: Int = Int((x - bottom) / (top - bottom))
    let power: Int = Int(powf(2, Float(length))) - 1
    return value * power
}

func convertFromBinary(b: Int, length: Int, top: Double, bottom: Double) -> Double {
    let power: Double = pow(2.0, Double(length)) - 1.0
    return bottom + ((Double(b) * (top - bottom)) / power)
}
