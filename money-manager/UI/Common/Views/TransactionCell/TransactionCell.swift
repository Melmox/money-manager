//
//  TransactionCell.swift
//  money-manager
//
//  Created by developer on 15.04.2024.
//

import UIKit

final class TransactionCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    private let svContainer: UIStackView = UIStackView()
    private let lbTime: UILabel = UILabel()
    private let lbAmount: UILabel = UILabel()
    private let lbCategory: UILabel = UILabel()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    func setup(with viewModel: TransactionCellViewModel) {
        lbTime.text = viewModel.transaction.date.timeString()
        lbAmount.text = String(viewModel.transaction.amount)
        lbCategory.text = viewModel.transaction.category.rawValue
    }
    
    // MARK: - Private
    
    private func setupUI() {
        backgroundColor = .systemCyan
        separatorInset = UIEdgeInsets.zero
        
        setupSvContainer()
        setupLbTime()
        setupLbAmount()
        setupLbCategory()
    }
    
    private func setupSvContainer() {
        addSubview(svContainer)
        
        svContainer.axis = .horizontal
        svContainer.alignment = .fill
        svContainer.distribution = .fillEqually
        svContainer.spacing = 8
        
        svContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            svContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            svContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            svContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            svContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupLbTime() {
        svContainer.addArrangedSubview(lbTime)
        lbTime.textAlignment = .center
    }
    
    private func setupLbAmount() {
        svContainer.addArrangedSubview(lbAmount)
        lbAmount.textAlignment = .center
    }
    
    private func setupLbCategory() {
        svContainer.addArrangedSubview(lbCategory)
        lbCategory.textAlignment = .center
    }
}
