//
//  Operators.swift
//  FirstLab
//
//  Created by Filip Gulan on 17/12/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation

protocol Mutatable {
    func mutate(_ individual: IndividualType, for function: Function) -> IndividualType
}

// Floating point mutation
class UniformMutation: Mutatable {
    var mutationProb: Double
    var constraints: ExplicitConstraint {
        didSet {
            offset = constraints.top - constraints.bottom
        }
    }
    private var offset: Matrix

    init(mutationProb: Double,
         constraints: ExplicitConstraint) {
        self.mutationProb = mutationProb
        self.constraints = constraints
        self.offset = constraints.top - constraints.bottom
    }

    func mutate(_ individual: IndividualType, for function: Function) -> IndividualType {
        var newPoint: Matrix = individual.point
        for i in 0..<newPoint.rows {
            if random(from: 0.0, to: 1.0) <= self.mutationProb {
                newPoint[i, 0] = random(from: 0.0, to: 1.0) * offset[i, 0] + constraints.bottom[i, 0]
            }
        }
        let fitness: Double = -function[newPoint]
        return DoubleChromosome(point: newPoint, fitness: fitness)
    }
}

// Floating point mutation
class GaussMutation: Mutatable {
    var mutationProb: Double
    var constraints: ExplicitConstraint {
        didSet {
            offset = constraints.top - constraints.bottom
        }
    }
    private var offset: Matrix

    init(mutationProb: Double,
         constraints: ExplicitConstraint) {
        self.mutationProb = mutationProb
        self.constraints = constraints
        self.offset = constraints.top - constraints.bottom
    }

    func mutate(_ individual: IndividualType, for function: Function) -> IndividualType {
        var newPoint: Matrix = individual.point
        for i in 0..<newPoint.rows {
            if random(from: 0.0, to: 1.0) <= self.mutationProb {
                let myGaussian = nextGaussian() * 1.0 + 0.0
                newPoint[i, 0] = myGaussian * offset[i, 0] + constraints.bottom[i, 0]
            }
        }
        let fitness: Double = -function[newPoint]
        return DoubleChromosome(point: newPoint, fitness: fitness)
    }
}

// Binary unifrom mutation
class BinaryMutation: Mutatable {

    var mutationProb: Double

    init(mutationProb: Double) {
        self.mutationProb = mutationProb
    }

    func mutate(_ individual: IndividualType, for function: Function) -> IndividualType {
        guard let child = individual as? BinaryChromosome else {
            fatalError("Non Binary chromosome!!!")
        }
        for i in 0..<child.dimension {
            guard randomP() <= mutationProb else {
                continue
            }
            var solution = child.getBinary(index: i)
            for j in 0..<solution.count {
                if randomP() <= mutationProb {
                    solution[j] = 1 - solution[j]
                }
            }
            let intValue = binaryArrayToInt(array: solution)
            child.binaryPoint[i] = intValue
        }
        child.fitness = -function[child.point]
        return child
    }
}

protocol Crossoverable {
    func cross(_ firstParent: IndividualType, and secondParent: IndividualType, for function: Function) -> IndividualType
}

// Floating point crossover

class ArithmeticCrossover: Crossoverable {
    func cross(_ firstParent: IndividualType, and secondParent: IndividualType, for function: Function) -> IndividualType {
        let rand: Double = random(from: 0.0, to: 1.0)
        let newPoint: Matrix = (rand * firstParent.point) + ((1.0 - rand) * secondParent.point)
        let fitness: Double = -function[newPoint]
        return DoubleChromosome(point: newPoint, fitness: fitness)
    }
}

class HeuristicCrossover: Crossoverable {
    var top: Double
    var bottom: Double

    init(top: Double, bottom: Double) {
        self.top = top
        self.bottom = bottom
    }
    func cross(_ firstParent: IndividualType, and secondParent: IndividualType, for function: Function) -> IndividualType {
        let rand: Double = random(from: 0.0, to: 1.0)
        let point1: Matrix
        let point2: Matrix
        if firstParent.fitness > secondParent.fitness {
            point1 = secondParent.point
            point2 = firstParent.point
        } else {
            point1 = firstParent.point
            point2 = secondParent.point
        }

        var newPoint: Matrix = rand * (point2 - point1) + point2
        for i in 0..<newPoint.rows {
            if newPoint[i, 0] < bottom {
                newPoint[i, 0] = bottom
            } else if newPoint[i, 0] > top {
                newPoint[i, 0] = top
            }
        }

        let fitness: Double = -function[newPoint]
        return DoubleChromosome(point: newPoint, fitness: fitness)
    }
}

// Binary crossover
class UniformCrossover: Crossoverable {
    var top: Double
    var bottom: Double
    var dimension: Int
    var precision: Int

    init(precision: Int, dimension: Int, top: Double, bottom: Double) {
        self.precision = precision
        self.dimension = dimension
        self.top = top
        self.bottom = bottom
    }

    func cross(_ firstParent: IndividualType, and secondParent: IndividualType, for function: Function) -> IndividualType {
        guard let fp = firstParent as? BinaryChromosome, let sp = secondParent as? BinaryChromosome else {
            fatalError("Non Binary chromosome!!!")
        }

        let child = BinaryChromosome(precision: precision, dimension: dimension, top: top, bottom: bottom)
        for i in 0..<dimension {
            let binary1 = fp.getBinary(index: i)
            let binary2 = sp.getBinary(index: i)

            let size = binary1.count
            var solution: [Int] = []
            for j in 0..<size {
                if binary1[j] == binary2[j] {
                    solution.append(binary1[j])
                } else {
                    let value: Int = random(from: 0.0, to: 1.0) < 0.5 ? binary1[j] : binary2[j]
                    solution.append(value)
                }
            }
            let intValue = binaryArrayToInt(array: solution)
            child.binaryPoint[i] = intValue
        }
        child.fitness = -function[child.point]
        return child
    }
}

// Binary crossover
class SinglePointCrossover: Crossoverable {
    var top: Double
    var bottom: Double
    var dimension: Int
    var precision: Int

    init(precision: Int, dimension: Int, top: Double, bottom: Double) {
        self.precision = precision
        self.dimension = dimension
        self.top = top
        self.bottom = bottom
    }

    func cross(_ firstParent: IndividualType, and secondParent: IndividualType, for function: Function) -> IndividualType {
        guard let fp = firstParent as? BinaryChromosome, let sp = secondParent as? BinaryChromosome else {
            fatalError("Non Binary chromosome!!!")
        }

        let child = BinaryChromosome(precision: precision, dimension: dimension, top: top, bottom: bottom)
        for i in 0..<dimension {
            let binary1 = fp.getBinary(index: i)
            let binary2 = sp.getBinary(index: i)

            let size = binary1.count
            let crossPoint = random(from: 0, to: size - 1)

            var solution: [Int] = []
            for j in 0..<crossPoint {
                solution.append(binary1[j])
            }
            for j in crossPoint..<size {
                solution.append(binary2[j])
            }

            assert(solution.count == size)
            let intValue = binaryArrayToInt(array: solution)
            child.binaryPoint[i] = intValue
        }
        child.fitness = -function[child.point]
        return child
    }
}

func binaryArrayToInt(array: [Int]) -> Int {
    let length = array.count
    var counter = 0.0
    var value: Int = 0
    for i in (0..<length).reversed() {
        if array[i] == 1 {
            value += Int(pow(2.0, counter))
        }
        counter += 1.0
    }
    return value
}

// .vs.

func binaryArrayToIntSlow(array: [Int]) -> Int {
    let str: String = array.map({"\($0)"}).joined(separator: "")
    return Int(str, radix: 2)!
}
