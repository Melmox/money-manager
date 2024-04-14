//
//  MainViewController.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import UIKit

protocol IMainViewController: UIViewController { }

final class MainViewController: BaseViewController, IMainViewController {
    
    // MARK: - UI Elements
    
    private let lbExchangeRate: UILabel = UILabel()
    private let svBallanceContainer: UIStackView = UIStackView()
    private let lbBallance: UILabel = UILabel()
    private let btTopUpBallance: UIButton = UIButton()
    private let btAddTransaction: UIButton = UIButton()
    private let tvTransactionHistory: UITableView = UITableView()
    
    // MARK: - Properties
    
    private let presenter: IMainPresenter
    
    // MARK: - Initialization

    init(presenter: IMainPresenter) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private Functions
    
    private func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .lightText
        
        setupLbExchangeRate()
        setupSvBallanceContainer()
        setupLbBallance()
        setupBtTopUpBallance()
        setuptBAddTransaction()
        setupTvTransactionHistory()
    }
    
    private func setupLbExchangeRate() {
        view.addSubview(lbExchangeRate)
        
        lbExchangeRate.text = "lbExchangeRate"
        
        lbExchangeRate.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lbExchangeRate.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            lbExchangeRate.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            lbExchangeRate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupSvBallanceContainer() {
        view.addSubview(svBallanceContainer)
        
        svBallanceContainer.axis = .horizontal
        svBallanceContainer.alignment = .fill
        svBallanceContainer.distribution = .fillEqually
        svBallanceContainer.spacing = 8
        
        svBallanceContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            svBallanceContainer.topAnchor.constraint(equalTo: lbExchangeRate.bottomAnchor, constant: 24),
            svBallanceContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            svBallanceContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupLbBallance() {
        svBallanceContainer.addArrangedSubview(lbBallance)
        lbBallance.text = "lbBallance"
    }
    
    private func setupBtTopUpBallance() {
        svBallanceContainer.addArrangedSubview(btTopUpBallance)
        btTopUpBallance.backgroundColor = .systemRed
        btTopUpBallance.setTitle("btTopUpBallance", for: .normal)
    }
    
    private func setuptBAddTransaction() {
        view.addSubview(btAddTransaction)
        
        btAddTransaction.backgroundColor = .systemGreen
        btAddTransaction.setTitle("btAddTransaction", for: .normal)
        
        btAddTransaction.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btAddTransaction.topAnchor.constraint(equalTo: svBallanceContainer.bottomAnchor, constant: 24),
            btAddTransaction.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            btAddTransaction.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupTvTransactionHistory() {
        view.addSubview(tvTransactionHistory)
        
        tvTransactionHistory.backgroundColor = .systemCyan
        
        tvTransactionHistory.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tvTransactionHistory.topAnchor.constraint(equalTo: btAddTransaction.bottomAnchor, constant: 24),
            tvTransactionHistory.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tvTransactionHistory.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tvTransactionHistory.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
}
