//
//  PeopleViewController.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import UIKit

class PeopleViewController: UIViewController {
    
    typealias Row = PeopleDataController.Row
    
    enum TableViewSection: Int {
        case people
        case loading
    }
    
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    
    let dataController = PeopleDataController(peopleService: ApplicationDataController.shared.serviceFactory.getPeopleService())
    
    lazy var snapshotProvider = NSDiffableDataSourceSnapshot<TableViewSection, Row>()
    
    lazy var peopleDataSource = UITableViewDiffableDataSource<TableViewSection, Row>(tableView: tableView) { tableView, indexPath, row in
        switch row {
        case .people(let person):
            let cell = tableView.dequeueReusableCell(withIdentifier: SubtitleTableViewCell.identifier,
                                                     for: indexPath) as! SubtitleTableViewCell
            cell.configure(titleText: person.name, subtitleText: person.gender)
            return cell
        case .loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.identifier,
                                                     for: indexPath) as! LoadingTableViewCell
            return cell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "People"
        configureTableView()
        applySnapshot()
        render(.loading)
        dataController.load { [weak self] state in
            self?.render(state)
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.register(SubtitleTableViewCell.self,
                           forCellReuseIdentifier: SubtitleTableViewCell.identifier)
        tableView.register(UINib(nibName: LoadingTableViewCell.identifier, bundle: .main),
                           forCellReuseIdentifier: LoadingTableViewCell.identifier)
    }
    
    private func applySnapshot() {
        snapshotProvider.appendSections([.people, .loading])
        peopleDataSource.apply(snapshotProvider, animatingDifferences: false)
    }
    
    private func refreshUI(persons: [Row]) {
        var snapshot = self.peopleDataSource.snapshot()
        snapshot.appendItems(persons, toSection: .people)
        if snapshot.itemIdentifiers(inSection: .loading).isEmpty {
            snapshot.appendItems(dataController.loadingRow,toSection: .loading)
        }
        peopleDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func render(_ state: PeopleDataController.State) {
        DispatchQueue.main.async {
            switch state {
            case .loading:
                self.activityIndicatorView.startAnimating()
                self.view.sendSubviewToBack(self.tableView)
            case .presenting(let persons):
                self.refreshUI(persons: persons)
                self.activityIndicatorView.stopAnimating()
            case .failed(let error):
                print(error)
            }
        }
    }
}

extension PeopleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == TableViewSection.people.rawValue,
        let person = dataController.person(at: indexPath.row) else {
            return
        }
        let filmService = dataController.serviceFactory.getFilmService()
        let personDetailVC = PersonViewControllerFactory.makePersonDetailViewController(person: person, filmService: filmService)
        navigationController?.pushViewController(personDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = TableViewSection(rawValue: indexPath.section),
              section == .loading else {
            return
            
        }
        dataController.load { state in
            self.render(state)
            self.hideBottomLoader()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !dataController.canFetchMoreData,
           indexPath.section == TableViewSection.loading.rawValue {
            return 0
        }
        return UITableView.automaticDimension
    }
    
    private func hideBottomLoader() {
        guard let _ = dataController.people else {
            return
        }
        DispatchQueue.main.async {
            let lastListIndexPath = IndexPath(row: self.dataController.persons.count - 1, 
                                              section: TableViewSection.people.rawValue)
            self.tableView.scrollToRow(at: lastListIndexPath, at: .bottom, animated: true)
        }
    }
}
