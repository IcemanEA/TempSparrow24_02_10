//
//  ViewController.swift
//  TempSparrow24_02_10
//
//  Created by Egor Ledkov on 11.02.2024.
//

import UIKit

class ViewController: UITableViewController {
	
	private let cellId = "task"
	private let dataCount = 30
	
	private var dataModels: [DataModel] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		loadData()
		
		setupView()
	}
	
	// MARK: - Private methods
	
	private func loadData() {
		dataModels = Array(0...dataCount).map { DataModel(number: $0) }
	}
	
	private func setupView() {
		view.backgroundColor = .systemBackground
		title = "Number list"
		navigationController?.navigationBar.prefersLargeTitles = true
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Shuffle",
			style: .plain,
			target: self,
			action: #selector(shuffleList)
		)
		
		tableView = UITableView(frame: .infinite, style: .insetGrouped)
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
	}
	
	@objc private func shuffleList() {
		let oldData = dataModels
		dataModels.shuffle()
		
		tableView.beginUpdates()
		for (index, dataModel) in dataModels.enumerated() {
			let newIndexPath = IndexPath(row: index, section: 0)
			if let oldIndex = oldData.firstIndex(where: { $0 == dataModel }) {
				let oldIndexPath = IndexPath(row: oldIndex, section: 0)
				
				tableView.moveRow(at: oldIndexPath, to: newIndexPath)
			}
		}
		tableView.endUpdates()
	}
}

// MARK: - UITableViewDataSource

extension ViewController {
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		dataModels.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
		let dataModel = dataModels[indexPath.row]
		var content = cell.defaultContentConfiguration()
		content.text = dataModel.title
		cell.contentConfiguration = content
		cell.accessoryType = dataModel.isChecked ? .checkmark : .none
		return cell
	}
}

// MARK: - UITableViewDelegate

extension ViewController {
	 
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		dataModels[indexPath.row].isChecked.toggle()
		let dataModel = dataModels[indexPath.row]
		
		if dataModel.isChecked {
			dataModels.remove(at: indexPath.row)
			dataModels.insert(dataModel, at: 0)
			let newIndexPath = IndexPath(row: 0, section: 0)
			tableView.moveRow(at: indexPath, to: newIndexPath)
			tableView.reloadRows(at: [newIndexPath], with: .automatic)
		} else {
			tableView.reloadRows(at: [indexPath], with: .automatic)
		}
	}
}
