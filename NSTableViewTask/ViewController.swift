//
//  ViewController.swift
//  NSTableViewTask
//
//  Created by Amish on 12/09/19.
//  Copyright © 2019 Amish. All rights reserved.
//

import Cocoa
import AppKit

class ViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var overlayView: NSView!
    @IBOutlet weak var detailImageView: NSImageView!
    
    internal let imageCellId = "imageCell"
    internal let descriptionCellId = "descriptionCell"
    internal let imageColumnId = "imageColumn"
    internal let descriptionColumnId = "descriptionColumn"
    
    private let data: [[String:String]] = [
        ["image":"harleyDavidson", "description": "Harley Davidson"],
        ["image":"abstract", "description": "Abstract"],
        ["image":"bird", "description": "Bird"],
        ["image":"cityScape", "description": "Cityscape"],
        ["image":"lake", "description": "Lake"],
        ["image":"nightSky", "description": "NightSky"]
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override var representedObject: Any? {
        didSet {
        }
    }
    
    @IBAction func closeOverlayViewAction(_ sender: NSButton) {
        overlayView.isHidden = true
    }
    
}

private extension ViewController {
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        overlayView.layer?.backgroundColor = NSColor.black.cgColor
    }
    
    func handle(viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: imageColumnId) {
            let imageCell = makeImageCell(withRow: row)
            return imageCell
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: descriptionColumnId) {
            let descriptionCell = makeDescriptionCell(withRow: row)
            return descriptionCell
        }
        
        return nil
    }
    
    func makeImageCell(withRow row: Int) -> NSView? {
        let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: imageCellId)
        guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
        if let imageName = data[row]["image"], let image = NSImage(named: NSImage.Name(imageName)) {
            cellView.imageView?.image = image
        }
        return cellView
    }
    
    func makeDescriptionCell(withRow row: Int) -> NSView? {
        let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: descriptionCellId)
        guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
        if let description = data[row]["description"] {
            cellView.textField?.stringValue = description
        }
        return cellView
    }
    
}

extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return data.count
    }
}

extension ViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = handle(viewFor: tableColumn, row: row)
        return cellView
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let tableView = notification.object as? NSTableView else {
            return
        }
        let row = tableView.selectedRow
        
        performSegue(withIdentifier: NSStoryboardSegue.Identifier("detailView"), sender: self)
        
        if let imageName = data[row]["image"], let image = NSImage(named: NSImage.Name(imageName)) {
            self.overlayView.isHidden = false
            detailImageView.image = image
        }
        
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50
    }
}
