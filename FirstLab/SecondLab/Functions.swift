//
//  Functions.swift
//  FirstLab
//
//  Created by Filip Gulan on 05/11/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation


/// Initial point = (-1.9, 2), min = (1, 1) => f(min) = 0
///
/// - Returns: Rosenbrock function
func f1() -> Function {
    return CustomFunction { (x) -> Double in
        let first = 100 * ((x[1] - (x[0]**2))**2)
        let second = (1 - x[0])**2
        return first + second
    }
}

/// Initial point = (4, 2), min = (1, 1) => f(min) = 0
///
/// - Returns: Custom function
func f2() -> Function {
    return CustomFunction { (x) -> Double in
        let first = (x[0] - 4)**2
        let second = 4 * ((x[1] - 2)**2)
        return first + second
    }
}

/// Initial point = (0, 0, 0,..., 0), min = (1, 2, 3,..., n) => f(min) = 0
///
/// - Parameter n: Dimension count
/// - Returns: Custom function
func f3(n: Int) -> Function {
    guard n > 0 else {
        fatalError("n has to be greater than zero")
    }
    return CustomFunction(function: { (x) -> Double in
        var sum = 0.0
        for i in 0..<n {
            sum += (x[i] - (Double(i) + 1.0))**2
        }
        return sum
    })
}

/// Initial point = (5.1, 1.1), min = (0, 0) => f(min) = 0
///
/// - Returns: Jakobovic function
func f4() -> Function {
    return CustomFunction(function: { (x) -> Double in
        let first = fabs((x[0] - x[1]) * (x[0] + x[1]))
        let second = sqrt(x[0]**2 + x[1]**2)
        return first + second
    })
}

func f5(n: Int) -> Function {
    guard n > 0 else {
        fatalError("n needs to be greater than zero")
    }

    return CustomFunction(function: { (x) -> Double in
        let sum: Double = x.map({ $0**2 }).reduce(0, +)
        let first: Double = (sin(sqrt(sum))**2) - 0.5
        let second: Double = (1 + 0.001 * sum)**2
        return 0.5 + (first/second)
    })
}

func f7(n: Int) -> Function {
    guard n > 0 else {
        fatalError("n needs to be greater than zero")
    }

    return CustomFunction(function: { (x) -> Double in
        let sum: Double = x.map({ $0**2 }).reduce(0, +)
        let first: Double = pow(sum, 0.25)
        let sin2 = (sin(50*pow(sum, 0.1)))**2
        return first * (1 + sin2)
    })
}

func df1() -> DifferentiableFunction {
    func function(x: [Double]) -> Double {
        let first = 100 * ((x[1] - (x[0]**2))**2)
        let second = (1 - x[0])**2
        return first + second
    }
    
    func gradient(x: [Double]) -> Matrix {
        let first: Double = 2 * (200*(x[0]**3) - 200*x[0]*x[1] + x[0] - 1)
        let second: Double = 200 * (x[1] - (x[0]**2))
        return Matrix(elements: [first, second], rows: 2, columns: 1)
    }
    func hessian(x: [Double]) -> Matrix {
        let dxdx: Double = 2 * (600*(x[0]**2) - 200*x[1] + 1)
        let dxdy: Double = -400*x[0]
        return Matrix(elements: [dxdx, dxdy, dxdy, 200], rows: 2, columns: 2)
    }

    let fc = CustomDifferentiableFunction(function: function, gradient: gradient, hessian: hessian)
    return fc
}

func df2() -> DifferentiableFunction {
    func function(x: [Double]) -> Double {
        let first = (x[0] - 4)**2
        let second = 4 * ((x[1] - 2)**2)
        return first + second
    }

    func gradient(x: [Double]) -> Matrix {
        let first = 2*(x[0] - 4)
        let second = 8 * (x[1] - 2)
        return Matrix(elements: [first, second], rows: 2, columns: 1)
    }
    func hessian(x: [Double]) -> Matrix {
        return Matrix(elements: [2.0, 0.0, 0.0, 8.0], rows: 2, columns: 2)
    }

    let fc = CustomDifferentiableFunction(function: function, gradient: gradient, hessian: hessian)
    return fc
}

func df3() -> DifferentiableFunction {
    func function(x: [Double]) -> Double {
        return ((x[0] - 2)**2) + ((x[1] + 3)**2)
    }
    func gradient(x: [Double]) -> Matrix {
        let first: Double = (2 * x[0]) - 4
        let second: Double = (2 * x[1]) + 6
        return Matrix(elements: [first, second], rows: 2, columns: 1)
    }
    func hessian(x: [Double]) -> Matrix {
        return Matrix(elements: [2.0, 0.0, 0.0, 2.0], rows: 2, columns: 2)
    }

    let fc = CustomDifferentiableFunction(function: function, gradient: gradient, hessian: hessian)
    return fc
}
