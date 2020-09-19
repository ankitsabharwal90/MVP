//
//  FirebaseEngine.swift
//  IdeaList
//
//  Created by Ankit Sabharwal on 18/9/2563 BE.
//  Copyright © 2563 Ankit Sabharwal. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol FirebaseDelegate: class {
    func updateList(ideas: [Idea])
}

class FirebaseEngine {
    private init() {}
    static let shared = FirebaseEngine()
    let database: String = "ideas"
    
    var db = Firestore.firestore()
    var listener: ListenerRegistration?
    weak var delegate: FirebaseDelegate?
    
    var ideas: [Idea]? {
        didSet {
            delegate?.updateList(ideas: ideas ?? [])
        }
    }
    
    func startListener() {
        listener = db.collection(database).addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.ideas = querySnapshot.documents.compactMap { document -> Idea? in
                    try? document.data(as: Idea.self)
            }
          }
        }
    }
    
    func addTask(_ idea: Idea, success: @escaping () -> Void, fail: @escaping () -> Void) {
      do {
        let _ = try db.collection(database).addDocument(from: idea)
        success()
      }
      catch {
        fail()
      }
    }
    
    func removeTask(_ task: Idea, success: @escaping () -> Void, fail: @escaping () -> Void) {
       if let taskID = task.id {
         db.collection(database).document(taskID).delete { (error) in
           if let error = error {
            fail()
           }
         }
        success()
       }
     }
     
     func updateTask(_ task: Idea, success: @escaping () -> Void, fail: @escaping () -> Void) {
       if let taskID = task.id {
         do {
           let _ = try db.collection("ideas").document(taskID).setData(from: task)
            success()
         }
         catch {
            fail()
         }
       }
     }
    
    func stopListener() {
        if (listener != nil) {
            listener?.remove()
        }
    }
}
