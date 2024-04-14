//
//  MainViewController.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import UIKit

protocol IMainViewController: UIViewController, ActivityShowable {
    func setup(with viewModel: MainViewModel)
    func updateExchangeRateInLabel(exchangeRate: String?)
}

final class MainViewController: BaseViewController, IMainViewController {
    
    // MARK: - UI Elements
    
    private let lbExchangeRate: UILabel = UILabel()
    private let svBalanceContainer: UIStackView = UIStackView()
    private let lbBalance: UILabel = UILabel()
    private let btTopUpBalance: UIButton = UIButton()
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
        presenter.viewDidLoad()
    }
    
    // MARK: - Private Functions
    
    private func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .lightText
        
        setupLbExchangeRate()
        setupSvBalanceContainer()
        setupLbBalance()
        setupBtTopUpBalance()
        setuptBAddTransaction()
        setupTvTransactionHistory()
    }
    
    private func setupLbExchangeRate() {
        view.addSubview(lbExchangeRate)
                
        lbExchangeRate.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lbExchangeRate.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            lbExchangeRate.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            lbExchangeRate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupSvBalanceContainer() {
        view.addSubview(svBalanceContainer)
        
        svBalanceContainer.axis = .horizontal
        svBalanceContainer.alignment = .fill
        svBalanceContainer.distribution = .fillEqually
        svBalanceContainer.spacing = 8
        
        svBalanceContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            svBalanceContainer.topAnchor.constraint(equalTo: lbExchangeRate.bottomAnchor, constant: 24),
            svBalanceContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            svBalanceContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupLbBalance() {
        svBalanceContainer.addArrangedSubview(lbBalance)
        lbBalance.numberOfLines = 0
    }
    
    private func setupBtTopUpBalance() {
        svBalanceContainer.addArrangedSubview(btTopUpBalance)
    }
    
    private func setuptBAddTransaction() {
        view.addSubview(btAddTransaction)
        
        btAddTransaction.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btAddTransaction.topAnchor.constraint(equalTo: svBalanceContainer.bottomAnchor, constant: 24),
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
    
    // MARK: - IMainViewController
    
    func setup(with viewModel: MainViewModel) {
        lbBalance.text = viewModel.balance
        btTopUpBalance.setup(with: viewModel.btTopUpBalance)
        btAddTransaction.setup(with: viewModel.btAddTransaction)
    }
    
    func updateExchangeRateInLabel(exchangeRate: String?) {
        DispatchQueue.main.async {
            guard let exchangeRate: String = exchangeRate else { return }
            self.lbExchangeRate.text = "1 BTC = \(exchangeRate) USD"
        }
    }
}
