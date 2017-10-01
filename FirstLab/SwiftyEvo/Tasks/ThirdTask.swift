//
//  ThirdTask.swift
//  FirstLab
//
//  Created by Filip Gulan on 18/12/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation

func thirdTask() {
    print("Treci zadatak")

    print("\tSchaffer f6 funkcija")
    func schaffer(dimension: Int, useBinary: Bool) {

        let top = Matrix(repeating: 150, rows: dimension, columns: 1)
        let bottom = Matrix(repeating: -50, rows: dimension, columns: 1)

        let crossover: Crossoverable
        let mutation: Mutatable
        if useBinary {
            crossover = UniformCrossover(precision: 4, dimension: dimension, top: 150, bottom: -50)
            mutation = BinaryMutation(mutationProb: 0.2)
        } else {
            crossover = ArithmeticCrossover()
            mutation = GaussMutation(mutationProb: 0.05, constraints: (bottom, top))
        }
        let selection = TournamentSelection(k: 3, crossover: crossover, mutation: mutation)

        let geneticAlgorithm = GeneticAlgorithm(populationSize: 30, maxIteration: 100000,
                                                maxEvaluation: 100000, binary: useBinary,
                                                binaryPrecision: 4, epsilon: Constants.Optimizable.Precision,
                                                explicitConstraint: (bottom, top), selection: selection)
        _ = geneticAlgorithm.run(for: f5(n: dimension))
    }
    for dimension in [3, 6] {
        print("Dimenzija: \(dimension)")
        for useBinary in [true, false] {
            print("Koristim binarni zapis: \(useBinary)")
            for _ in 0..<10 {
                _ = schaffer(dimension: dimension, useBinary: useBinary)
            }
        }
    }

    print("\tSchaffer f7 funkcija")
    func f7Schaffer(dimension: Int, useBinary: Bool) {

        let top = Matrix(repeating: 150, rows: dimension, columns: 1)
        let bottom = Matrix(repeating: -50, rows: dimension, columns: 1)

        let crossover: Crossoverable
        let mutation: Mutatable
        if useBinary {
            crossover = UniformCrossover(precision: 4, dimension: dimension, top: 150, bottom: -50)
            mutation = BinaryMutation(mutationProb: 0.2)
        } else {
            crossover = ArithmeticCrossover()
            mutation = GaussMutation(mutationProb: 0.05, constraints: (bottom, top))
        }
        let selection = TournamentSelection(k: 3, crossover: crossover, mutation: mutation)

        let geneticAlgorithm = GeneticAlgorithm(populationSize: 30, maxIteration: 100000,
                                                maxEvaluation: 100000, binary: useBinary,
                                                binaryPrecision: 4, epsilon: Constants.Optimizable.Precision,
                                                explicitConstraint: (bottom, top), selection: selection)
        _ = geneticAlgorithm.run(for: f7(n: dimension))

    }
    for dimension in [3, 6] {
        print("Dimenzija: \(dimension)")
        for useBinary in [true, false] {
            print("Koristim binarni zapis: \(useBinary)")
            for _ in 0..<10 {
                _ = f7Schaffer(dimension: dimension, useBinary: useBinary)
            }
        }
    }
}
