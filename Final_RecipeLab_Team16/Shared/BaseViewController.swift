import UIKit

class BaseViewController: UIViewController {
    let header = HeaderView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. Background outside safe area = beige
        view.backgroundColor = UIColor(named: "Orange")

        // 2. Add a view that colors ONLY the safe area orange
        let safeAreaBG = UIView()
        safeAreaBG.translatesAutoresizingMaskIntoConstraints = false
        safeAreaBG.backgroundColor = UIColor(named: "Beige")
        view.addSubview(safeAreaBG)
        view.sendSubviewToBack(safeAreaBG)

        NSLayoutConstraint.activate([
            safeAreaBG.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            safeAreaBG.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            safeAreaBG.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            safeAreaBG.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)
        view.bringSubviewToFront(header)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -25),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: header.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
