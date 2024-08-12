//
//  ImageCollectionViewCell.swift
//  ITAcademy_SecretStorage
//
//  Created by Влад Муравьев on 18.06.2024.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    static var id: String { "\(Self.self)"}
    
    private let plusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.backgroundColor = .systemYellow
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(plusLabel)
        
        imageView.layer.cornerRadius = 10
        
        plusLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        plusLabel.text = nil
        imageView.image = nil
    }
    
    func configureCell(viewModel: Image) {
        plusLabel.text = nil
        imageView.image = DataManager.shared.loadImage(viewModel.name)
    }
    
    func configureAddNewCell() {
        plusLabel.text = K.plus
        imageView.image = nil
    }
    
}
