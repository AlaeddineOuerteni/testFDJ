//
//  SearchViewController.swift
//  TestFDJ
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

import RxSwift
import UIKit

final class SearchViewController: UIViewController {
    private enum Config {
        enum Sizes {
            static let spacing: CGFloat = 16
            static let cellHeightRatio: CGFloat = 1
        }
    }

    private let viewModel: SearchViewModel
    private let disposeBag = DisposeBag()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Config.Sizes.spacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.setContentCompressionResistancePriority(.required, for: .horizontal)
        collectionView.keyboardDismissMode = .onDrag
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TeamCollectionViewCell.self)
        return collectionView
    }()

    init(viewModel: SearchViewModel = SearchViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white

        viewModel.onTeamsDataChanged = { [weak self] in
            Runner.runOnMainThread {
                self?.collectionView.reloadData()
            }
        }
        addBlurEffect()
        addSearchBar()
        addCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addBlurEffect() {
        let bounds = self.navigationController?.navigationBar.bounds
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = bounds ?? .zero
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        navigationController?.navigationBar.addSubview(visualEffectView)
    }

    private func addSearchBar() {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    private func addCollectionView() {
        view.addSubview(collectionView)
        collectionView.attachEdges()
    }
}

// MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.teamCellViewModels?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let celViewModel = viewModel.teamCellViewModels?[indexPath.row] else { return UICollectionViewCell() }
        let cell: TeamCollectionViewCell = collectionView.findCell(indexPath: indexPath)
        return cell.configure(with: celViewModel)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let totalWidth = collectionView.frame.width
        let itemWidth = (totalWidth - Config.Sizes.spacing) / 2
        let itemHeight = itemWidth * Config.Sizes.cellHeightRatio
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.onSearchChanged(searchText)
    }
}
