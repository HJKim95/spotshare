//
//  EditProfileController.swift
//  SpotShare
//
//  Created by 김희중 on 14/01/2020.
//  Copyright © 2020 김희중. All rights reserved.
//

import UIKit
import YPImagePicker

class EditProfileController: UIViewController {
    
    deinit {
        print("no retain cycle in EditProfileController")
    }
    
    lazy var backImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "back")
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        return iv
    }()
    
    let editProfileLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Medium", size: 28)
        // letter spacing -0.3
        let attributedString = NSMutableAttributedString(string: "Edit Profile")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.3), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .black
        return lb
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "imsi_user")
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    lazy var profileImageFadeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editProfImage)))
        return view
    }()
    
    let changePhotoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "changePhoto")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let editNameView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.rgb(red: 240, green: 240, blue: 240).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let editTItleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Regular", size: 12)
        // letter spacing 0.0
        let attributedString = NSMutableAttributedString(string: "Your Name")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0.0), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .gray
        return lb
    }()
    
    let editNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Regular", size: 16)
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Jane Doe")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .darkGray
        return lb
    }()
    
    lazy var saveChangeLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Bold", size: 14)
        // letter spacing 1.0
        let attributedString = NSMutableAttributedString(string: "SAVE CHANGES")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.textColor = .white
        lb.backgroundColor = .mainColor
        lb.alpha = 0.5
        lb.layer.cornerRadius = 12
        lb.layer.masksToBounds = true
        lb.isUserInteractionEnabled = true
        lb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(saveChanges)))
        return lb
    }()
    
    var backImageViewConstraint: NSLayoutConstraint?
    var editProfileLabelConstraint: NSLayoutConstraint?
    var profileImageViewConstraint: NSLayoutConstraint?
    var profileImageFadeViewConstraint: NSLayoutConstraint?
    var changePhotoImageViewConstraint: NSLayoutConstraint?
    var editNameViewConstraint: NSLayoutConstraint?
    var editTitleLabelConstraint: NSLayoutConstraint?
    var editNameLabelConstraint: NSLayoutConstraint?
    var saveChangeLabelConstraint: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // swipe로 back 구현하려면 두개 다 써줘야함.
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        view.addSubview(backImageView)
        view.addSubview(editProfileLabel)
        view.addSubview(profileImageView)
        view.addSubview(profileImageFadeView)
        view.addSubview(changePhotoImageView)
        view.addSubview(editNameView)
        view.addSubview(editTItleLabel)
        view.addSubview(editNameLabel)
        view.addSubview(saveChangeLabel)
        
        if #available(iOS 11.0, *) {
            backImageViewConstraint = backImageView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
            editProfileLabelConstraint = editProfileLabel.anchor(backImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 38).first
            profileImageViewConstraint = profileImageView.anchor(editProfileLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 210).first
            profileImageFadeViewConstraint = profileImageFadeView.anchor(profileImageView.topAnchor, left: profileImageView.leftAnchor, bottom: profileImageView.bottomAnchor, right: profileImageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
            changePhotoImageViewConstraint = changePhotoImageView.anchor(profileImageView.topAnchor, left: profileImageView.leftAnchor, bottom: nil, right: nil, topConstant: 69, leftConstant: 128, bottomConstant: 0, rightConstant: 0, widthConstant: 72, heightConstant: 72).first
            editNameViewConstraint = editNameView.anchor(profileImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 56).first
            editTitleLabelConstraint = editTItleLabel.anchor(editNameView.topAnchor, left: editNameView.leftAnchor, bottom: nil, right: editNameView.rightAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 16).first
            editNameLabelConstraint = editNameLabel.anchor(nil, left: editNameView.leftAnchor, bottom: editNameView.bottomAnchor, right: editNameView.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 8, rightConstant: 12, widthConstant: 0, heightConstant: 26).first
            saveChangeLabelConstraint = saveChangeLabel.anchor(editNameView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 56).first
            
        }
        else {
            backImageViewConstraint = backImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
            editProfileLabelConstraint = editProfileLabel.anchor(backImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 38).first
            profileImageViewConstraint = profileImageView.anchor(editProfileLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 210).first
            profileImageFadeViewConstraint = profileImageFadeView.anchor(profileImageView.topAnchor, left: profileImageView.leftAnchor, bottom: profileImageView.bottomAnchor, right: profileImageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
            changePhotoImageViewConstraint = changePhotoImageView.anchor(profileImageView.topAnchor, left: profileImageView.leftAnchor, bottom: nil, right: nil, topConstant: 69, leftConstant: 128, bottomConstant: 0, rightConstant: 0, widthConstant: 72, heightConstant: 72).first
            editNameViewConstraint = editNameView.anchor(profileImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 56).first
            editTitleLabelConstraint = editTItleLabel.anchor(editNameView.topAnchor, left: editNameView.leftAnchor, bottom: nil, right: editNameView.rightAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 16).first
            editNameLabelConstraint = editNameLabel.anchor(nil, left: editNameView.leftAnchor, bottom: editNameView.bottomAnchor, right: editNameView.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 8, rightConstant: 12, widthConstant: 0, heightConstant: 26).first
            saveChangeLabelConstraint = saveChangeLabel.anchor(editNameView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 56).first
        }
    }
    
    @objc fileprivate func editProfImage() {
        print(123123123)
        var config = YPImagePickerConfiguration()
        config.albumName = "DefaultYPImagePickerAlbumName"
        config.startOnScreen = YPPickerScreen.photo
        config.screens = [.library]
        config.showsCrop = .none
//        config.targetImageSize = YPImageSize.original
        config.overlayView = UIView()
        config.hidesStatusBar = true
        config.hidesBottomBar = false
        config.preferredStatusBarStyle = UIStatusBarStyle.default
//        config.bottomMenuItemSelectedColour = UIColor(r: 38, g: 38, b: 38)
//        config.bottomMenuItemUnSelectedColour = UIColor(r: 153, g: 153, b: 153)
        config.library.options = nil
        config.library.onlySquare = false
        config.library.isSquareByDefault = true
        config.library.minWidthForItem = nil
        config.library.mediaType = YPlibraryMediaType.photo
        config.library.defaultMultipleSelection = true
        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 4
        config.library.spacingBetweenItems = 1.0
        config.library.skipSelectionsGallery = false
        config.library.preselectedItems = nil
        YPImagePickerConfiguration.shared = config
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.profileImageView.image = photo.image
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                
            }
            picker.dismiss(animated: true) {
                self.saveChangeLabel.alpha = 1
            }
        }
        present(picker, animated: true, completion: nil)
    }
    
    @objc fileprivate func saveChanges() {
        // 우선 임시
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
