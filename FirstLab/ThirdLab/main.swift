//
//  main.swift
//  FirstLab
//
//  Created by Filip Gulan on 13/11/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation

var gd = GradientDescent(online: false)
let nr = GradientDescent(online: true, useNewtonRaphson: true)

print("1. Zadatak ---------------------------------------------------");
_ = {
    let diffFunction3 = df3()
    var min = gd.findMinimum(for: diffFunction3, startPoint: [0, 0])
    print("\tMinimun funkcije bez odredjivanja opt. pomaka: f(\(min)) = \(diffFunction3[min])")
    print("\tBroj poziva: funkcije - \(diffFunction3.callCount) -- gradijenta - \(diffFunction3.gradientCallCount) ")

    diffFunction3.reset()
    gd.online = true
    min = gd.findMinimum(for: diffFunction3, startPoint: [0, 0])
    print("\tMinimun funkcije uz odredjivanja opt. pomaka: f(\(min)) = \(diffFunction3[min])")
    print("\tBroj poziva: funkcije - \(diffFunction3.callCount) -- gradijenta - \(diffFunction3.gradientCallCount) ")
}()

print("\n2. Zadatak ---------------------------------------------------");
_ = {
    let diffFunction1 = df1()
    print("\tGradijentni spust - Rosenbrockova funkcija")
    var min = gd.findMinimum(for: diffFunction1, startPoint: [-1.9, 2])
    print("\t\tMinimun funkcije uz odredjivanja opt. pomaka: f(\(min)) = \(diffFunction1[min])")
    print("\t\tBroj poziva: funkcije - \(diffFunction1.callCount) -- gradijenta - \(diffFunction1.gradientCallCount) ")

    print("\tNewtonRaphson - Rosenbrockova funkcija")
    diffFunction1.reset()
    min = nr.findMinimum(for: diffFunction1, startPoint: [-1.9, 2])
    print("\t\tMinimun funkcije uz odredjivanja opt. pomaka: f(\(min)) = \(diffFunction1[min])")
    print("\t\tBroj poziva: funkcije - \(diffFunction1.callCount) -- gradijenta - \(diffFunction1.gradientCallCount) ")
    print("\t\tBroj poziva: - hesseove - \(diffFunction1.hessianCallCount) ")

    let diffFunction2 = df2()
    print("\n\tGradijentni spust - Druga funkcija")
    min = gd.findMinimum(for: diffFunction2, startPoint: [0.1, 0.3])
    print("\t\tMinimun funkcije uz odredjivanja opt. pomaka: f(\(min)) = \(diffFunction2[min])")
    print("\t\tBroj poziva: funkcije - \(diffFunction2.callCount) -- gradijenta - \(diffFunction2.gradientCallCount) ")

    print("\tNewtonRaphson - Druga funkcija")
    diffFunction2.reset()
    min = nr.findMinimum(for: diffFunction2, startPoint: [0.1, 0.3])
    print("\t\tMinimun funkcije uz odredjivanja opt. pomaka: f(\(min)) = \(diffFunction2[min])")
    print("\t\tBroj poziva: funkcije - \(diffFunction2.callCount) -- gradijenta - \(diffFunction2.gradientCallCount) ")
    print("\t\tBroj poziva: - hesseove - \(diffFunction2.hessianCallCount) ")
}()

let bottom = Matrix(repeating: -100, rows: 2, columns: 1)
let top = Matrix(repeating: 100, rows: 2, columns: 1)
let impl: ImplicitConstraint = { x in
    let first: Bool = (x[1, 0] - x[0, 0]) >= 0
    let second: Bool = (2 - x[0, 0]) >= 0
    return first && second
}
let fun31 = f1()
let fun32 = f2()

print("\n3. Zadatak ---------------------------------------------------");
_ = {
    let box = BoxMethod(explicit: (bottom, top), implicit: impl)

    print("\tMetoda po Boxu - Rosenbrockova funkcija")
    var min = box.findMinimum(for: fun31, startPoint: [-1.9, 2])
    print("\t\tMinimun funkcije po Boxu: f(\(min)) = \(fun31[min])")
    print("\t\tBroj poziva: funkcije - \(fun31.callCount)")

    print("\tMetoda po Boxu - Druga funkcija")
    min = box.findMinimum(for: fun32, startPoint: [0.1, 0.3])
    print("\t\tMinimun funkcije po Boxu: f(\(min)) = \(fun32[min])")
    print("\t\tBroj poziva: funkcije - \(fun32.callCount)")
}()

print("\n4. Zadatak ---------------------------------------------------");
_ = {
    let constraint1 = CustomFunction { (x) -> Double in
        return x[1] - x[0]
    }
    let constraint2 = CustomFunction { (x) -> Double in
        return 2 - x[0]
    }
    fun31.reset(); fun32.reset();
    let transformation = Transformation(inequalities: [constraint1, constraint2], equations: [])

    print("\tTransformacija - Rosenbrockova funkcija")
    var min = transformation.findMinimum(for: fun31, startPoint: [-1.9, 2])
    print("\t\tMinimun funkcije za transformirani problem: f(\(min)) = \(fun31[min])")
    print("\t\tBroj poziva: funkcije - \(fun31.callCount)")

    print("\tTransformacija - Druga funkcija")
    min = transformation.findMinimum(for: fun32, startPoint: [0.1, 0.3])
    print("\t\tMinimun funkcije za transformirani problem: f(\(min)) = \(fun32[min])")
    print("\t\tBroj poziva: funkcije - \(fun32.callCount)")
}()

print("\n5. Zadatak ---------------------------------------------------");
_ = {
    let constraint1 = CustomFunction { (x) -> Double in
        return 3 - x[0] - x[1]
    }
    let constraint2 = CustomFunction { (x) -> Double in
        return 3 + (1.5*x[0]) - x[1]
    }
    let constraint3 = CustomFunction { (x) -> Double in
        return x[1] - 1
    }
    let transformation = Transformation(inequalities: [constraint1, constraint2], equations: [constraint3])
    let function4 = CustomFunction(function: { (x) -> Double in
        return ((x[0] - 3)**2) + x[1]**2
    })

    print("\tTransformacija - Cetvrta funkcija")
    var min = transformation.findMinimum(for: function4, startPoint: [5, 5])
    if min[0] == Double(NSNotFound) {
        print("\t\tZa danu pocetnu tocku, dobije se beskonacna vrijednost logaritma")
    } else {
        print("\t\tMinimun funkcije za transformirani problem: f(\(min)) = \(function4[min])")
        print("\t\tBroj poziva: funkcije - \(function4.callCount)")
    }
}()

