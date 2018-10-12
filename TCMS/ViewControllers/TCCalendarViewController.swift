//
//  TCCalendarViewController.swift
//  TCMS
//
//  Created by Austin Chen on 2018-02-03.
//  Copyright © 2018 Austin Chen. All rights reserved.
//

import UIKit
import JTAppleCalendar
import CollapsibleTableSectionViewController

class TCCalendarViewController: UIViewController, TCDrawerItemViewControllerType {
    
    @IBAction func leftBarButtonTapped(_ sender: Any) {
        viewDelegate?.didTriggerToggleButton()
    }
    
    var viewDelegate: TCDrawerMasterViewControllerDelegate?
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var titleButton: UIButton!
    @IBAction func titleButtonTapped(_ sender: Any) {
        calendarView.scrollToDate(Date.init())
    }
    
    @IBOutlet weak var tableView: MBCollapsibleTableView!
    
    let outsideMonthColor = UIColor.init(red: 77/255.0, green: 77/255.0, blue: 77/255.0, alpha: 1)
    let monthColor = UIColor.black
    let selectedMonthColor = UIColor(colorWithHexValue: 0x3a294b)
    let currentDateSelectedViewColor = UIColor(colorWithHexValue: 0x4e3f5d)
    
    let formatter = DateFormatter()
    
    private var dateEventsDict = [String: [TCJsonSchedule]]()
    private var selectedDate: String?
    private var remote = TCScheduleRemote.init(remoteSession: nil)
    private var sections: [TableSection] = [
        TableSection(name: "Login & Security", icon: "login_security_icon", url: nil,items: [
            TableItem(name: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.", detail: "", url: nil)
        ]),
        TableSection(name: "The fine print", icon: "legal_icon", url: nil, items: [
            TableItem(name: "Glossary of terms", detail: "", url: nil),
            TableItem(name: "Privacy", detail: "", url: nil),
            TableItem(name: "Security statement", detail: "", url: nil),
            TableItem(name: "Terms of use", detail: "", url: nil),
            TableItem(name: "Legal", detail: "", url: nil),
            TableItem(name: "Electronic access agreement", detail: "", url: nil)
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
        
        tableView.clpDelegate = self
        calendarView.scrollToDate(Date.init())
    }
    
    func setupCalendarView() {
        // Setup calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        // Setup labels
        calendarView.visibleDates { visibleDates in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    func handleCelltextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell  else { return }
        
        if cellState.isSelected {
            validCell.dateLabel.textColor = .white
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
                validCell.dateLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
                validCell.dateLabel.font = UIFont.systemFont(ofSize: 13)
            }
        }
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else { return }
        if validCell.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "yyyy"
        let year = self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM"
        let month = self.formatter.string(from: date)
        titleButton.setTitle("\(month) \(year)", for: .normal)
        
        let fDate = visibleDates.monthDates.first!.date
        let df = DateFormatter(withFormat: "yyyy-MM-dd'T'HH:mm:ss", locale: "en_US_POSIX")
        let startTime = df.string(from: fDate)
        
        let lDate = visibleDates.monthDates.last!.date
        let endTime = df.string(from: lDate)
        
        let params = "?startTime=\(startTime)&endTime=\(endTime)&pageSize=0"
        remote.fetchCollections(byPath: "/courseSchedules" + params) { result in
            if case .success(let value) = result {
                DispatchQueue.main.async {
                    let dict = Dictionary.init(grouping: value.data, by: { schedule in
                        // to be like '2018-08-05'
                        df.string(from: schedule.startAt!).components(separatedBy: "T").first!
                    })
                    self.dateEventsDict.merge(dict, uniquingKeysWith: { (_, new) -> [TCJsonSchedule] in new })
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension TCCalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2018 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
}

extension TCCalendarViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    

    // Display the cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        cell.dateLabel.text = cellState.text
        handleCellSelected(view: cell, cellState: cellState)
        handleCelltextColor(view: cell, cellState: cellState)
        if date.tcDate == Date().tcDate {
            cell.selectedView.isHidden = false
            cell.selectedView.backgroundColor = .orange
        }
        

        cell.eventsCount = dateEventsDict[date.tcDate]?.count ?? 0
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCelltextColor(view: cell, cellState: cellState)
        print("didSelectDate: \(date)")
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"
        selectedDate = dateFormatterPrint.string(from: date)
        tableView.reloadData()
        
//        if let date = dateFormatterGet.date(from: "2016-02-29 12:24:26"){
//            print(dateFormatterPrint.string(from: date))
//        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCelltextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
}

extension TCCalendarViewController: CollapsibleTableSectionDelegate {
    
    func numberOfSections(_ tableView: UITableView) -> Int {
        guard let sd = selectedDate else {return 0}
        return dateEventsDict[sd]?.count ?? 0
    }
    
    func collapsibleTableView(_ tableView: UITableView, sectionInfoAt section: Int) -> TableSection? {
        let section: TableSection = sections[section]
        return section
    }
    
    func collapsibleTableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func collapsibleTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kMBMenuTableCell") as! MBMenuTableCell
        
        guard let sd = selectedDate,
            let events = dateEventsDict[sd]
            else {return cell}

        let name = events[indexPath.row]
        cell.textLabel?.text = name.desc
        return cell
    }
    
    // header/footer
    func collapsibleTableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 68
    }
    
    func collapsibleTableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func shouldCollapseByDefault(_ tableView: UITableView, section: Int) -> Bool {
        return section != 0
    }
    
    func shouldCollapseOthers(_ tableView: UITableView) -> Bool {
        return false
    }
    
    // action
    func collapsibleTableView(_ tableView: UITableView, didSelectSectionHeaderAt section: Int) {}
    
    func collapsibleTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }
    }
}

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

extension Date {
    // "2018-01-01"
    var tcDate: String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"
        return dateFormatterPrint.string(from: self)
    }
}
