//
//  SuperPayDashboardViewController.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/03/22.
//

import ModernRIBs
import UIKit

protocol SuperPayDashboardPresentableListener: AnyObject {
    func topupButtonDidTap()
}

final class SuperPayDashboardViewController: UIViewController, SuperPayDashboardPresentable, SuperPayDashboardViewControllable {
    
    weak var listener: SuperPayDashboardPresentableListener?
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.text = "슈퍼페이 잔고"
        return label
    }()
    
    private lazy var topupButton: UIButton = {
        // button의 target을 설정하기 위해 lazy var로 함 (addTarget 메소드는 UIKit의 메소드이고, 버튼에 대한 target 설정임으로 self 사용)
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("충전하기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
        button.addTarget(self, action: #selector(topupButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        // corner radius가 좀 더 부드럽게 표현해줌
        view.backgroundColor = .systemIndigo
        
        return view
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.text = "원"
        label.textColor = .white
        return label
    }()
    
    private let balanceAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let balanceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        stackView.alignment = .fill
        return stackView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        view.addSubview(headerStackView)
        view.addSubview(cardView)
        
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(topupButton)
        
        cardView.addSubview(balanceStackView)
        balanceStackView.addArrangedSubview(balanceAmountLabel)
        balanceStackView.addArrangedSubview(currencyLabel)
        
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            cardView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 10),
            cardView.heightAnchor.constraint(equalToConstant: 180),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            balanceStackView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            balanceStackView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        ])
    }
    
    func updateBalance(_ balance: String) {
        balanceAmountLabel.text = balance
    }
    
    @objc
    private func topupButtonDidTap() {
        listener?.topupButtonDidTap()
    }
}
