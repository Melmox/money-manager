//
//  MainViewController.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import UIKit

protocol IMainViewController: UIViewController, ActivityShowable {
    func setup(with viewModel: MainViewModel)
    func showTopUpBalanceAlert()
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
        self.view.backgroundColor = .systemBackground
        
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
        lbExchangeRate.text = viewModel.exchangeRate
        lbBalance.text = viewModel.balance
        btTopUpBalance.setup(with: viewModel.btTopUpBalance)
        btAddTransaction.setup(with: viewModel.btAddTransaction)
    }
    
    func showTopUpBalanceAlert() {
        let alertTopUpBalance: UIAlertController = UIAlertController(title: "Top up your balance", message: "Type amount in BTC", preferredStyle: .alert)

        alertTopUpBalance.addTextField { (textField) in
            textField.placeholder = "Amount"
            textField.keyboardType = .decimalPad
            textField.delegate = self
        }

        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let topUpAction: UIAlertAction = UIAlertAction(title: "Top Up", style: .default) { [weak self] _ in
            let topUpSum: Double? = Double(alertTopUpBalance.textFields?.first?.text ?? "")
            self?.presenter.updateBalance(amount: topUpSum)
        }

        alertTopUpBalance.addAction(cancelAction)
        alertTopUpBalance.addAction(topUpAction)
        present(alertTopUpBalance, animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters: CharacterSet = CharacterSet(charactersIn: "0123456789.").union(.init(charactersIn: ""))
        let isValid: Bool = string.rangeOfCharacter(from: allowedCharacters.inverted) == nil

        let currentText: String = textField.text ?? ""
        let newString: String = (currentText as NSString).replacingCharacters(in: range, with: string)
        let components: [String] = newString.components(separatedBy: ".")
        let numberOfDecimals: Int = components.count - 1

        return isValid && numberOfDecimals <= 1
    }
}
