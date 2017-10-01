//
//  GeneticAlgorithm.swift
//  FirstLab
//
//  Created by Filip Gulan on 17/12/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation

typealias Population = [IndividualType]

public protocol IndividualType {
    var point: Matrix { get set }
    var fitness: Double { get set }
}

public class GeneticAlgorithm {
    var populationSize: UInt
    var maxIteration: UInt
    var maxEvaluation: UInt
    var binary: Bool
    var binaryPrecision: Int
    var epsilon: Double
    var explicitConstraint: ExplicitConstraint
    var selection: Selection

    init(populationSize: UInt,
         maxIteration: UInt,
         maxEvaluation: UInt,
         binary: Bool,
         binaryPrecision: Int,
         epsilon: Double = Constants.Optimizable.Precision,
         explicitConstraint: ExplicitConstraint,
         selection: Selection) {
        self.populationSize = populationSize
        self.maxIteration = maxIteration
        self.maxEvaluation = maxEvaluation
        self.binary = binary
        self.binaryPrecision = binaryPrecision
        self.epsilon = epsilon
        self.explicitConstraint = explicitConstraint
        self.selection = selection
    }

    func run(for function: Function) -> IndividualType {
        var population = _initializeSortedPopulation(for: function)

        var generation: UInt = 0
        for _ in 0..<maxIteration {
            generation += 1
            if function.callCount > maxEvaluation {
                print("\t\tMax evaluation reached.")
                break
            }
            let best = _findBest(in: population)
            if fabs(best.fitness) <= epsilon {
                print("\t\tFunction minimum reached.")
                break
            }

            population = selection.getNewPopulation(from: population, and: function)
        }
        let best = _findBest(in: population)
        if generation >= maxIteration {
            print("\t\tMax iteration reached.")
        } else {
            print("\t\tGeneration number: \(generation)")
        }
        print("\t\tNajbolja tocka:")
        print(best.point)
        print("\t\tVrijednost funkcije:")
        print("\t\t\(function[best.point])")
        return best
    }

    private func _findBest(in population: Population) -> IndividualType {
        var best: IndividualType = population.first!
        for unit in population {
            if unit.fitness > best.fitness {
                best = unit
            }
        }
        return best
    }

    private func _initializeSortedPopulation(for function: Function) -> Population {
        var population: [IndividualType] = []
        for _ in 0..<populationSize {
            if binary {
                let dim = explicitConstraint.bottom.rows
                let top = explicitConstraint.top[0, 0]
                let bottom = explicitConstraint.bottom[0, 0]
                let chromosome = BinaryChromosome(precision: binaryPrecision, dimension: dim, top: top, bottom: bottom)
                chromosome.fitness = -function[chromosome.point]
                population.append(chromosome)
            } else {
                let point: Matrix = Matrix.random(with: explicitConstraint)
                let fitness: Double = -function[point]
                let chromosome = DoubleChromosome(point: point, fitness: fitness)
                population.append(chromosome)
            }
        }
        population.sort { (unit1, unit2) -> Bool in
            return unit1.fitness > unit2.fitness
        }
        return population
    }
}

extension Matrix {
    static func random(with constraint: ExplicitConstraint) -> Matrix {
        let offset = constraint.top - constraint.bottom
        let size = offset.rows

        var result = Matrix(rows: size, columns: 1)
        for i in 0..<size {
            result [i, 0] = constraint.bottom[i, 0] + (Double.random() * offset[i, 0])
        }
        return result
    }
}
