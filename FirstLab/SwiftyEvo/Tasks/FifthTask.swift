//
//  FifthTask.swift
//  FirstLab
//
//  Created by Filip Gulan on 18/12/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation

func fifthTask() {
    print("\tSchaffer f6 funkcija")
    func schaffer(k: Int) {
        let top = Matrix(repeating: 150, rows: 2, columns: 1)
        let bottom = Matrix(repeating: -50, rows: 2, columns: 1)

        let crossover = ArithmeticCrossover()
        let mutation = GaussMutation(mutationProb: 0.1, constraints: (bottom, top))
        let selection = TournamentSelection(k: k, crossover: crossover, mutation: mutation)

        let geneticAlgorithm = GeneticAlgorithm(populationSize: 30, maxIteration: 1000000,
                                                maxEvaluation: 1000000, binary: false,
                                                binaryPrecision: 0, epsilon: Constants.Optimizable.Precision,
                                                explicitConstraint: (bottom, top), selection: selection)
        _ = geneticAlgorithm.run(for: f5(n: 2))
    }

    for k in [3, 5, 7, 9, 12] {
        print("Velicina turnira: \(k)")
        _ = schaffer(k: k)
    }
}
