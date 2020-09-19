//
//  DashboardRouter.swift
//  IdeaList
//
//  Created by Ankit Sabharwal on 18/9/2563 BE.
//  Copyright © 2563 Ankit Sabharwal. All rights reserved.
//

import Foundation
import UIKit

protocol Router {
   func route(
      to routeID: String,
      from context: UIViewController,
      parameters: Any?
   )
}

class DashboardRouter: Router {

    unowned var viewModel: DashboardViewModel
    init(viewModel: DashboardViewModel) {
       self.viewModel = viewModel
    }

    func route(to routeID: String, from context: UIViewController, parameters: Any?) {
        guard let route = Constants.Route(rawValue: routeID) else {
           return
        }
        switch route {
        case .AddScreen:
            let viewModel =  parameters as? IdeaViewModel
            if let viewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "IdeaViewController") as? IdeaViewController {
                viewController.actionType = ActionType.add
                viewController.ideaViewModel = viewModel
                context.navigationController?.pushViewController(viewController, animated: true)
            }
            break
        case .UpdateScreen:
            let viewModel =  parameters as? IdeaViewModel
            if let viewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "IdeaViewController") as? IdeaViewController {
                viewController.ideaViewModel = viewModel
                viewController.actionType = ActionType.update
                context.navigationController?.pushViewController(viewController, animated: true)
            }
            break
        default:
            break
        }
    }
}
