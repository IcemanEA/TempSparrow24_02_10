//
//  TableViewController.swift
//  TempSparrow24_02_10
//
//  Created by Egor Ledkov on 13.02.2024.
//

import UIKit

class TableViewController: UITableViewController {
	
	private let cellId = "task"
	private let dataCount = 20
	private var dataModels: [DataModel] = []
	
	private lazy var dataSource: UITableViewDiffableDataSource<String, DataModel> = {
		UITableViewDiffableDataSource<String, DataModel>(tableView: tableView) { tableView, indexPath, itemIdentifier in
			let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath)
			var content = cell.defaultContentConfiguration()
			content.text = itemIdentifier.title
			cell.contentConfiguration = content
			cell.accessoryType = itemIdentifier.isChecked ? .checkmark : .none
			return cell
		}
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupView()
		
		dataModels = Array(0...dataCount).map { DataModel(number: $0) }
		updateData(dataModels, animated: false)
	}
	
	// MARK: - Private methods
	
	@objc private func shuffleList() {
		dataModels.shuffle()
		updateData(dataModels, animated: true)
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
	
	private func updateData(_ data: [DataModel], animated: Bool) {
		var snapshot = NSDiffableDataSourceSnapshot<String, DataModel>()
		let firstSection = "First"
		snapshot.appendSections([firstSection])
		snapshot.appendItems(data, toSection: firstSection)
		dataSource.apply(snapshot, animatingDifferences: animated)
	}
}

// MARK: - UITableViewDelegate

extension TableViewController {
	 
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		guard
			let first = dataSource.snapshot().itemIdentifiers.first,
			let item = dataSource.itemIdentifier(for: indexPath)
		else { return }
		
		item.isChecked.toggle()
		var snapshot = dataSource.snapshot()
		var toReconfigure = [item]
		
		if item.isChecked, first != item {
			snapshot.moveItem(item, beforeItem: first)
			toReconfigure.append(first)
		}
		
		snapshot.reconfigureItems(toReconfigure)
		dataSource.apply(snapshot)
	}
}
