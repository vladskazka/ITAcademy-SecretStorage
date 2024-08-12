//
//  AddNewContentViewController.swift
//  ITAcademy_SecretStorage
//
//  Created by Влад Муравьев on 01.06.2024.
//

import UIKit

class AddNewContentViewController: UIViewController {
    
    
        /// there was a reason why I added this property, but it works fine without it
//    private let loadImages: Any? = {
//        ImageManager.shared.loadImages()
//        return nil
//    }()
    
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
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setTitle(K.heart, for: .normal)
        button.setTitleColor(.systemGray4, for: .normal)
        button.setTitleColor(.systemGray3, for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: K.likeButtonTextSize, weight: .thin)
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle(K.save, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.systemGray3, for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: K.backButtonTextSize, weight: .regular)
        button.backgroundColor = K.saveButtonColor
        button.layer.cornerRadius = K.cornerRadius
        return button
    }()
    
    // MARK: - Properties: Other UI Elements
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.tintColor = K.backgroundColor
        textView.textColor = .white
        textView.font = .systemFont(ofSize: K.textViewTextSize)
        textView.layer.cornerRadius = K.cornerRadius
        textView.textContainerInset = UIEdgeInsets(top: K.textViewContentInset, left: K.textViewContentInset, bottom: K.textViewContentInset, right: K.textViewContentInset)
        textView.backgroundColor = .black.withAlphaComponent(K.textViewAlpha)
        return textView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray4
        imageView.image = UIImage(systemName: "plus")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = .white
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // MARK: - Properties: Logic
    
    weak var delegate: ImageDelegate?
    
    private var imageFrame: CGRect = .zero
    private var isImageAdded: Bool = false
    private var isImageFullScreen: Bool = false
    private var isLiked: Bool = false
    private var isSaved: Bool = true
    private var currentImageName: String?
    
    // MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        
        setupUI()
        setupNotifications()
    }
    
    deinit {
        print("Deinit")
    }
    
    // MARK: - UI Setup Functions
    
    private func setupUI() {
        view.backgroundColor = K.headerColor
        view.addSubview(superContainer)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(recognizer)
        
        view.addSubview(headerContainer)
        
        superContainer.addSubview(descriptionContainer)
        superContainer.addSubview(footerContainer)
        superContainer.addSubview(middleContainer)
        
        headerContainer.addSubview(backButton)
        headerContainer.addSubview(likeButton)
        
        middleContainer.addSubview(imageView)
        
        descriptionContainer.addSubview(textView)
        
        footerContainer.addSubview(saveButton)
        
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
        
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(K.textViewOffset)
        }
        
        saveButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(K.footerButtonOffsetTop)
            make.width.equalTo(K.saveButtonWidth)
            make.bottom.equalToSuperview().inset(K.saveButtonOffsetBottom)
        }
        
        let saveButtonAction = UIAction { [weak self] _ in
            self?.saveButtonPressed()
        }
        
        saveButton.addAction(saveButtonAction, for: .touchUpInside)
        
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(K.headerButtonLeftOffset)
            make.bottom.equalToSuperview().inset(K.headerButtonBottomOffset)
        }
        
        let backAction = UIAction { [weak self] _ in
            self?.backButtonPressed()
        }
        
        backButton.addAction(backAction, for: .touchUpInside)
        
        likeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(K.headerButtonLeftOffset)
            make.bottom.equalToSuperview()
        }
        
        let likeButtonAction = UIAction { [weak self] _ in
            self?.likeButtonPressed()
        }
        
        likeButton.addAction(likeButtonAction, for: .touchUpInside)
        
        view.layoutIfNeeded()
        setupImage()
    }
    
    private func setupImage() {
        
        let width = middleContainer.frame.width * 0.8
        let height = middleContainer.frame.height * 0.8
        let paddingX = (middleContainer.frame.width - width) / 2
        let paddingY = (middleContainer.frame.height - height) / 2 

        imageView.frame = CGRect(x: paddingX, y: paddingY, width: width, height: height)
        imageFrame = imageView.frame
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(imageButtonPressed))
        imageView.addGestureRecognizer(recognizer)
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(moveContentWithKeyboard(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveContentWithKeyboard(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - UIButton Functions
    
    private func backButtonPressed() {
        
        if !isSaved {
            showAlert(title: K.alertTitle, message: K.alertMessage, destruct: K.leave, cancel: K.stay) {
                self.delegate?.updateImageArray()
                self.navigationController?.popViewController(animated: true)
            } handlerCancel: { }
        } else if !isImageAdded {
            delegate?.updateImageArray()
            navigationController?.popViewController(animated: true)
        } else {
            delegate?.updateImageArray()
            openContentViewController()
        }
    }
    
    private func likeButtonPressed() {
        isLiked.toggle()
        UIView.transition(with: likeButton, duration: K.animationDuration, options: .transitionCrossDissolve, animations: {
            self.likeButton.setTitleColor(self.isLiked ? .systemPink : .systemGray4, for: .normal)
        })
    }
    
    @objc private func imageButtonPressed() {
        if isImageAdded {
            showFullScreenImage()
        } else {
            showImagePickerAlert()
        }
    }

    private func saveButtonPressed() {
        
        if let imageName = currentImageName {
            
            let imageObject = Image(name: imageName, date: getCurrentDate(), description: textView.text, isLiked: isLiked)
            ImageManager.shared.saveImageObject(newImage: imageObject)
            isSaved = true
            
            showAlert(title: "Saved successfully", message: "Would you like to see your collection or save more pictures?", destruct: "See", cancel: "Save more") {
                self.openContentViewController()
            } handlerCancel: {
                self.currentImageName = nil
                ImageManager.shared.loadImages()
//                self.isSaved = false
                self.imageView.image = UIImage(systemName: "plus")
                self.imageView.backgroundColor = .systemGray4
                self.imageView.contentMode = .scaleAspectFit
                self.isImageAdded.toggle()
                self.textView.text = ""
                self.likeButton.setTitleColor(.systemGray4, for: .normal)
                self.isLiked.toggle()
            }
        } else {
            print("No image added")
        }
    }
    
    // MARK: - Flow Functions
    
    @objc private func moveContentWithKeyboard(_ notification: Notification) {

        guard let info = notification.userInfo,
              let duration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let frame = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            superContainer.snp.updateConstraints { make in
                make.top.bottom.equalToSuperview().offset(-frame.height + K.footerHeight)
            }
            imageView.isUserInteractionEnabled = false
        }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            superContainer.snp.updateConstraints { make in
                make.top.bottom.equalToSuperview()
            }
            imageView.isUserInteractionEnabled = true
        }
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func showFullScreenImage() {
        
        if !isImageFullScreen {
            UIView.animate(withDuration: K.animationDuration) {
                self.headerContainer.alpha = 0
                self.imageView.frame = CGRect(x: .zero, y: -K.headerHeight, width: self.superContainer.frame.width, height: self.superContainer.frame.height)
                self.imageView.backgroundColor = .black
            }
            isImageFullScreen.toggle()
        } else {
            UIView.animate(withDuration: K.animationDuration) {
                self.headerContainer.alpha = 1
                self.imageView.frame = self.imageFrame
                self.imageView.backgroundColor = .clear
            }
            isImageFullScreen.toggle()
        }
    }
    
    private func getCurrentDate() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy h:mm a"
        print(formatter.string(from: currentDate))
        return formatter.string(from: currentDate)
    }
    
    private func showImagePickerAlert() {
        
        let alert = UIAlertController(title: nil, message: K.imagePickerMessage, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: K.camera, style: .default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.showImagePicker(source: .camera)
            }
        }
        
        alert.addAction(cameraAction)
        
        let photoLibraryAction = UIAlertAction(title: K.library, style: .default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.showImagePicker(source: .photoLibrary)
            }
        }
        
        alert.addAction(photoLibraryAction)
        
        let cancelAction = UIAlertAction(title: K.cancel, style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    
    private func showImagePicker(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = source
        present(imagePicker, animated: true)
    }
    
    
    private func openContentViewController() {
        let controller = ContentViewController()
        delegate?.updateImageArray()
        navigationController?.pushViewController(controller, animated: true)
    }
}

    // MARK: - UIImagePickerControllerDelegate Functions

extension AddNewContentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            isImageAdded.toggle()
            imageView.backgroundColor = .clear
            likeButton.isHidden = false
            isSaved = false
            
            if let imageName = DataManager.shared.saveImage(image) {
                currentImageName = imageName
            } else {
                print("Failed to save image to File Manager")
            }
        }
        
        picker.dismiss(animated: true)
    }
}

    // MARK: - UITextViewDelegate Functions

extension AddNewContentViewController: UITextViewDelegate {
    
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
