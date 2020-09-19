//
//  IdeaViewController.swift
//  mvp
//
//  Created by Ankit Sabharwal on 19/09/20.
//  Copyright © 2020 Ankit Sabharwal. All rights reserved.
//

import UIKit

class IdeaViewController: UIViewController {

    var ideaViewModel: IdeaViewModel?
    var actionType: ActionType?
    var viewModel: DashboardViewModel = DashboardViewModel()
    
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var descTxtView: TextView!
    
    var navTitle: String? {
        didSet {
            self.navigationItem.title = navTitle
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initApperance()
        self.hideKeyboardWhenTappedAround()
    }
    
    func initApperance() {
        if let type = actionType {
            rightBarButton.title = type.rawValue
        }
        if let viewModel = ideaViewModel {
            titleTxtField.text = viewModel.ideaTitle
            descTxtView.text = viewModel.ideaDescription
            navTitle = titleTxtField.text
        }
        if ideaViewModel == nil {
            self.ideaViewModel = IdeaViewModel(ideaTitle: "", ideaDescription: "", isFavourite: false)
        }
    }
    
    @IBAction func rightBarButtonPressed(_ sender: UIBarButtonItem) {
        if (validateFields() && actionType != nil) {
            switch actionType {
            case .add:
                self.viewModel.addIdea(ideaModel: self.ideaViewModel)
                break
            case .update:
                self.viewModel.updateIdea(ideaModel: self.ideaViewModel)
                break
            default:
                break
            }
            self.navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "WARNING", message: "Please enter title and description *", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func validateFields() -> Bool{
        var isValid: Bool = false
        if (ideaViewModel?.ideaTitle.count != 0 && ideaViewModel?.ideaDescription.count != 0) {
            isValid = true
        }
        return isValid
    }
}

extension IdeaViewController: UITextFieldDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let text = textView.text,
           let textRange = Range(range, in: text) {
           let updatedText = text.replacingCharacters(in: textRange,
                                                       with: text)
            ideaViewModel?.ideaDescription = updatedText
        }

        return true
    }
}

extension IdeaViewController: UITextViewDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
           let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            navTitle = updatedText
            ideaViewModel?.ideaTitle = updatedText
        }
        return true
    }
}
