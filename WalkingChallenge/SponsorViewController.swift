import SnapKit

class SponsorViewController: UIViewController {
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    // MARK: - Configure
    
    private func configureView() {
        view.backgroundColor = Style.Colors.white
        title = Strings.NavBarTitles.sponsor
    }
}
