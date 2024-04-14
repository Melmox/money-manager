//
//  AddTransactionViewController.swift
//  money-manager
//
//  Created by developer on 14.04.2024.
//

import UIKit

protocol IAddTransactionViewController: UIViewController, ActivityShowable {
    func setup(with viewModel: AddTransactionViewModel)
}

final class AddTransactionViewController: BaseViewController, IAddTransactionViewController {
    
    // MARK: - UI Elements
    
    private let svContainer: UIStackView = UIStackView()
    private let tfAmount: UITextField = UITextField()
    private let btChooseCategory: UIButton = UIButton()
    private let btAdd: UIButton = UIButton()
    
    // MARK: - Properties
    
    private let presenter: IAddTransactionPresenter
    
    // MARK: - Initialization
    
    init(presenter: IAddTransactionPresenter) {
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
        self.view.backgroundColor = .systemBackground
        self.navigationController?.isNavigationBarHidden = false
        
        setupSvContainer()
        setupTfAmount()
        setupBtChooseCategory()
        setupBtAdd()
    }
    
    private func setupSvContainer() {
        view.addSubview(svContainer)
        
        svContainer.axis = .horizontal
        svContainer.alignment = .fill
        svContainer.distribution = .fillProportionally
        svContainer.spacing = 8
        
        svContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            svContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            svContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            svContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupTfAmount() {
        svContainer.addArrangedSubview(tfAmount)
        tfAmount.delegate = self
    }
    
    private func setupBtChooseCategory() {
        svContainer.addArrangedSubview(btChooseCategory)
        btChooseCategory.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    private func setupBtAdd() {
        view.addSubview(btAdd)
                
        btAdd.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btAdd.topAnchor.constraint(equalTo: svContainer.bottomAnchor, constant: 24),
            btAdd.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            btAdd.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            btAdd.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - IAddTransactionViewController
    
    func setup(with viewModel: AddTransactionViewModel) {
        tfAmount.setup(with: viewModel.tfAmount)
        btChooseCategory.setup(with: viewModel.btChooseCategory)
        btAdd.setup(with: viewModel.btAdd)
    }
}

// MARK: - UITextFieldDelegate

extension AddTransactionViewController: UITextFieldDelegate {
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
