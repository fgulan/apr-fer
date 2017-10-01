//
//  FourthTask.swift
//  FirstLab
//
//  Created by Filip Gulan on 18/12/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation

func fourthTask() {
    print("Cetvrti zadatak")

    print("\tSchaffer f6 funkcija")
    func schaffer(mutationProb: Double, populationSize: UInt) {

        let top = Matrix(repeating: 150, rows: 2, columns: 1)
        let bottom = Matrix(repeating: -50, rows: 2, columns: 1)

        let crossover: Crossoverable
        let mutation: Mutatable
        crossover = ArithmeticCrossover()
        mutation = GaussMutation(mutationProb: mutationProb, constraints: (bottom, top))
        let selection = TournamentSelection(k: 3, crossover: crossover, mutation: mutation)

        let geneticAlgorithm = GeneticAlgorithm(populationSize: populationSize, maxIteration: 1000000,
                                                maxEvaluation: 1000000, binary: false,
                                                binaryPrecision: 4, epsilon: Constants.Optimizable.Precision,
                                                explicitConstraint: (bottom, top), selection: selection)
        _ = geneticAlgorithm.run(for: f5(n: 2))
    }

//    for populationSize in [30, 50, 100, 200] {
//        print("Velicina populacije: \(populationSize)")
//        for _ in 0..<10 {
//            _ = schaffer(mutationProb: 0.1, populationSize: UInt(populationSize))
//        }
//    }

    for mutationProb in [0.1, 0.3, 0.6, 0.9] {
        print("Vjerojatnost mutacije: \(mutationProb)")
        for _ in 0..<10 {
            _ = schaffer(mutationProb: mutationProb, populationSize: UInt(30))
        }
    }
}
