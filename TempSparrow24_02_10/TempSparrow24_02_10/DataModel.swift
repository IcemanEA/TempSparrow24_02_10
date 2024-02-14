//
//  DataModel.swift
//  TempSparrow24_02_10
//
//  Created by Egor Ledkov on 12.02.2024.
//

import Foundation

final class DataModel {
	let id: UUID
	let number: Int
	var isChecked: Bool
	
	var title: String {
		"\(number)"
	}
	
	init(number: Int, isChecked: Bool = false) {
		self.id = UUID()
		self.number = number
		self.isChecked = isChecked
	}
}

extension DataModel: Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}

extension DataModel: Equatable {
	static func == (lhs: DataModel, rhs: DataModel) -> Bool {
		lhs.id == rhs.id
	}
}
