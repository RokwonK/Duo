
import UIKit
import Alamofire
import RxSwift
import RxCocoa

class LoginViewModel : ViewModel {
    let userUseCase = UserUseCase()
    
    let userEntity = PublishRelay<UserEntity?>()
    let loginErrorEntity = PublishRelay<ApiErrorMessage?>()
    
    var socialName = "kakao"
    
    override init() {
        super.init()
        
        setupBinding()
    }
    
    private func setupBinding() {
    }
    
    func requestUser(social : String) {
        userUseCase.getUser(social: social)
            .subscribe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] entity in
                self?.userEntity.accept(entity)
            }, onFailure: { _ in })
            .disposed(by: disposeBag)
    }
    
    
    func saveUser(entity : UserEntity?) {
        userUseCase.saveUser(entity: entity)
    }
    
    
}
