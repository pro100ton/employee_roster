//
//  EmployeeTypeTableViewController.swift
//  EmployeeRoster
//
//  Created by Антон Шалимов on 19.02.2023.
//

import UIKit

/// Кастомный delegate протокол, который позволит тем, кто от него отнаследуется получать доступ к данным этого класса
protocol EmployeeTypeTableViewControllerDelegate {
    // Объявляем функцию протокола которая в качестве аргумента берет текущий VC и тип работника, которого (если) выбрал пользователь
    func employeeTypeTableViewController(_ controller: EmployeeTypeTableViewController, didSelect employeeType: EmployeeType)
}

class EmployeeTypeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: Properties
    
    /// Property for tracking of whether an employeetype has been chosen
    var employeeType: EmployeeType?
    /// Delegate проперти (тот кто наследует протокол a.k.a приемник сообщений из протокола (в нашем примере - VC добавления/редактирования пользователя)
    var delegate: EmployeeTypeTableViewControllerDelegate?

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /// Данный метод `allCases` у типа `EmployeeType` имеется благодаря протоколу `CaseIterable`.
        return EmployeeType.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeTypeCell", for: indexPath)
        // Get the cell's employee type
        let type = EmployeeType.allCases[indexPath.row]
        
        /**
         Следующий блок кода используется для конфигурации реюзабельных клеток таблицы.
         В нем описывается следующий алгоритм:
            1. Объявляется дефолтная конфигурация клеток
            2. Задаются необходимые параметры для конфигурации клеток. Тут можно настраивать ее сколько угодно
            3. Для клетки устанавливается сконфигурированная на шаге 2 конфигурация клеток
         */
        
        // 1
        var content = cell.defaultContentConfiguration()
        // 2
        content.text = type.description
        // 3
        cell.contentConfiguration = content
        
        /**
         Следюущий блок кода проверяет, если у клетки тип работника совпадает с типом, который был передан
         при инициплизации таблицы, то рядом с ним необходимо поставить "галочку"
         */
        
        
        if employeeType == type {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /**
         Следующий код ответственен за то, что при выделении клетки берется выделенный объект и присваивается
         `self.employeeType` для того, чтобы сохранить выделенный пользователем объект
         */
        // Сначала убирается хэндлер выделения клетки таблицы
        tableView.deselectRow(at: indexPath, animated: true)
        // Определяется `EmployeeType` клетки и присваивается проперти `self.employeeType`
        let selectedEmployeeType = EmployeeType.allCases[indexPath.row]
        self.employeeType = selectedEmployeeType
        // Вызов функции делегата a.k.a передача аргументов функии протокола приемнику сообщений (в нашем примере - VC регистрации/редактирования работника)
        // Получится что выбранный тип работника будет "виден" делегату, который имплементирует эту функцию этого протоколоа и сможет делать с ней все что угодно в своей реализации этого метода
        // Другими словами мы вызываем здесь функцию протокола, в аргументах которой есть выбранный пользователь, а что с ним делать решит уже тот, кто унаследует этот протокол и реализует его функцию
        delegate?.employeeTypeTableViewController(self, didSelect: selectedEmployeeType)
        // Перезагрузка данных таблицы для того, чтобы выделение вступило в силу
        tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
