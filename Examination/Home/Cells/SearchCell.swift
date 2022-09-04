//
//  SearchCell.swift
//  ExamApp
//
//  Created by Dan Albert Luab on 9/3/22.
//

import UIKit

class SearchCell: UITableViewCell {

    // MARK: - Properties
    
    // MARK: - UI Component
    private let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = false
        imageView.isUserInteractionEnabled = false
        return imageView
    }()

    private let descriptionLbl: BaseLabel = {
        let label = BaseLabel()
        label.configure(font: .godo_M(14), color: .black, alignment: .left)
        label.numberOfLines = 0
        return label
    }()
    private let filenameLbl: BaseButton = {
        let btn = BaseButton()
      
        btn.title("", color: .black, size: 11, alignment: .left, isBold: false)
      btn.alignHorizontal(spacing: 0)
        return btn
    }()
    private let reviewLabel: BaseLabel = {
        let label = BaseLabel()
        label.configure(font: .godo_M(11), color: .rgb(129), alignment: .left)
        return label
    }()
    private let exLabel: BaseLabel = {
        let label = BaseLabel()
        label.configure(font: .godo_M(11), color: .rgb(129), alignment: .left)
        return label
    }()

    
    // MARK: - Override
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = false
        initialSetting()
        contentView.addSubview(imgView)
        contentView.addSubview(descriptionLbl)
        contentView.addSubview(filenameLbl)
        contentView.addSubview(reviewLabel)
      //  contentView.addSubview(exLabel)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Private Method
    
    private func initialSetting() {
        
    }
    
    // MARK: - Internal Method
    
    func configurePhotos(_ photos: PhotosDataModel) {
     
        if let url = URL(string: photos.images?[0].link ?? photos.link!) {
            imgView.kf.setImage(with: url, placeholder: UIImage(named: "Home-fill"), options: nil, progressBlock: nil, completionHandler: nil)
                }
        

        descriptionLbl.text = photos.title
        filenameLbl.setTitle("ID : \(photos.id ?? "")", for: .normal)
   
        reviewLabel.text = "link : \(photos.images?[0].link ?? photos.link!)"
  
    }
    func configurePDF( _ pdf: ContentsData) {
        imgView.image = UIImage(named: "Home-fill")
        
        descriptionLbl.text = pdf.filename
        filenameLbl.setTitle("File name :\(pdf.filename)", for: .normal)
   
        reviewLabel.text = "Description : \( pdf.description)"
  
    }
}

//MARK: - Layout
extension SearchCell {
    
    private func layout() {
        contentView.bottomAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 12).isActive = true
        
        imgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        descriptionLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        descriptionLbl.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 10).isActive = true
        descriptionLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        filenameLbl.topAnchor.constraint(equalTo: descriptionLbl.bottomAnchor).isActive = true
        filenameLbl.leadingAnchor.constraint(equalTo: descriptionLbl.leadingAnchor).isActive = true
        
        reviewLabel.topAnchor.constraint(equalTo: filenameLbl.bottomAnchor).isActive = true
        reviewLabel.leadingAnchor.constraint(equalTo: filenameLbl.leadingAnchor).isActive = true
        
       
    }
}
