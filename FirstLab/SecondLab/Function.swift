//
//  Function.swift
//  FirstLab
//
//  Created by Filip Gulan on 31/10/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation

protocol Function: class {
    var callCount: UInt { get }
    subscript(element: [Double]) -> Double { get }
    func value(at element: [Double]) -> Double

    func value(at vector: Matrix) -> Double
    func reset()
    subscript(vector: Matrix) -> Double { get }
}

extension Function {
    func value(at vector: Matrix) -> Double {
        return value(at: vector.elements)
    }
    
    subscript(vector: Matrix) -> Double {
        return value(at: vector.elements)
    }
}

protocol DifferentiableFunction: Function {
    func hessian(at point: Matrix) -> Matrix
    func gradient(at point: Matrix) -> Matrix
    var gradientCallCount: UInt { get }
    var hessianCallCount: UInt { get }

}

extension DifferentiableFunction {
    func hessian(at point: Matrix) -> Matrix {
        fatalError("Not implemented")
    }
    
    func gradient(at point: Matrix) -> Matrix {
        fatalError("Not implemented")
    }
}

class CustomDifferentiableFunction: DifferentiableFunction {

    private let _function: ([Double]) -> Double
    private let _gradient: ([Double]) -> Matrix
    private let _hessian: (([Double]) -> Matrix)?

    var callCount: UInt = 0
    var gradientCallCount: UInt = 0
    var hessianCallCount: UInt = 0

    init(function: @escaping ([Double]) -> Double,
         gradient: @escaping ([Double]) -> Matrix,
         hessian: (([Double]) -> Matrix)? = nil) {
        _gradient = gradient
        _hessian = hessian
        _function = function
    }

    func hessian(at point: Matrix) -> Matrix {
        guard let hessian = _hessian else {
            fatalError("Hessian equation not given")
        }
        hessianCallCount += 1
        return hessian(point.elements)
    }

    func gradient(at point: Matrix) -> Matrix {
        gradientCallCount += 1
        return _gradient(point.elements)
    }

    func value(at element: [Double]) -> Double {
        callCount += 1
        return _function(element)
    }

    subscript(element: [Double]) -> Double {
        return value(at: element)
    }

    func reset() {
        callCount = 0
        gradientCallCount = 0
        hessianCallCount = 0
    }
}

class CustomFunction: Function {

    private let _function: ([Double]) -> Double
    var callCount: UInt = 0

    init(function: @escaping ([Double]) -> Double) {
        _function = function
    }

    func value(at element: [Double]) -> Double {
        callCount += 1
        return _function(element)
    }

    subscript(element: [Double]) -> Double {
        return value(at: element)
    }
    
    func reset() {
        callCount = 0
    }
}

class CacheFunction: Function {

    private let _function: Function
    private var _cache = [Matrix : Double]()

    init(function: Function) {
        _function = function
    }

    func value(at element: [Double]) -> Double {
        let point = Matrix(elements: element, rows: element.count, columns: 1)
        if let value = _cache[point] {
            return value
        }
        let value = _function.value(at: element)
        _cache[point] = value
        return value
    }

    subscript(element: [Double]) -> Double {
        return value(at: element)
    }

    var callCount: UInt {
        return _function.callCount
    }

    func reset() {
        _function.reset()
    }

}
