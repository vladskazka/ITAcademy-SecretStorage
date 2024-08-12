//
//  ContentViewController.swift
//  ITAcademy_SecretStorage
//
//  Created by Влад Муравьев on 30.05.2024.
//

import UIKit

enum Direction {
    case left
    case right
}

class ContentViewController: UIViewController {
    
    private let loadImages: Any? = {
        ImageManager.shared.loadImages()
        return nil
    }()
    
    // MARK: - Properties: Containers
    
    private let superContainer = UIView()
    
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
    
    private let descriptionContainer: UIView = {
        let view = UIView()
        view.backgroundColor = K.backgroundColor
        return view
    }()
    
    private let footerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = K.footerColor
        return view
    }()
    
    // MARK: - Properties: Buttons
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle(K.back, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.systemGray3, for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: K.backButtonTextSize, weight: .regular)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setTitle(K.heart, for: .normal)
        if let isLiked = ImageManager.shared.getImageObject(atIndex: index)?.isLiked {
            button.setTitleColor(isLiked ? .systemPink : .systemGray4, for: .normal)
            self.isLiked = isLiked
        } else {
            button.setTitleColor(.systemGray4, for: .normal)
        }
        button.setTitleColor(.systemGray3, for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: K.likeButtonTextSize, weight: .thin)
        return button
    }()
    
    private let arrowLeftButton: UIButton = {
        let button = UIButton()
        button.setTitle(K.arrowLeft, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.systemGray3, for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: K.footerTextSize, weight: .regular)
        return button
    }()
    
    private let arrowRightButton: UIButton = {
        let button = UIButton()
        button.setTitle(K.arrowRight, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.systemGray3, for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: K.footerTextSize, weight: .regular)
        return button
    }()
    
    // MARK: - Properties: Images
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        if let name = ImageManager.shared.getImageObject(atIndex: index)?.name {
            imageView.image = DataManager.shared.loadImage(name)
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var assistantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        if let name = ImageManager.shared.getImageObject(atIndex: index)?.name {
            imageView.image = DataManager.shared.loadImage(name)
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // MARK: - Properties: Other UI Elements
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = ImageManager.shared.getImageObject(atIndex: index)?.date
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: K.dateLabelTextSize, weight: .heavy)
        return label
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = ImageManager.shared.getImageObject(atIndex: index)?.description
        textView.tintColor = K.backgroundColor
        textView.textColor = .white
        textView.font = .systemFont(ofSize: K.textViewTextSize)
        textView.layer.cornerRadius = K.cornerRadius
        textView.textContainerInset = UIEdgeInsets(top: K.textViewContentInset, left: K.textViewContentInset, bottom: K.textViewContentInset, right: K.textViewContentInset)
        textView.backgroundColor = .black.withAlphaComponent(K.textViewAlpha)
        return textView
    }()
    
    // MARK: - Properties: Logic
    
    private let contentModel: IContentModel = ContentModel()
    
    private var isImageFullScreen: Bool = false
    private lazy var isLiked: Bool = false
    private var isChangesMade: Bool = false
    
    private var imageFrame: CGRect = .zero
    
    var index: Int = .zero
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self

        setupUI()
        setupNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        assistantImageView.removeFromSuperview()
    }
    
    deinit {
        print("Deinit")
    }
    
    
    // MARK: - UI Setup Functions
    
    private func setupUI() {
        
        view.addSubview(superContainer)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(recognizer)
        
        view.addSubview(headerContainer)
        
        superContainer.addSubview(middleContainer)
        superContainer.addSubview(descriptionContainer)
        superContainer.addSubview(footerContainer)
        
        headerContainer.addSubview(backButton)
        headerContainer.addSubview(likeButton)
        headerContainer.addSubview(dateLabel)
        
        middleContainer.addSubview(imageView)
        
        descriptionContainer.addSubview(textView)
        
        footerContainer.addSubview(arrowLeftButton)
        footerContainer.addSubview(arrowRightButton)
        
        view.addSubview(assistantImageView)
        
        superContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        headerContainer.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(K.headerHeight)
        }
        
        middleContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(K.headerHeight)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(descriptionContainer.snp.top)
        }
        
        descriptionContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(footerContainer.snp.top)
            make.height.equalTo(K.textViewHeight)
        }
        
        footerContainer.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(K.footerHeight)
        }
        
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(K.headerButtonLeftOffset)
            make.bottom.equalToSuperview().inset(K.headerButtonBottomOffset)
        }
        
        let backAction = UIAction { [weak self] _ in
            self?.backButtonPressed()
        }
        
        backButton.addAction(backAction, for: .touchUpInside)
        
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(15)
        }
        
        likeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(K.headerButtonLeftOffset)
            make.bottom.equalToSuperview()
        }
        
        let likeButtonAction = UIAction { [weak self] _ in
            self?.likeButtonPressed()
        }
        
        likeButton.addAction(likeButtonAction, for: .touchUpInside)
        
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(K.textViewOffset)
        }
        
        arrowRightButton.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().inset(K.footerButtonOffset)
            make.top.equalToSuperview().inset(K.footerButtonOffsetTop)
            make.width.equalTo(arrowLeftButton.snp.height)
        }
        
        let arrowRightAction = UIAction { [weak self] _ in
            self?.moveImage(direction: .right)
        }
        
        arrowRightButton.addAction(arrowRightAction, for: .touchUpInside)
        
        arrowLeftButton.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview().inset(K.footerButtonOffset)
            make.top.equalToSuperview().inset(K.footerButtonOffsetTop)
            make.width.equalTo(arrowLeftButton.snp.height)
        }
        
        let arrowLeftAction = UIAction { [weak self] _ in
            self?.moveImage(direction: .left)
        }
        
        arrowLeftButton.addAction(arrowLeftAction, for: .touchUpInside)
        
        view.layoutIfNeeded()
        
        setupImage()
    }
    
    
    private func setupImage() {
        
        let width = middleContainer.frame.width * 0.8
        let height = middleContainer.frame.height * 0.8
        let paddingX = (middleContainer.frame.width - width) / 2
        let paddingY = (middleContainer.frame.height - height) / 2
        
        imageView.frame = CGRect(x: paddingX, y: paddingY, width: width, height: height)
        
        assistantImageView.frame.size = imageView.frame.size
        assistantImageView.frame.origin = CGPoint(x: paddingX, y: paddingY + K.headerHeight)
        imageFrame = assistantImageView.frame
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(showFullScreenImage))
        assistantImageView.addGestureRecognizer(recognizer)
    }
    
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(moveContentWithKeyboard(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveContentWithKeyboard(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - UIButton Functions
    
    private func backButtonPressed() {
        if isChangesMade {
            updateImageObject()
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    private func likeButtonPressed() {
        isLiked.toggle()
        isChangesMade = true
        UIView.transition(with: likeButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.likeButton.setTitleColor(self.isLiked ? .systemPink : .systemGray4, for: .normal)
        })
    }
    
    
    private func enableButtons(_ enable: Bool = true) {
        arrowLeftButton.isEnabled = enable
        arrowRightButton.isEnabled = enable
    }
    
    // MARK: - Flow Functions
    
    @objc private func moveContentWithKeyboard(_ notification: Notification) {
        
        isChangesMade = true
        
        guard let info = notification.userInfo,
              let duration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let frame = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            assistantImageView.isHidden = true
            superContainer.snp.updateConstraints { make in
                make.top.bottom.equalToSuperview().offset(-frame.height + K.footerHeight)
            }
        }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            superContainer.snp.updateConstraints { make in
                make.top.bottom.equalToSuperview()
            }
        }
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func moveImage(direction: Direction) {

        assistantImageView.isHidden = false
        
        guard var imageCount = ImageManager.shared.getImageCount() else { return }
        
        guard imageCount > 1 else { return }
        
        if isChangesMade {
            updateImageObject()
            if let newCount = ImageManager.shared.getImageCount() {
                if newCount < imageCount {
                    imageCount -= 1
                    if direction == .right {
                        index -= 1
                    }
                }
            }
        }
        
        index = contentModel.setNewIndex(movingTo: direction, with: imageCount, index)
        
        print("index when moved \(index), count \(imageCount)")
        guard let imageObject = ImageManager.shared.getImageObject(atIndex: index),
              let image = DataManager.shared.loadImage(imageObject.name) else { return }

        enableButtons(false)
        
        switch direction {
            
        case .left:
            
            imageView.image = image
            assistantImageView.frame.origin.x = imageFrame.origin.x
            
            UIView.animate(withDuration: 0.5) {
                self.assistantImageView.frame.origin.x = self.middleContainer.frame.origin.x - self.imageView.frame.width
            } completion: { [weak self] _ in
                self?.assistantImageView.image = image
                self?.configureContent(with: imageObject)
            }
        case .right:
            
            assistantImageView.frame.origin.x = middleContainer.frame.width
            assistantImageView.image = image
            
            UIView.animate(withDuration: 0.5) {
                self.assistantImageView.frame = self.imageFrame
            } completion: { [weak self] _ in
                self?.imageView.image = image
                self?.configureContent(with: imageObject)
            }
        }
        
        isChangesMade = false
    }
    
    func updateImageObject() {
        guard let imageObject = ImageManager.shared.getImageObject(atIndex: index) else { return }
        ImageManager.shared.updateImageArray(with: imageObject.name, description: textView.text, like: isLiked)
    }
    
    
    private func configureContent(with imageObject: Image) {
        dateLabel.text = imageObject.date
        isLiked = imageObject.isLiked
        likeButton.setTitleColor(isLiked ? .systemPink : .systemGray4, for: .normal)
        textView.text = imageObject.description
        enableButtons()
    }
    
    
    @objc private func showFullScreenImage() {
        
        if !isImageFullScreen {
            UIView.animate(withDuration: K.animationDuration) {
                self.assistantImageView.frame = CGRect(x: .zero, y: .zero, width: self.view.frame.width, height: self.view.frame.height)
                self.assistantImageView.backgroundColor = .black
            }
            isImageFullScreen.toggle()
        } else {
            UIView.animate(withDuration: K.animationDuration) {
                self.assistantImageView.frame = self.imageFrame
                self.assistantImageView.backgroundColor = .clear
            }
            isImageFullScreen.toggle()
        }
    }
}

// MARK: - UITextViewDelegate Functions

extension ContentViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            hideKeyboard()
            return false
        } else {
            return true
        }
    }
    
    @objc private func hideKeyboard() {
        textView.resignFirstResponder()
    }
    
}
