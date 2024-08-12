//
//  K.swift
//  ITAcademy_SecretStorage
//
//  Created by Влад Муравьев on 30.05.2024.
//

import UIKit

enum K {
    
    // MARK: - KEYS
    static let imageObjectKey = "imageObject"
    
    // MARK: - SIZES
    static let headerHeight: CGFloat = 100
    static let footerHeight: CGFloat = 110
    static let textViewHeight: CGFloat = 100
    static let saveButtonWidth: CGFloat = 100
    
    static let cornerRadius: CGFloat = 10
    
    // MARK: - PADDINGS
    static let footerButtonOffset: CGFloat = 40
    static let footerButtonOffsetTop: CGFloat = 15
    static let headerButtonLeftOffset: CGFloat = 24
    static let headerButtonBottomOffset: CGFloat = 5
    static let appNameOffset: CGFloat = 40
    static let appNameOffsetTop: CGFloat = 50
    static let textViewOffset: CGFloat = 20
    static let textViewContentInset: CGFloat = 10
    static let saveButtonOffsetBottom: CGFloat = 50
    static let cellPadding: CGFloat = 16
    
    // MARK: - COLORS
    static let backgroundColor: UIColor  = UIColor(red: 0.47, green: 0.44, blue: 0.65, alpha: 1.00)
    static let footerColor: UIColor = UIColor(red: 0.25, green: 0.25, blue: 0.48, alpha: 1.00)
    static let headerColor: UIColor = UIColor(red: 0.19, green: 0.22, blue: 0.32, alpha: 1.00)
    static let saveButtonColor: UIColor = UIColor(red: 0.60, green: 0.50, blue: 0.98, alpha: 1.00)
    
    static let textViewAlpha: CGFloat = 0.25
    
    // MARK: - TEXT
    static let appName: String = "S#CR#T_ST0R4G#"
    static let back: String = "Back"
    static let plus: String = "+"
    static let save: String = "Save"
    static let arrowLeft: String = "←"
    static let arrowRight: String = "→"
    static let heart: String = "♥︎"
    static let filterLabel: String = "Filter by favorites"
    
    static let alertTitle: String = "Unsaved changes"
    static let alertMessage: String = "If you leave, your changes will not be saved"
    static let leave: String = "Leave"
    static let cancel: String = "Cancel"
    static let stay: String = "Stay"
    static let ok: String = "OK"
    
    static let imagePickerMessage: String = "Select the source"
    static let library: String = "Photo Library"
    static let camera: String = "Camera"
    
    // MARK: - TEXT SIZES
    static let headerLabelTextSize: CGFloat = 20
    static let footerTextSize: CGFloat = 60
    static let backButtonTextSize: CGFloat = 20
    static let dateLabelTextSize: CGFloat = 15
    static let likeButtonTextSize: CGFloat = 32
    static let textViewTextSize: CGFloat = 18
    
    // MARK: - MISC
    
    static let animationDuration: CGFloat = 0.3
    static let cellRowCount: Int = 4
}
