import UIKit
import Cartography

final class FollowListView: UIView {
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(SearchUserCell.self, forCellReuseIdentifier: String(describing: SearchUserCell.self))
        return view
    }()

    init(dataSourceDelegate: UITableViewDataSource & UITableViewDelegate) {
        super.init(frame: .zero)

        tableView.dataSource = dataSourceDelegate
        tableView.delegate = dataSourceDelegate

        setup()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    private func setup() {
        backgroundColor = .white

        addSubview(tableView)
        constrain(self, tableView) { superview, tableView in
            tableView.edges == superview.edges
        }
    }


    func reloadTable() {
        tableView.reloadData()
    }
}
