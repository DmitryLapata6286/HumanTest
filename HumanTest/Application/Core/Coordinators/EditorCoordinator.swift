//
//  EditorCoordinator.swift
//  HumanTest
//

import Foundation

protocol EditorCoordinatorOutput: AnyObject {
    var finishFlow: CompletionBlock? { get set }
}
 
final class EditorCoordinator: BaseCoordinator, EditorCoordinatorOutput {
  
    var finishFlow: CompletionBlock?
    
    fileprivate let router : Routable
    
    init(router: Routable) {
        self.router  = router
    }
    
    override func start() {
        performFlow()
    }

}
  
private extension EditorCoordinator {
    func performFlow() {
       //:- Will implement later
    }
}
