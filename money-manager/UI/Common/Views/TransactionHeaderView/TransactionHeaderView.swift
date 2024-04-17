//
//  TransactionHeaderView.swift
//  money-manager
//
//  Created by developer on 16.04.2024.
//

import UIKit

final class TransactionHeaderView: UIView {
    
    // MARK: - UI Elements
    
    private let lbDate: UILabel = UILabel()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public
    
    func setup(with viewModel: TransactionCellViewModel?) {
        lbDate.text = viewModel?.transaction.date.dateString()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        setupLbDate()
    }
    
    private func setupLbDate() {
        addSubview(lbDate)
        
        lbDate.textAlignment = .center
        lbDate.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lbDate.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            lbDate.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            lbDate.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            lbDate.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
}
