public func createUnsupportedFallbackViewController(
    message: String = "Simulators aren't supported. Try it on a physical device."
) -> UIViewController {
    let vc = UIViewController()
    vc.view.backgroundColor = .systemGroupedBackground
    
    let label = UILabel()
    label.text = message
    label.textColor = .secondaryLabel
    label.textAlignment = .center
    label.numberOfLines = 0
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    vc.view.addSubview(label)
    NSLayoutConstraint.activate([
        label.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
        label.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor),
        label.leadingAnchor.constraint(greaterThanOrEqualTo: vc.view.leadingAnchor, constant: 32),
        label.trailingAnchor.constraint(lessThanOrEqualTo: vc.view.trailingAnchor, constant: -32)
    ])
    
    return vc
}
