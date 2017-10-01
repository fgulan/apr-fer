//
//  Optimizable.swift
//  FirstLab
//
//  Created by Filip Gulan on 31/10/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation

protocol Optimizable {
    var name: String { get }
    func findMinimum(for function: Function, startPoint: [Double]) -> [Double]
    func findMinimum(for function: Function, interval: (left: Double, right: Double)) -> [Double]
}
