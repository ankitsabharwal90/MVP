//
//  DashboardViewController.swift
//  mvp
//
//  Created by Ankit Sabharwal on 19/09/20.
//  Copyright © 2020 Ankit Sabharwal. All rights reserved.
//

import UIKit
import Firebase

class DashboardViewController: UIViewController {

    private let cellId: String = "IdeaTableViewCell"

    @IBOutlet weak var noIdeaView: UIView!
    @IBOutlet weak var ideasTableView: UITableView!
    private var dashboardViewModel = DashboardViewModel()
    private var router: Router!

    private var ideasViewModel: ViewModel? {
        didSet {
            if (ideasViewModel != nil) && (ideasViewModel?.favourite.count ?? 0 > 0 || ideasViewModel?.regular.count ?? 0 > 0) {
                showIdeasList(flag: true)
            } else {
                showIdeasList(flag: false)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initAppearance()
        
    }
    
    private func initAppearance() {
        let headerNib = UINib.init(nibName: "IdeaheaderView", bundle: Bundle.main)
        ideasTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "Header")
        self.ideasTableView.rowHeight = UITableView.automaticDimension
        self.ideasTableView.estimatedRowHeight = UITableView.automaticDimension
        showIdeasList(flag: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        initalSetup()
    }
    
    private func initalSetup() {
        self.dashboardViewModel =  DashboardViewModel()
        self.router = DashboardRouter.init(viewModel: self.dashboardViewModel)
        FirebaseEngine.shared.startListener()
        FirebaseEngine.shared.delegate = self
        callToViewModelForUIUpdate()
    }
       
    func callToViewModelForUIUpdate(){
        self.dashboardViewModel.bindIdeaViewModelToController = {
            self.ideasViewModel = self.dashboardViewModel.ideasViewModel
        }
    }
    
    private func showIdeasList(flag: Bool) {
        ideasTableView.isHidden = !flag
        noIdeaView.isHidden = flag
        ideasTableView.reloadData()
    }
    
    @IBAction func addIdeaPressed(_ sender: UIBarButtonItem) {
        router.route(to: Constants.Route.AddScreen.rawValue, from: self, parameters: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FirebaseEngine.shared.stopListener()
    }
}

extension DashboardViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dashboardViewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dashboardViewModel.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeCell = tableView.dequeueReusableCell(withIdentifier: cellId) as? IdeaTableViewCell
        guard let cell = dequeCell,
            let idea = self.dashboardViewModel.getIdeaViewModel(section: indexPath.section, row: indexPath.row) else {
            return UITableViewCell()
        }
        cell.favouriteButton.addTarget(self, action: #selector(favouriteButtonPressed(sender:)), for: .touchUpInside)
        cell.setupCell(ideaViewModel: idea)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as! IdeaHeaderView
        let data = self.dashboardViewModel.setupSectionHeader(index: section)
        headerView.bindData(isFavourite: data.0, title: data.1)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let ideaModel = self.dashboardViewModel.getIdeaViewModel(section: indexPath.section, row: indexPath.row) else {
                return
            }
            self.dashboardViewModel.deleteIdea(ideaModel: ideaModel)
        }
    }
    
    @objc func favouriteButtonPressed(sender: UIButton) {
        guard let cell = sender.superview?.superview as? IdeaTableViewCell,
                let indexPath = ideasTableView.indexPath(for: cell),
                let ideaModel = self.dashboardViewModel.getIdeaViewModel(section: indexPath.section, row: indexPath.row) else {
                return
        }
        self.dashboardViewModel.favouriteIdea(ideaModel: ideaModel)
    }
}

extension DashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let ideaModel = self.dashboardViewModel.getIdeaViewModel(section: indexPath.section, row: indexPath.row) else {
            return
        }
        router.route(to: Constants.Route.UpdateScreen.rawValue, from: self, parameters: ideaModel)
    }
}

extension DashboardViewController: FirebaseDelegate {
    func updateList(ideas: [Idea]) {
        dashboardViewModel.setIdeas(idea: ideas)
    }
}
