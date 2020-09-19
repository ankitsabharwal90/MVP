//
//  DashboardViewModel.swift
//  mvp
//
//  Created by Ankit Sabharwal on 19/09/20.
//  Copyright © 2020 Ankit Sabharwal. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct IdeaViewModel {
    var ideaId: String?
    var ideaTitle: String
    var ideaDescription: String
    var isFavourite: Bool
    var creationDate: Timestamp?
    var updatedDate: Timestamp?
}

struct ViewModel {
    var favourite: [IdeaViewModel]
    var regular: [IdeaViewModel]
}

class DashboardViewModel: NSObject {
    
    private(set) var ideasViewModel : ViewModel? {
        didSet {
            self.bindIdeaViewModelToController()
        }
    }
    
    var bindIdeaViewModelToController : (() -> ()) = {}

    override init() {
        super.init()
    }
    
    private var ideas: [Idea]? {
        didSet {
            bindViewModel()
        }
    }
  
    func setIdeas(idea: [Idea]) {
        self.ideas = idea
    }
    
    private func bindViewModel() {
        if let ideas = self.ideas {
            let favouriteIdeas = ideas.filter({$0.isFavourite == true})
            let regularIdeas = ideas.filter({$0.isFavourite == false})
            var favIdea: [IdeaViewModel] = []
            var regIdea: [IdeaViewModel] = []
            for idea in favouriteIdeas {
                favIdea.append(IdeaViewModel(ideaId: idea.id,
                                             ideaTitle: idea.title,
                                             ideaDescription: idea.description,
                                             isFavourite: idea.isFavourite,
                                             creationDate: idea.creationDate,
                                             updatedDate: idea.updatedDate))
            }
            for idea in regularIdeas {
                regIdea.append(IdeaViewModel(ideaId: idea.id,
                                ideaTitle: idea.title,
                                ideaDescription: idea.description,
                                isFavourite: idea.isFavourite,
                                creationDate: idea.creationDate,
                                updatedDate: idea.creationDate))
            }
            let viewModel: ViewModel = ViewModel(favourite: favIdea, regular: regIdea)
            self.ideasViewModel = viewModel
        }
    }
    
    func numberOfSections() -> Int {
        return 2
    }
    
    func setupSectionHeader(index: Int) -> (Bool, String) {
        var sectionTitle: String = ""
        var isFavourite: Bool = false
        switch index {
        case 0:
            sectionTitle = "Favourites"
            isFavourite = true
            break
        case 1:
            sectionTitle = "Regular"
            isFavourite = false
            break
        default:
            break
        }
        return (isFavourite ,sectionTitle)
    }
    
    func numberOfRows(section: Int) -> Int {
        switch section {
        case 0:
            return self.ideasViewModel?.favourite.count ?? 0
        case 1:
            return self.ideasViewModel?.regular.count ?? 0
        default:
            return 0
        }
    }
    
    func getIdeaViewModel(section: Int, row: Int) -> IdeaViewModel? {
        var viewModels: [IdeaViewModel]?
        switch section {
        case 0:
            viewModels = self.ideasViewModel?.favourite
            break
        case 1:
            viewModels = self.ideasViewModel?.regular
            break
        default:
            break
        }
        return viewModels?[row]
    }
    
    private func getIdeaUsingID(ideaId: String) -> Idea? {
        return self.ideas?.filter({$0.id == ideaId}).first
    }
    
    func addIdea(ideaModel: IdeaViewModel?) {
        if let model = ideaModel {
            self.storeIdea(actionType: .add, ideaViewModel: model)
        }
    }
    
    func updateIdea(ideaModel: IdeaViewModel?) {
        if let model = ideaModel {
            self.storeIdea(actionType: .update, ideaViewModel: model)
        }
    }
    
    func deleteIdea(ideaModel: IdeaViewModel) {
        self.storeIdea(actionType: .delete, ideaViewModel: ideaModel)
    }
    
    func favouriteIdea(ideaModel: IdeaViewModel) {
        var updatedModel = ideaModel
        updatedModel.isFavourite = !updatedModel.isFavourite
        self.storeIdea(actionType: .update, ideaViewModel: updatedModel)
    }
    
    private func storeIdea(actionType: ActionType, ideaViewModel: IdeaViewModel?, success: @escaping () -> Void = { return }, fail: @escaping () -> Void = { return }) {
        guard let viewModel = ideaViewModel else {
            return
        }
        let idea = Idea(id: viewModel.ideaId,
                        title: viewModel.ideaTitle,
                        description: viewModel.ideaDescription,
                        isFavourite: viewModel.isFavourite,
                        creationDate: viewModel.creationDate,
                        updatedDate: viewModel.updatedDate)
        
        switch actionType {
            case .add:
                FirebaseEngine.shared.addTask(idea, success: {
                    success()
                }) {
                    fail()
                }
                break
            case .delete:
                FirebaseEngine.shared.removeTask(idea, success: {
                    success()
                }) {
                    fail()
                }
                break
            case .update:
                FirebaseEngine.shared.updateTask(idea, success: {
                    success()
                }) {
                    fail()
                }
                break
            default:
                break
        }
    }
}
