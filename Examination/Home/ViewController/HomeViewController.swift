//
//  HomeViewController.swift
//  LetsBee
//
//  Created by WonJun Choi on 2020/04/24.
//  Copyright © 2020 WonJun Choi. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController,XMLParserDelegate {

    // MARK: - Properties
    var contentsData: [ContentsData?] = []
    var imugurData: [PhotosDataModel]?
    var elementName: String = String()
    var descriptions = String()
    var image_count : Int?
    var filename = String()
    var retrieve_images : Bool?
    var imageList = [[String : Any]]()
    private var refreshControl = UIRefreshControl()
    private var searchCode = ""
    private var page = 1
    private var blankData = false
    
    // MARK: - UI Component
    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.barTintColor = .white
        search.backgroundColor = .white
        search.layer.borderColor = .rgb(226)
        search.layer.borderWidth = 1
        search.setImage(UIImage(named: "icoSearch"), for: .search, state: .normal)
        search.placeholder = "Search here"
        
        let textFeild = search.value(forKey: "searchField") as? UITextField
        textFeild?.font = UIFont.godo_M(15)
        textFeild?.textColor = .black
        textFeild?.backgroundColor = .white
        
        let placeholder = textFeild?.value(forKey: "placeholderLabel") as? UILabel
        placeholder?.font = UIFont.godo_M(15)
        placeholder?.textColor = .rgb(185)
        
        return search
    }()
    private let searchResultTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.register(cellType: SearchCell.self)
        let view = UIView()
        view.backgroundColor = .rgb(245)
        tableView.tableFooterView = view
        return tableView
    }()
    
    // MARK: - Override
    init() {
        super.init(nibName: nil, bundle: nil)

        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetting()
        view.addSubview(searchBar)
        view.addSubview(searchResultTableView)
        layout()
    }

    // MARK: - Private Method
    private func initialSetting() {
        if let path = Bundle.main.url(forResource: "contents", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
        setNavigationBar(isUnderline: true, barTintColor: .beeYellow, title: "Search Recipe")
        showBackButton()
        view.backgroundColor = .rgb(245)
        
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
        searchBar.delegate = self
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.tintColor = .rgb(158)
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh TableView View", attributes: [.font:UIFont.godo_M(13), .foregroundColor: UIColor.rgb(158)])
             
        if #available(iOS 10.0, *) {
            searchResultTableView.refreshControl = refreshControl
        } else {
            searchResultTableView.addSubview(refreshControl)
        }
        
        getInfo()
        let book = ContentsData(filename: "alice-in-wonderland.pd", description: "The adventure of Alice in Wonderland" )
        
        contentsData.append(book)
    }
    
    // MARK: - Network
    private func getInfo() {
        self.showSpinner(onView: self.view)
        Service().getPhotos(){ [weak self] (result, errorStr, error) in
            guard let self = self else {return}
            guard let result = result, errorStr == nil else{
                self.alert("\(errorStr ?? "")")
                self.removeSpinner()
                return
            }
         
            self.imugurData = result
            self.blankData = false
            self.removeSpinner()
            self.searchResultTableView.reloadData()
            
        }
    }
    
 //XMLPARSER
    // 1
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "pdf-item" {
            filename = String()
            descriptions = String()
        
        }
        
        imageList.append(attributeDict)
        self.elementName = elementName
        
    }
    
    // 2
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
       
        if elementName == "pdf-item" {
            let book = ContentsData(filename: filename, description: descriptions )
      
            contentsData.append(book)
        }
    }
    
    // 3
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if (!data.isEmpty) {
            if self.elementName == "filename" {
                filename += data
               
            } else if self.elementName == "description" {
                descriptions += data
            }
        }
       
    }
    
    func returnConfigure(selected: [SavedData]) {
        
        guard let sel = savedRecentData else {
            savedRecentData = selected
           
           
           
            return
        }
        let selectedMenu = sel + selected
        savedRecentData = selectedMenu
        
        if sel.contains(where: {$0.id == selected[0].id}) {
            var selectedMenu = [SavedData]()
            for i in 0 ..< sel.count {
                if let id = sel[i].id, id != "" {
                    if id == selected[0].id {
                        let newSel = sel[i]
                      
                        selectedMenu.append(newSel)
                    } else {
                        selectedMenu.append(sel[i])
                    }
                }
            }
            savedRecentData = selectedMenu
            
        } else {
            let selectedMenu = sel + selected
            savedRecentData = selectedMenu
        }
        
  
    }
    
    // MARK: - Selector
    @objc func refreshData() {
        page = 1
        getInfo()
        refreshControl.endRefreshing()
    }
    
    
}
// MARK: - Layout
extension HomeViewController {
    private func layout() {
        let margins = view.safeAreaLayoutGuide
        
        searchBar.topAnchor.constraint(equalTo: margins.topAnchor, constant: 12).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        searchResultTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10).isActive = true
        searchResultTableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        searchResultTableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        searchResultTableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
    }
}


// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            guard let arr = self.imugurData else{return 0}
            for i in 0 ..< imageList.count {
                if let row = imageList[i]["image_count"] as? String, row != "" {
                    if let retrieve_images = imageList[i]["retrieve_images"] as? String ,row != ""{
                        if retrieve_images == "true" {
                            image_count = Int(row)
                        }else {
                            image_count = 0
                        }
                    }
                  
                }
            }
            let slice5 = arr.prefix(image_count ?? 0) // ArraySlice
            return slice5.count
            
        }else {
           
            return contentsData.count
        }
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SearchCell.self)
        if indexPath.section == 1 {
            guard let section0 = imugurData?[indexPath.row] else {return cell}
            cell.configurePhotos(section0)
        }else {
            guard let section1 = contentsData[indexPath.row] else {return cell}
            
            cell.configurePDF(section1)
        }
      
      
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
   

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedMenu = [SavedData]()
        
        let imugurData = imugurData?[indexPath.row]
     
        selectedMenu.append(SavedData(["id": imugurData?.id ?? "", "link": imugurData?.link ?? "", "gifv": imugurData?.gifv ?? "", "title": imugurData?.title ?? "","images": imugurData?.images?[0].link ?? ""]))
       
     returnConfigure(selected: selectedMenu)

        if indexPath.section == 1 {
            guard let row = self.imugurData?[indexPath.row] else{return}
            
            let vc = DetailsViewController(row,indexPath.section)
            show(vc)
        }else {
            let row = contentsData[indexPath.row]
          
            let vc = DetailsViewController(pdfData:row,indexPath.section)
            show(vc)
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let height: CGFloat = scrollView.frame.size.height
        let contentYOffset: CGFloat = scrollView.contentOffset.y
        let scrollViewHeight: CGFloat = scrollView.contentSize.height
        let distanceFromBottom: CGFloat = scrollViewHeight - contentYOffset
                
        if distanceFromBottom < height {
            if self.blankData == false {
                //self.addData(searchText: "")
            }
        }
    }
}


// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
