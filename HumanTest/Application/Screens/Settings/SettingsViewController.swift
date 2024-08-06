//
//  SettingsViewController.swift
//  HumanTest
//

import UIKit
import SnapKit
import Combine

typealias SettingsDataSource = UITableViewDiffableDataSource<SimpleSection, SettingsModel>
typealias SettingsSnapshot = NSDiffableDataSourceSnapshot<SimpleSection, SettingsModel>

final class SettingsViewController: BaseViewController {
        
    private let titleLabel = BaseLabel(text: "Settings", color: .lightGray,
                                       font: UIFont.systemFont(ofSize: 32, weight: .bold))
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    // may being in VM
    private lazy var dataSource: SettingsDataSource = buildDataSource()
    private var modelSubject = CurrentValueSubject<[SettingsModel], Never>([SettingsModel(name: "Dźmitryj Łapata")])
    var modelPublisher: AnyPublisher<[SettingsModel], Never> {
        modelSubject.eraseToAnyPublisher()
    }
    // end VM data

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
    }
    
}


// MARK: - Configure
private extension SettingsViewController {
    func configure() {
        configureTableView()
        registerCells()
        addSubviews()
        makeConstraints()
        bind()
    }
    
    
    func addSubviews() {
        view.addSubviews(titleLabel,
                         tableView)
    }
    
    func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(16)
            $0.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func configureSnapshot(with items: [SettingsModel]) -> SettingsSnapshot {
        var snapshot = SettingsSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        return snapshot
    }
    
    func bind() {
        modelPublisher.sink { [weak self] items in
            guard let snapshot = self?.configureSnapshot(with: items) else { return }
            self?.dataSource.apply(snapshot, animatingDifferences: false)
        }
        .store(in: &cancelables)
    }
}


// MARK: - Delegate
extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        showAlert(title: "Hello)", message: item.name)
    }
}

// MARK: - Configure UITableView
private extension SettingsViewController {
    func configureTableView() {
        tableView.delegate = self
        tableView.backgroundColor = .clear
    }

    func buildDataSource() -> SettingsDataSource {
        return SettingsDataSource(tableView: tableView) { [weak self] tableView, indexPath, item in
            return self?.getSettingCell(indexPath: indexPath, cellModel: item)
        }
    }

    func registerCells() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseID)
    }

    func getSettingCell(indexPath: IndexPath, cellModel: SettingsModel) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = "About application"
        content.textProperties.color = .black
        cell.contentConfiguration = content
        cell.backgroundColor = .lightGray
        return cell
    }

}

struct SettingsModel: Hashable {
    let name: String
}
