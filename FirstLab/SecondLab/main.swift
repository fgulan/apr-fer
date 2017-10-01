//
//  main.swift
//  FirstLab
//
//  Created by Filip Gulan on 31/10/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation

let algorithms: [Optimizable] = [CoordinateDescent(), NelderMeadSimplex(verbose: false), HookeJeves(verbose: false)]
let firstFunction = CustomFunction {( ($0[0] - 3)**2 )}

print("1. Zadatak ---------------------------------------------------")
for method in algorithms {
    print("\tKoristim metodu: \(method.name)")
    let min = method.findMinimum(for: firstFunction, startPoint: [10])
    print("\tTocka minimuma: \(min)")
    print("\tVrijednsot minimuma: \(firstFunction[min])")

    print("\tBroj poziva funkcije: \(firstFunction.callCount)\n")
    firstFunction.reset()
}

typealias TrainSet = (f: Function, point: [Double])

let first: TrainSet = (f1(), [-1.9, 2])
let second: TrainSet = (f2(), [4, 2])
let third: TrainSet = (f3(n: 7), [0, 0, 0, 0, 0, 0, 0])
let fourth: TrainSet = (f4(), [5.1, 1.1])

let trainSet: [TrainSet] = [first, second, third, fourth]

print("2. Zadatak ---------------------------------------------------")
for (i, set) in trainSet.enumerated() {
    print("\t\(i + 1). Funkcija")
    for method in algorithms {
        print("\t\tKoristim metodu: \(method.name)")
        let min = method.findMinimum(for: set.f, startPoint: set.point)
        print("\t\tTocka minimuma: \(min)")
        print("\t\tVrijednsot minimuma: \(set.f[min])")
        print("\t\tBroj poziva funkcije: \(set.f.callCount)\n")
        set.f.reset()
    }
}

print("3. Zadatak ---------------------------------------------------")
let function4 = f4()
for i in 1..<algorithms.count {
    let method = algorithms[i]
    print("\tKoristim metodu: \(method.name)")
    let min = method.findMinimum(for: function4, startPoint: [5, 5])
    print("\tTocka minimuma: \(min)")
    print("\tBroj poziva funkcije: \(function4.callCount)\n")
    function4.reset()
}

print("4. Zadatak ---------------------------------------------------")
let nms = NelderMeadSimplex()
let function1 = f1()
for i in 1..<21 {
    nms.step = Double(i)
    print("\tKoristim metodu: \(nms.name), korak: \(i)")
    let min = nms.findMinimum(for: function1, startPoint: [0.5, 0.5])
    print("\tTocka minimuma: \(min)")
    print("\tBroj poziva funkcije: \(function1.callCount)\n")
    function1.reset()
}

print("5. Zadatak ---------------------------------------------------")

let function6 = f5(n: 1)
let method = NelderMeadSimplex()
var minCount = 0
for i in 0..<1000 {
    let random = Int(arc4random_uniform(101)) - 50
    let min = method.findMinimum(for: function6, startPoint: [Double(random)])
    if min[0] < 1e-4 {
        print(random)
        minCount += 1
    }
    function6.reset()
}


print("Vjerojatnost pronalaska minimuma: \(Double(minCount)/10.0)%")
