//
//  TeamCollectionViewCell.swift
//  TestFDJ
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

import UIKit
import Kingfisher

final class TeamCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets

    private lazy var logoImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()

    // MARK: - Init

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logoImageView)
        logoImageView.attachEdges()
    }

    // MARK: - Configure

    func configure(with viewModel: TeamCellViewModel) -> Self {
        logoImageView.kf.setImage(with: URL(string: viewModel.logoUrl))
        return self
    }
}
