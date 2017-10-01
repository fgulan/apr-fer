//
//  FirstTask.swift
//  FirstLab
//
//  Created by Filip Gulan on 18/12/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation

func firstTask() {
    print("Prvi zadatak")

    let first = {
        let top = Matrix(repeating: 150, rows: 2, columns: 1)
        let bottom = Matrix(repeating: -50, rows: 2, columns: 1)

        let crossover = HeuristicCrossover(top: 150, bottom: -50)
        let mutation = GaussMutation(mutationProb: 0.05, constraints: (bottom, top))
        let selection = TournamentSelection(k: 3, crossover: crossover, mutation: mutation)

        let geneticAlgorithm = GeneticAlgorithm(populationSize: 30, maxIteration: 100000,
                                                maxEvaluation: 100000, binary: false,
                                                binaryPrecision: 0, epsilon: Constants.Optimizable.Precision,
                                                explicitConstraint: (bottom, top), selection: selection)
        _ = geneticAlgorithm.run(for: f1())
    }

    print("\tRosenbrockova funkcija")
    _ = first()

    print("\tFunkcija 3.")
    let third = {
        let top = Matrix(repeating: 150, rows: 5, columns: 1)
        let bottom = Matrix(repeating: -50, rows: 5, columns: 1)

        let crossover = ArithmeticCrossover()
        let mutation = GaussMutation(mutationProb: 0.1, constraints: (bottom, top))
        let selection = TournamentSelection(k: 3, crossover: crossover, mutation: mutation)

        let geneticAlgorithm = GeneticAlgorithm(populationSize: 30, maxIteration: 10000000,
                                                maxEvaluation: 10000000, binary: false,
                                                binaryPrecision: 0, epsilon: Constants.Optimizable.Precision,
                                                explicitConstraint: (bottom, top), selection: selection)
        _ = geneticAlgorithm.run(for: f3(n: 5))
    }
    _ = third()

    print("\tSchaffer f6 funkcija")
    let schaffer = {
        let top = Matrix(repeating: 150, rows: 2, columns: 1)
        let bottom = Matrix(repeating: -50, rows: 2, columns: 1)

        let crossover = ArithmeticCrossover()
        let mutation = GaussMutation(mutationProb: 0.1, constraints: (bottom, top))
        let selection = TournamentSelection(k: 3, crossover: crossover, mutation: mutation)

        let geneticAlgorithm = GeneticAlgorithm(populationSize: 30, maxIteration: 1000000,
                                                maxEvaluation: 1000000, binary: false,
                                                binaryPrecision: 0, epsilon: Constants.Optimizable.Precision,
                                                explicitConstraint: (bottom, top), selection: selection)
        _ = geneticAlgorithm.run(for: f5(n: 2))
    }
    _ = schaffer()

    print("\tSchaffer f7 funkcija")
    let f7Schaffer = {
        let top = Matrix(repeating: 150, rows: 2, columns: 1)
        let bottom = Matrix(repeating: -50, rows: 2, columns: 1)

        let crossover = HeuristicCrossover(top: 150, bottom: -50)
        let mutation = GaussMutation(mutationProb: 0.01, constraints: (bottom, top))
        let selection = TournamentSelection(k: 3, crossover: crossover, mutation: mutation)

        let geneticAlgorithm = GeneticAlgorithm(populationSize: 30, maxIteration: 1000000,
                                                maxEvaluation: 1000000, binary: false,
                                                binaryPrecision: 0, epsilon: Constants.Optimizable.Precision,
                                                explicitConstraint: (bottom, top), selection: selection)
        _ = geneticAlgorithm.run(for: f7(n: 2))
    }
    _ = f7Schaffer()
}
