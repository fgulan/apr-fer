//
//  SecondTask.swift
//  FirstLab
//
//  Created by Filip Gulan on 18/12/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation

func secondTask() {
    print("Drugi zadatak")

    print("\tSchaffer f6 funkcija")
    func schaffer(dimension: Int) {
        print("\tDimenzija: \(dimension)")

        let top = Matrix(repeating: 150, rows: dimension, columns: 1)
        let bottom = Matrix(repeating: -50, rows: dimension, columns: 1)

        let crossover = ArithmeticCrossover()
        let mutation = GaussMutation(mutationProb: 0.05, constraints: (bottom, top))
        let selection = TournamentSelection(k: 3, crossover: crossover, mutation: mutation)

        let geneticAlgorithm = GeneticAlgorithm(populationSize: 30, maxIteration: 1000000,
                                                maxEvaluation: 1000000, binary: false,
                                                binaryPrecision: 0, epsilon: Constants.Optimizable.Precision,
                                                explicitConstraint: (bottom, top), selection: selection)
        _ = geneticAlgorithm.run(for: f5(n: dimension))
    }
    for i in [1, 3, 6, 10] {
        _ = schaffer(dimension: i)
    }

    print("\tSchaffer f7 funkcija")
    func f7Schaffer(dimension: Int) {
        print("\tDimenzija: \(dimension)")
        let top = Matrix(repeating: 150, rows: dimension, columns: 1)
        let bottom = Matrix(repeating: -50, rows: dimension, columns: 1)

        let crossover = ArithmeticCrossover()
        let mutation = GaussMutation(mutationProb: 0.05, constraints: (bottom, top))
        let selection = TournamentSelection(k: 3, crossover: crossover, mutation: mutation)

        let geneticAlgorithm = GeneticAlgorithm(populationSize: 30, maxIteration: 1000000,
                                                maxEvaluation: 1000000, binary: false,
                                                binaryPrecision: 0, epsilon: Constants.Optimizable.Precision,
                                                explicitConstraint: (bottom, top), selection: selection)
        _ = geneticAlgorithm.run(for: f7(n: 2))
    }
    for i in [1, 3, 6, 10] {
        _ = f7Schaffer(dimension: i)
    }
}
