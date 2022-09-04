//
//  DetailsViewController.swift
//  ExamApp
//
//  Created by Dan Albert Luab on 8/29/22.
//

import UIKit
import SwiftUI
import Combine
import Kingfisher
import PDFKit

class  DetailsViewController : BaseViewController,UIScrollViewDelegate {

    // MARK: - Properties
   
    private var photosData: PhotosDataModel?
    private var recentData: SavedData?
    private var pdfData: ContentsData?

    // MARK: - UI Component
    
    var imageView: UIImageView!
    var scrollImg: UIScrollView!
    // MARK: - Override
    init(_ photosData: PhotosDataModel? = nil, pdfData: ContentsData? = nil,_ section: Int,_ recentData: SavedData? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.photosData = photosData
        self.pdfData = pdfData
        self.recentData = recentData
        if section == 1 {
            loadImage()
        }else {
            loadPDF()
            
        }
              
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetting()
      
    
    }
    func loadImage() {
        let vWidth = self.view.frame.width
        let vHeight = self.view.frame.height

        scrollImg = UIScrollView()
        scrollImg.delegate = self
        scrollImg.frame = CGRect(x: 0, y: 0, width: vWidth, height: vHeight)
        scrollImg.backgroundColor = UIColor(red: 90, green: 90, blue: 90, alpha: 0.90)
        scrollImg.alwaysBounceVertical = false
        scrollImg.alwaysBounceHorizontal = false
        scrollImg.showsVerticalScrollIndicator = true
        scrollImg.flashScrollIndicators()

        scrollImg.minimumZoomScale = 1.0
        scrollImg.maximumZoomScale = 10.0

        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        scrollImg.addGestureRecognizer(doubleTapGest)

        self.view.addSubview(scrollImg)

        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: vWidth, height: vHeight))
        imageView.image = UIImage(named: "cat")
        imageView!.layer.cornerRadius = 11.0
        imageView!.clipsToBounds = false
        scrollImg.addSubview(imageView!)
        
            imageView.kf.indicatorType = .activity
        let img = photosData?.images?[0].link ?? photosData?.link!
        imageView.kf.setImage(with: URL(string: (img ?? recentData?.images)!), options: [.memoryCacheExpiration(.days(3))])
           
     
             
               imageView.backgroundColor = .black
               imageView.contentMode = .scaleToFill
    }
    func loadPDF() {
        let pdfView = PDFView(frame: self.view.bounds)
              self.view.addSubview(pdfView)

              // Fit content in PDFView.
              pdfView.autoScales = true

              // Load Sample.pdf file.
        let url = pdfData?.filename.dropLast(4)
        
        guard let fileURL = Bundle.main.url(forResource: "\(url ?? "")", withExtension: "pdf") else {
            self.alert("\("FILE NOT EXISTED" )")
            return
        }
       
        pdfView.document = PDFDocument(url: fileURL)
    }
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
           if scrollImg.zoomScale == 1 {
               scrollImg.zoom(to: zoomRectForScale(scale: scrollImg.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
           } else {
               scrollImg.setZoomScale(1, animated: true)
           }
       }

       func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
           var zoomRect = CGRect.zero
           zoomRect.size.height = imageView.frame.size.height / scale
           zoomRect.size.width  = imageView.frame.size.width  / scale
           let newCenter = imageView.convert(center, from: scrollImg)
           zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
           zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
           return zoomRect
       }

       func viewForZooming(in scrollView: UIScrollView) -> UIView? {
           return self.imageView
       }

    
    // MARK: - Private Method
    private func initialSetting() {
       
        showBackButton()
        setNavTitle(title: "Detail View")
           
    }
    

    
    func setNavTitle(title: String) {
       
       let containerView: UIView = {
           let view = UIView()
           view.translatesAutoresizingMaskIntoConstraints = false
           return view
       }()
       
       let navTitleLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.text = title
           label.textAlignment = .center
           label.font = .godo_B(16)
           label.textColor = .black
      
           return label
       }()
       
    
       
       containerView.addSubview(navTitleLabel)
     
       
       containerView.widthAnchor.constraint(equalToConstant: screen_width/2).isActive = true
       containerView.heightAnchor.constraint(equalToConstant: navigationController?.navigationBar.frame.height ?? 48).isActive = true
       
       navTitleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
       navTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
       navTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
       
   
       
      
       
       setTitleView(view: containerView)
   }

}


