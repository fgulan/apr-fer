//
//  Selection.swift
//  FirstLab
//
//  Created by Filip Gulan on 17/12/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation

protocol Selection {
    func getNewPopulation(from currentPopulation: Population, and function: Function) -> Population
}


final class TournamentSelection: Selection {

    var k: Int
    var mutation: Mutatable
    var crossover: Crossoverable

    init(k: Int,
         crossover: Crossoverable,
         mutation: Mutatable) {
        assert(k > 2)
        self.k = k
        self.mutation = mutation
        self.crossover = crossover
    }

    func getNewPopulation(from currentPopulation: Population, and function: Function) -> Population {
        var newPopulation = currentPopulation
        var indexes = Set<Int>()
        while indexes.count < k {
            indexes.insert(random(from: 0, to: currentPopulation.count - 1))
        }

        let sortedIndexes = indexes.sorted { (index1, index2) -> Bool in
            return currentPopulation[index1].fitness > currentPopulation[index2].fitness
        }
        let firstParent = currentPopulation[sortedIndexes[1]]
        let secondParent = currentPopulation[sortedIndexes[2]]
        var child = crossover.cross(firstParent, and: secondParent, for: function)
        child = mutation.mutate(child, for: function)
        newPopulation[sortedIndexes[k - 1]] = child
        return newPopulation
    }
}
