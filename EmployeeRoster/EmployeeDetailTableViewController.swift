
import UIKit

protocol EmployeeDetailTableViewControllerDelegate: AnyObject {
    func employeeDetailTableViewController(_ controller: EmployeeDetailTableViewController, didSave employee: Employee)
}

class EmployeeDetailTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: Variables
    // Property to store index path position of birthday label
    let birhDayLabelPosition = IndexPath(row: 1, section: 0)
    // Property to store index path position of birthday whell picker
    let birhDayPickerWheelPosition = IndexPath(row: 2, section: 0)
    
    // Данная проперти следит за тем, редактирует ли пользователь сейас дату рождения
    var isEditingBirthday: Bool = false {
        // Данная имплементация didSet метода делает обязательным вызов делегированных методов
        // beginUpdates и endUpdates() при изменении значения проперти
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    // MARK: Outlets
    
    
    @IBOutlet var dobDatePicker: UIDatePicker!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var dobLabel: UILabel!
    @IBOutlet var employeeTypeLabel: UILabel!
    @IBOutlet var saveBarButtonItem: UIBarButtonItem!
    
    weak var delegate: EmployeeDetailTableViewControllerDelegate?
    var employee: Employee?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        updateSaveButtonState()
    }
    
    // MARK: Functions
    
    func updateView() {
        if let employee = employee {
            navigationItem.title = employee.name
            nameTextField.text = employee.name
            
            dobLabel.text = employee.dateOfBirth.formatted(date: .abbreviated, time: .omitted)
            dobLabel.textColor = .label
            employeeTypeLabel.text = employee.employeeType.description
            employeeTypeLabel.textColor = .label
        } else {
            navigationItem.title = "New Employee"
        }
    }
    
    private func updateSaveButtonState() {
        let shouldEnableSaveButton = nameTextField.text?.isEmpty == false
        saveBarButtonItem.isEnabled = shouldEnableSaveButton
    }
    
    // MARK: Actions
    
    
    /// Action для установки значения лейблу при изменении значения дейтпикера
    /// - Parameter sender: Указан как дейтпикер, поэтому можно использовать аргумент как источник данных
    @IBAction func dateOfBirthValueChangedAction(_ sender: UIDatePicker) {
        dobLabel.text = sender.date.formatted(date: .abbreviated, time: .omitted)
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text else {
            return
        }
        
        let employee = Employee(name: name, dateOfBirth: dobDatePicker.date, employeeType: .exempt)
        delegate?.employeeDetailTableViewController(self, didSave: employee)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        employee = nil
    }
    
    @IBAction func nameTextFieldDidChange(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    
    /// Перегрузка метода выбора пользователем клетки со следующей целью:
    /// - Purpose:
    ///   1) Изменять значение проперти выбора дня рождения работкника
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // По дефолту убираем выделение ряда пользователем
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected index path: \(indexPath)")
        // Если index path совпадает с лейблом дня рождения
        if indexPath == birhDayLabelPosition {
            print("Case of datebirth")
            // Изменяем значение проперти "редактирует ли пользователь ДР" на противоположное
            isEditingBirthday.toggle()
            // Настраиваем значения поля даты рождения
            dobLabel.text = dobDatePicker.date.formatted(date: .abbreviated, time: .omitted)
            // Меняем стиль шрифта
            dobLabel.textColor = .white
        }
    }
    
    ///Данная перегрузка метода делегата предназначена для регулировки высоты клетки с datepicker'ом
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /* В первую очередь мы смотрим на то, чтобы indexPath интересующей наши клетки был равен
         определнному нами выше */
        switch indexPath {
            // Если это условие выполнено и пользователь сейчас не редактирует дату рождения
        case birhDayPickerWheelPosition where isEditingBirthday == false:
            // Скрываем эту клетку
            return 0
        default:
            /* В противном случае (Для всех остальных клеток таблицы) позволяем
             TableView использовать механихм
             автоматического выставления высоты клеткам */
            return UITableView.automaticDimension
        }
    }
    
    /// This override of delegate method is for setting up the height of the date picker rows when they are supposed to show full date picker height
    /// - Parameters:
    ///   - tableView: tableView object
    ///   - indexPath: Index path for concrete rows in table
    /// - Returns:
    ///   - 190 if datepicker rows are selected
    ///   - automaticDimensions for every other row in table
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case birhDayPickerWheelPosition:
            return 190
        default:
            return UITableView.automaticDimension
        }
    }
}
