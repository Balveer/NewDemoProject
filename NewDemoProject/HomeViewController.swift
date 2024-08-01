import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView()
    var inspections: [CDInspection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"
        view.backgroundColor = .white
        
        let startButton = UIButton()
        startButton.setTitle("Start Inspection", for: .normal)
        startButton.addTarget(self, action: #selector(startInspectionTapped), for: .touchUpInside)
        
        view.addSubview(startButton)
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        setupConstraints(for: startButton)
        fetchInspections()
    }
    
    @objc func startInspectionTapped() {
        NetworkManager.shared.startInspection { inspection in
            guard let inspection = inspection else { return }
            
            // Save the inspection in draft state
            CoreDataHandler.shared.saveInspection(id: "\(inspection.id)", state: "draft")
            self.fetchInspections()
        }
    }
    
    func fetchInspections() {
        if let inspections = CoreDataHandler.shared.fetchInspections() {
          //  self.inspections = inspections
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func submitInspection(inspection: NetworkInspection) {
        NetworkManager.shared.submitInspection(inspection: inspection) { success in
            if success {
                CoreDataHandler.shared.updateInspection(id: "\(inspection.id)", state: "completed")
                self.fetchInspections()
            }
        }
    }
    
    func setupConstraints(for button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inspections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let inspection = inspections[indexPath.row]
        cell.textLabel?.text = "Inspection ID: \(inspection.id ?? "") - State: \(inspection.state ?? "")"
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let inspection = inspections[indexPath.row]
        let inspectionId = inspection.id ?? ""
        let inspectionState = inspection.state ?? ""
        
        if inspectionState == "draft" {
            // Perform submission if the inspection is in draft state
            NetworkManager.shared.startInspection { inspection in
                guard let inspection = inspection else { return }
                self.submitInspection(inspection: inspection)
            }
        }
    }
}
