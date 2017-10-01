//
//  Solver.swift
//  FirstLab
//
//  Created by Filip Gulan on 23/10/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation

struct Solver {
    static func solve(input: Matrix, resultVector: Matrix) -> Matrix? {
        return solve(input: input, resultVector: resultVector, decompostion: LUPDecomposer())
    }
    
    static func solve(input: Matrix, resultVector: Matrix, decompostion: Decomposition) -> Matrix? {
//        print("\tℹ️ Rjesavanje sustava koristeci \(decompostion.name), te parametre:")
//        print("\tℹ️ Ulazna matrica:\n\(input)")
//        print("\tℹ️ Vektor rjesenja sustava:\n\(resultVector)")

        var decompostion = decompostion
        var input = input
        do {
//            print("\tℹ️ Pokusavam dekomponirati ulaznu matricu...")
            let result = try decompostion.decompose(matrix: &input)
//            print("\t✅ Ulazna matrica dekomponirana! Rezultat je:\n\(result)")
//            print("\tℹ️ Pokusavam provesti supstituciju unaprijed...")
            let forwardSubs = try result.substituteForward(with: decompostion.permutationMatrix * resultVector)
//            print("\t✅ Supstitucija unaprijed uspjesno provedena. Rezulat:\n\(forwardSubs)")
//            print("\tℹ️ Pokusavam provesti supstituciju unatrag...")
            let backwardSubs = try result.substituteBackward(with: forwardSubs)
//            print("\t✅ Supstitucija unatrag uspjesno provedena. Rezultat:\n\(backwardSubs)")
            return backwardSubs
        } catch let error {
            print("\t❌ GRESKA!: \(error)")
        }
        return nil
    }
}

