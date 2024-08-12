//
//  ViewController.swift
//  ITAcademy_SecretStorage
//
//  Created by Влад Муравьев on 30.05.2024.
//

import UIKit
import SnapKit

protocol ImageDelegate: AnyObject {
    func updateImageArray()
}

class StartViewController: UIViewController {
    
    // MARK: - Properties: Containers

    private let headerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = K.headerColor
        return view
    }()
    
    private let middleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = K.backgroundColor
        return view
    }()
    
    private let footerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = K.footerColor
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: - Properties: Labels
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = K.appName
        label.textColor = .white
        label.font = .systemFont(ofSize: K.headerLabelTextSize, weight: .black)
        label.textAlignment = .center
        return label
    }()
    
    private let filterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = K.filterLabel
        label.font = .systemFont(ofSize: 25, weight: .light)
        label.sizeToFit()
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Properties: Other UI Elements
    
    private let likeSwitch: UISwitch = {
        let likeSwitch = UISwitch()
        likeSwitch.onTintColor = .systemYellow
        return likeSwitch
    }()
    
    // MARK: - Properties: Logic
    
    private var imageArray: [Image] = {
        ImageManager.shared.loadImages()
        if let array = ImageManager.shared.getImageArray() {
            return array
        } else {
            return []
        }
    }()
    
    private var isLoadedOnce: Bool = false
    
    // MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if isLoadedOnce {
            updateImageArray()
        }
        
        isLoadedOnce = true
    }
    
    // MARK: - UI Setup Functions
    
    private func setupUI() {
        
        view.addSubview(headerContainer)
        view.addSubview(middleContainer)
        view.addSubview(footerContainer)
        
        headerContainer.addSubview(appNameLabel)
        
        middleContainer.addSubview(collectionView)
        
        footerContainer.addSubview(filterLabel)
        footerContainer.addSubview(likeSwitch)
        
        headerContainer.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(K.headerHeight)
        }
        
        middleContainer.snp.makeConstraints { make in
            make.top.equalTo(headerContainer.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(footerContainer.snp.top)
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(K.cellPadding)
        }
        
        footerContainer.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(K.footerHeight)
        }
        
        appNameLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(K.appNameOffset)
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().inset(K.appNameOffsetTop)
        }
        
        filterLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(16)
            make.right.equalTo(likeSwitch.snp.left)
        }
        
        likeSwitch.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(16)
            make.bottom.equalTo(filterLabel.snp.bottom)
        }
        
        let switchAction = UIAction { [weak self] _ in
            self?.filterFavoriteImages()
        }
        
        likeSwitch.addAction(switchAction, for: .touchUpInside)
    }
    
    
    // MARK: - UIButton Functions

    private func plusButtonPressed() {
        pushAddContentViewController()
    }
    
    private func filterFavoriteImages() {
        if likeSwitch.isOn {
            ImageManager.shared.toggleFilter(true)
            imageArray = imageArray.filter { $0.isLiked }
            collectionView.reloadData()
        } else {
            ImageManager.shared.toggleFilter(false)
            updateImageArray()
        }
    }
    
    // MARK: - Flow Functions
    
    private func pushAddContentViewController() {
        let controller = AddNewContentViewController()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func pushContentViewController(at index: Int) {
        let controller = ContentViewController()
        controller.index = index
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UITextViewDelegate Functions

extension StartViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.id, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.row >= 1 {
            // viewModel will never be nil because if imageArray.isEmpty, this method will never be called
            cell.configureCell(viewModel: imageArray[indexPath.item - 1])
        } else {
            cell.configureAddNewCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let side = (collectionView.frame.size.width - (CGFloat(K.cellRowCount  - 1) * K.cellPadding)) / CGFloat(K.cellRowCount)
        
        return CGSize(width: side, height: side * 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        K.cellPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            pushAddContentViewController()
        } else {
            pushContentViewController(at: indexPath.item - 1)
        }
    }
}

// MARK: - ImageDelegate Functions

extension StartViewController: ImageDelegate {
    
    func updateImageArray() {
        ImageManager.shared.loadImages()
        if let newImageArray = ImageManager.shared.getImageArray() {
            imageArray = newImageArray
        }
        collectionView.reloadData()
    }
}

