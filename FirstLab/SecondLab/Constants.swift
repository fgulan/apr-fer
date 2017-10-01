//
//  Constants.swift
//  FirstLab
//
//  Created by Filip Gulan on 31/10/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//

import Foundation

struct Constants {
    struct Optimizable {
        static let Precision = 1e-6
    }

    struct GoldenSection {
        static let Step = 1.0
        static let Ratio = 0.5 * sqrt(5) - 0.5;
    }

    struct NelderMeadSimplex {
        static let Alpha = 1.0
        static let Beta = 0.5
        static let Gamma = 2.0
        static let Sigma = 0.5
    }

    struct HookeJeves {
        static let InitialStep = 0.5
    }
}
