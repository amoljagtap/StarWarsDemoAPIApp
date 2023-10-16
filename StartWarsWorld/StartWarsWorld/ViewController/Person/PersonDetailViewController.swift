//
//  PersonDetailViewController.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import UIKit

class PersonDetailViewController: UIViewController {
    
    enum TableViewSection {
        case profile
        case film
    }
    
    @IBOutlet var profileView: PersonProfileView!
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    var dataController: PersonDataController?
    
    lazy var snapshotProvider = NSDiffableDataSourceSnapshot<TableViewSection, Film>()
    
    var filmDataSource: UICollectionViewDiffableDataSource<TableViewSection, Film>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProfileView()
        configureFilmsCollectionVIew()
        render(.loading)
        dataController?.loadFilms { [weak self] state in
            self?.render(state)
        }
    }
    
    private func configureProfileView() {
        guard let person = dataController?.person else {
            return
        }
        profileView.set(name: person.name,
                        dob: person.birth_year,
                        gender: person.gender)
    }
    
    private func configureFilmsCollectionVIew() {
        let sectionLayout = filmsContinuousFlowSection()
        collectionView.collectionViewLayout =  UICollectionViewCompositionalLayout(section: sectionLayout)
        collectionView.register(UINib(nibName: "FilmTileCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "FilmTileCollectionViewCell")
        configureFilmsDataSource()
    }
    
    private func configureFilmsDataSource() {
        filmDataSource = UICollectionViewDiffableDataSource<TableViewSection, Film>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, film: Film) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmTileCollectionViewCell.identifier, for: indexPath) as! FilmTileCollectionViewCell
            cell.set(title: film.title, releaseDate: film.release_date)
            return cell
        }
    }
    
    private func applyFilmsSnapshot(_ films: [Film]) {
        snapshotProvider.appendSections([.film])
        snapshotProvider.appendItems(films, toSection: .film)
        filmDataSource?.apply(snapshotProvider, animatingDifferences: false)
        collectionView.dataSource = filmDataSource
    }
    
    private func filmsContinuousFlowSection()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1)
                                              , heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7)
                                               , heightDimension: .absolute(180))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize
                                                       , subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0
                                                      , bottom: 0, trailing: 15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15
                                                        , bottom: 10, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.8
                let maxScale: CGFloat = 1.0
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        return section
    }
    
    private func render(_ state: PersonDataController.State) {
        DispatchQueue.main.async {
            switch state {
            case .loading:
                self.activityIndicatorView.startAnimating()
                self.view.sendSubviewToBack(self.collectionView)
            case .presenting(let films):
                self.applyFilmsSnapshot(films)
                self.activityIndicatorView.stopAnimating()
            case .failed(let error):
                print(error)
            }
        }
    }
    
    private func refreshUI(films: [Film]) {
        guard let filmDataSource = filmDataSource else {
            return
        }
        var snapshot = filmDataSource.snapshot()
        snapshot.appendItems(films, toSection: .film)
        filmDataSource.apply(snapshot, animatingDifferences: true)
    }
    
}
