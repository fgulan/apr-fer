//
//  MatrixFactory.swift
//  Matrix
//
//  Created by Filip Gulan on 05/10/2016.
//  Copyright © 2016 Filip Gulan. All rights reserved.
//
//

import Foundation
import FileKit

extension Matrix {
    init(path: String) {
        let file = TextFile(path: Path(rawValue: path))

        guard let reader = file.streamReader() else {
            fatalError("Unable to open matrix definition for path: \(path)")
        }
        var elements = [Double]()
        var columns = -1
        var rows = 0
        for (index, line) in reader.enumerated() {
            let row = line.components(separatedBy: " ").map({ (token) -> Double in
                guard let value = Double(token) else {
                    fatalError("Invalid data in line: \(index + 1)")
                }
                return value
            })
            rows += 1
            if columns == -1 {
                columns = row.count
            } else if row.count != columns {
                fatalError("Incosistent row size in line: \(index + 1)")
            }
            elements.append(contentsOf: row)
        }
        self.init(elements: elements, rows: rows, columns: columns)
    }

    func saveTo(path: String) {
        let file = TextFile(path: Path(rawValue: path))
        let _ = try? file.write(toString())
    }
}
