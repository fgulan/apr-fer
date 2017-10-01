//
//  main.swift
//  FirstLab
//
//  Created by Filip Gulan on 07/01/2017.
//  Copyright © 2017 Filip Gulan. All rights reserved.
//

import Foundation
import FileKit
import Python

let basePath = "/Users/filipgulan/Diplomski/APR/FirstLab/FifthLab/Files/"
let baseSavePath = "/Users/filipgulan/Diplomski/APR/FirstLab/"

func saveResultsToFile(results: [DiffResult], task: String) {
    let timeFile = TextFile(path: Path(rawValue: baseSavePath + "time\(task).txt"))
    let x0File = TextFile(path: Path(rawValue: baseSavePath + "x0\(task).txt"))
    let x1File = TextFile(path: Path(rawValue: baseSavePath + "x1\(task).txt"))

    let timeString = results.reduce("") { (prev, result) -> String in
        return prev + String(format:"%lf\n", result.time)
    }
    let x0String = results.reduce("") { (prev, result) -> String in
        return prev + String(format:"%.12lf\n", result.point[0, 0])
    }
    let x1String = results.reduce("") { (prev, result) -> String in
        return prev + String(format:"%.12lf\n", result.point[1, 0])
    }
    let _ = try? timeFile.write(timeString)
    let _ = try? x0File.write(x0String)
    let _ = try? x1File.write(x1String)
}

func _firstTask() {
    print("🔵 1. Zadatak ------------------------------------------------------")
    let A = Matrix(path: basePath + "A1.txt")
    let B = Matrix(path: basePath + "B1.txt")
    let X = Matrix(path: basePath + "X1.txt")

    let rg4 = RungeKutta4(matrixA: A, matrixB: B, matrixX0: X, T: 0.1, tMax: 50, printIter: 1)
    if let results = rg4.run() {
        saveResultsToFile(results: results, task: "1")
    }
}
//_firstTask()

func _secondTask() {
    print("🔵 2. Zadatak ------------------------------------------------------")
    let A = Matrix(path: basePath + "A2.txt")
    let B = Matrix(path: basePath + "B2.txt")
    let X = Matrix(path: basePath + "X2.txt")

    let rg4 = RungeKutta4(matrixA: A, matrixB: B, matrixX0: X, T: 0.1, tMax: 3, printIter: 10)
    if let results = rg4.run() {
        saveResultsToFile(results: results, task: "2")
    }
}
_secondTask()
