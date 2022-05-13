import Combine
import UIKit

public class TestViewController: UIViewController {
    let didDismiss = PassthroughSubject<Void, Never>()
    let button = UIButton()

    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow

        view.backgroundColor = .yellow
        view.addSubview(button)
        button.setTitle("Push", for: .normal)
        button.frame.size = CGSize(width: 100, height: 100)
        button.backgroundColor = .blue
        button.tintColor = .black

        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        button.addAction(UIAction(handler: { [weak self] _ in
            print("DidDismiss")
            self?.didDismiss.send(())
        }), for: .touchUpInside)
    }

    deinit {
        print("deInit")
    }
}

protocol Mutable {}

extension Mutable {
    func mutateOne<T>(transform: (inout Self) -> T) -> Self {
        var newSelf = self
        _ = transform(&newSelf)
        return newSelf
    }

    func mutate(transform: (inout Self) -> Void) -> Self {
        var newSelf = self
        transform(&newSelf)
        return newSelf
    }

    func mutate(transform: (inout Self) throws -> Void) rethrows -> Self {
        var newSelf = self
        try transform(&newSelf)
        return newSelf
    }
}

struct ViewModel {

    struct State: Mutable {
        var loading: Bool
    }

    enum Action {
        case mutate
    }

    let state = State(loading: false)

    let subject = PassthroughSubject<Action, Never>()
    let value: AnyPublisher<State, Never>

    init() {

        func reduce(state: State, action: Action) -> State {
            switch action {
            case .mutate:
                return state.mutateOne { $0.loading = false }
            }
        }

        subject
            .scan(state) { state, action in
                reduce(state: state, action: action)
            }

        value = subject
            .scan(state) { _, _ in
                let newState = State(loading: true)
                return newState
            }
            .eraseToAnyPublisher()

        value
            .map { state in
                state.loading
            }
    }
}

public class ChildViewController: UIViewController {

    let didPost = PassthroughSubject<Void, Never>()
    let button = UIButton()

    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow

        title = "Hello world"
        view.backgroundColor = .yellow
        view.addSubview(button)
        button.setTitle("Push", for: .normal)
        button.frame.size = CGSize(width: 100, height: 100)
        button.backgroundColor = .blue
        button.tintColor = .black

        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        button.addAction(UIAction(handler: { [weak self] _ in
            self?.didPost.send(())
        }), for: .touchUpInside)
    }
}

public enum FlowAction {
    case didPost
    case didDismiss
}

public class FlowController: UIViewController {

    public let navigation: UINavigationController
    private let flowSubject: PassthroughSubject<FlowAction, Never>
    var cancellables = Set<AnyCancellable>()

    public init(
        navigationController: UINavigationController,
        flowSubject: PassthroughSubject<FlowAction, Never> = PassthroughSubject<FlowAction, Never>()
    ) {
        self.flowSubject = flowSubject
        navigation = navigationController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        print("Did Load")
        add(navigation)
        let child = ChildViewController()
        navigation.setViewControllers([child], animated: false)

        child
            .didPost
            .map { FlowAction.didPost }
            .subscribe(flowSubject)
            .store(in: &cancellables)

        flowSubject
            .eraseToAnyPublisher()
            .sink { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .didPost:
                    self.didPost()
                case .didDismiss:
                    self.navigation.dismiss(animated: true)
                }
            }
            .store(in: &cancellables)
    }

    func didPost() {
        let vc = TestViewController()

        vc
            .didDismiss
            .map { FlowAction.didDismiss }
            .subscribe(flowSubject)
            .store(in: &cancellables)

        navigation.present(vc, animated: true)
    }
}

public extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func add(_ child: UINavigationController, at _: Int) {
        addChild(child)
    }

    func remove(_ child: UIViewController) {
        guard child.parent != nil else {
            return
        }

        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}
