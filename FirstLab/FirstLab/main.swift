//
//  main.swift
//  FirstLab
//
//  Created by Filip Gulan on 08/10/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation
import CoreFoundation

//let basePath = "/Users/filipgulan/Diplomski/APR/FirstLab/FirstLab/Zadatak/"
//
//print("🔵 1. Zadatak ------------------------------------------------------")
//let firstMatrix = Matrix(path: basePath + "zad_sustav_1.txt")
//var secondMatrix =  203.79999999999999999999999 * firstMatrix
//secondMatrix = (1.0/203.79999999999999999999999) * secondMatrix
//print(firstMatrix == secondMatrix ? "✅ Matrice su jednake nakon mnozenja/djelenja realnim brojem!" : "❌ Matrice nisu jednake!")
//
//return
//for i in 2...3 {
//    print("🔵 \(i). Zadatak ------------------------------------------------------")
//    let a2 = Matrix(path: basePath + "zad_sustav_\(i).txt")
//    let b2 = Matrix(path: basePath + "zad_vektor_\(i).txt")
//    if let x2 = Solver.solve(input: a2, resultVector: b2, decompostion: LUDecomposer()) {
//        print("\t✅ Rjesenje sustava je:\n\(x2)")
//    } else if let x2 = Solver.solve(input: a2, resultVector: b2, decompostion: LUPDecomposer()) {
//        print("\t✅ Rjesenje sustava je:\n\(x2)")
//    } else {
//        print("\t❌ Rjesenje sustava nije moguce pronaci s LU/LUP dekompozicijom.")
//    }
//}

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
func ^^ (radix: Double, power: Double) -> Double {
    return pow(radix, power)
}

print("🔵 4. Zadatak ------------------------------------------------------")
print("Bez pivotiranja:")
var lu = LUDecomposer()
for k in 1..<11 {
    let epsilon = 10.0^^(-2.0 * Double(k))
    var A = Matrix(elements: [epsilon, 1.0, 1.0, 1.0], rows: 2, columns: 2)
    var b = Matrix(elements: [1.0 + epsilon, 2], rows: 2, columns: 1)
    if let x = Solver.solve(input: A, resultVector: b, decompostion: lu) {
        print("\tk = \(Int(k))")
        print("\t\tRelativna pogreska x1: \(fabs(1.0 - x[0, 0]))")
        print("\t\tRelativna pogreska x2: \(fabs(1.0 - x[1, 0]))")
    }
}

print("Uz pivotiranje:")
var lup = LUPDecomposer()
for k in 1..<11 {
    let epsilon = 10.0^^(-2.0 * Double(k))
    var A = Matrix(elements: [epsilon, 1.0, 1.0, 1.0], rows: 2, columns: 2)
    var b = Matrix(elements: [1.0 + epsilon, 2], rows: 2, columns: 1)
    if let x = Solver.solve(input: A, resultVector: b, decompostion: lup) {
        print("\tk = \(Int(k))")
        print("\t\tRelativna pogreska x1: \(fabs(1.0 - x[0, 0]))")
        print("\t\tRelativna pogreska x2: \(fabs(1.0 - x[1, 0]))")
    }
}
//try! lu.decompose(matrix: &a2)
//print(a2)
//let b2 = Matrix(path: basePath + "zad_vektor_4.txt")

//if let x2 = Solver.solve(input: a2, resultVector: b2, decompostion: LUDecomposer()) {
//    print("\t✅ Rjesenje sustava je:\n\(x2)")
//}
//if let x2 = Solver.solve(input: a2, resultVector: b2, decompostion: LUPDecomposer()) {
//    print("\t✅ Rjesenje sustava je:\n\(x2)")
//}

//print("🔵 5. Zadatak ------------------------------------------------------")
//let a5 = Matrix(path: basePath + "zad_sustav_5.txt")
//let b5 = Matrix(path: basePath + "zad_vektor_5.txt")
//if let x2 = Solver.solve(input: a5, resultVector: b5, decompostion: LUDecomposer()) {
//    print("\t✅ Rjesenje sustava je:\n\(x2)")
//} else if let x2 = Solver.solve(input: a5, resultVector: b5, decompostion: LUPDecomposer()) {
//    print("\t✅ Rjesenje sustava je:\n\(x2)")
//}
//
//print("🔵 6. Zadatak ------------------------------------------------------")
//var a6 = Matrix(path: basePath + "zad_sustav_6.txt")
//let b6 = Matrix(path: basePath + "zad_vektor_6.txt")
//if let x2 = Solver.solve(input: a6, resultVector: b6, decompostion: LUDecomposer()) {
//    print("\t✅ Rjesenje sustava je:\n\(x2)")
//}
//if let x2 = Solver.solve(input: a6, resultVector: b6, decompostion: LUPDecomposer()) {
//    print("\t✅ Rjesenje sustava je:\n\(x2)")
//}
//
//print("🔵 7. Zadatak ------------------------------------------------------")
//var a7 = Matrix(elements: [1, 0, 0, 1, 1, 0, 0, 4, 1], rows: 3, columns: 3)
//let b7 = Matrix(elements: [25, 10, 10], rows: 3, columns: 1)
//if let x2 = Solver.solve(input: a7, resultVector: b7, decompostion: LUDecomposer()) {
//    print("\t✅ Rjesenje sustava je:\n\(x2)")
//}
//
//print("🔵 8. Zadatak ------------------------------------------------------")
//var a8 = Matrix(elements: [1, -2, 1, 0, 1, 6, 0, 0, 1], rows: 3, columns: 3)
//let b8 = Matrix(elements: [4, -1, 2], rows: 3, columns: 1)
//if let x2 = Solver.solve(input: a8, resultVector: b8, decompostion: LUDecomposer()) {
//    print("\t✅ Rjesenje sustava je:\n\(x2)")
//}
//
//print("🔵 9. Zadatak ------------------------------------------------------")
//var a9 = Matrix(path: basePath + "zad_9.txt")
//var decomposer = LUDecomposer()
//try print(decomposer.decompose(matrix: &a9))
//try print(a9.lowerTriangularMatrix())
//try print(a9.upperTriangularMatrix())
