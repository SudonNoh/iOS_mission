import UIKit
import RxSwift
import RxCocoa
import RxRelay
/*
class Example: UIViewController {
    var tableView = UITableView()
    let disposeBag = DisposeBag()
    var interactionService = InteractionService(products: .just([]))
    var analytics = Analytics()

    override func viewDidLoad() {
        super.viewDidLoad()
        // create a couple of subjects for dealing with the user selections.
        let inStockSubject = PublishSubject<Product>()
        let soldOutSubject = PublishSubject<Product>()

        // here we use a higher order function to create two functions that take a Product and return a swipe action configuration.
        let makeSoldOutAction = createAction(title: "Sold Out", color: #colorLiteral(red: 0.996, green: 0.09, blue: 0.478, alpha: 1.0), observer: soldOutSubject.asObserver())
        let makeInStockAction = createAction(title: "In Stock", color: #colorLiteral(red: 0.09, green: 0.996, blue: 0.478, alpha: 1.0), observer: inStockSubject.asObserver())

        // every time `products` emits a new value...
        interactionService.products
            // create a [IndexPath: UISwipeActionsConfiguration] dict with the correct swipe action for each product.
            .map { Dictionary(uniqueKeysWithValues: $0.enumerated().map { (IndexPath(row: $0.offset, section: 0), $0.element.isEnabled ? makeSoldOutAction($0.element) : makeInStockAction($0.element)) }) }
            // and bind it to the table view delegate.
            .bind(to: tableView.rx.trailingSwipeActionsConfigurationForRowAt)
            .disposed(by: disposeBag)

        // these are so we don't have to worry about capturing self in the closures below.
        let interactionService = self.interactionService
        let analytics = self.analytics

        // every time the user taps the sold out action, this will emit the product.
        soldOutSubject
            // disable the product and pass it down.
            .flatMapLatest { interactionService.disableProduct($0).map { [p = $0] in p } }
            // report the event to the analytics system.
            .subscribe(onNext: {
                analytics.userMarkedAsSoldOut(product: $0.productID)
            })
            .disposed(by: disposeBag)

        // setup your inStock chain like the above.
    }
}

// this is a generic action configuration creator for products.
func createAction(title: String, color: UIColor, observer: AnyObserver<Product>) -> (Product) -> UISwipeActionsConfiguration {
    { product in
        let action = UIContextualAction(style: .normal, title: title) { _, _, completionHandler in
            observer.onNext(product)
            completionHandler(true)
        }
        action.backgroundColor = color
        let config = UISwipeActionsConfiguration(actions: [action])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}

// put the below in a separate file so you can reuse it in other contexts.

// this creates a delegate proxy class for the table view. Learn more in this article: https://danielt1263.medium.com/convert-a-swift-delegate-to-rxswift-observables-f52afe77f8d6
class UITableViewDelegateProxy: DelegateProxy<UITableView, UITableViewDelegate>, DelegateProxyType, UITableViewDelegate {

    static func currentDelegate(for object: UITableView) -> UITableViewDelegate? {
        object.delegate
    }

    static func setCurrentDelegate(_ delegate: UITableViewDelegate?, to object: UITableView) {
        object.delegate = delegate
    }

    public static func registerKnownImplementations() {
        self.register { UITableViewDelegateProxy(parentObject: $0) }
    }

    init(parentObject: UITableView) {
        super.init(
            parentObject: parentObject,
            delegateProxy: UITableViewDelegateProxy.self
        )
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        relay.value[indexPath]
    }

    fileprivate let relay = BehaviorRelay<[IndexPath: UISwipeActionsConfiguration]>(value: [:])
}

extension Reactive where Base: UITableView {
    var delegate: UITableViewDelegateProxy {
        return UITableViewDelegateProxy.proxy(for: base)
    }

    var trailingSwipeActionsConfigurationForRowAt: Binder<[IndexPath: UISwipeActionsConfiguration]> {
        Binder(delegate) { del, value in
            del.relay.accept(value)
        }
    }
}
*/
