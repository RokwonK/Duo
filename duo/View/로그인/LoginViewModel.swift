
import UIKit
import Alamofire
import RxSwift
import RxCocoa

class LoginViewModel : ViewModel {
    let userUseCase = UserUseCase()
    
    let userEntity = PublishRelay<UserEntity?>()
    let loginErrorEntity = PublishRelay<ApiErrorMessage?>()
    
    override init() {
        super.init()
        
        setupBinding()
    }
    
    private func setupBinding() {
    }
    
    func requestUser(social : String) {
        userUseCase.getUser(social: social)
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext : { [weak self] result in
                
                switch result{
                case .success(let data):
                    self?.userEntity.accept(data)
                case .failure(let error):
                    self?.loginErrorEntity.accept(error)
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    
    func saveUser(entity : UserEntity?) {
        userUseCase.saveUser(entity: entity)
    }
    
    
}
