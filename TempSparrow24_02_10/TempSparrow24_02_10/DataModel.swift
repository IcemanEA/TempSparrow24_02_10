//
//  DataModel.swift
//  TempSparrow24_02_10
//
//  Created by Egor Ledkov on 12.02.2024.
//

import Foundation

struct DataModel {
	let id: UUID = UUID()
	let number: Int
	var isChecked: Bool = false
	
	var title: String {
		"\(number)"
	}
}

extension DataModel: Equatable {}
