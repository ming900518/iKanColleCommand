//
// Created by CC on 2019-06-24.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Photos

class SettingVC: UIViewController {

    private let cellIdentifier = "SettingCell"
    private var settingTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let toolbar = UIView()
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = UIColor.systemBackground
            //toolbar.backgroundColor = UIColor.systemFill
        } else {
            self.view.backgroundColor = UIColor(hexString: "#FBFBFB")
            //toolbar.backgroundColor = UIColor(hexString: "#FBFBFB")
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.landscape = true
        self.view.addSubview(toolbar)

        let titleBar = UIView()
        toolbar.addSubview(titleBar)
        titleBar.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.width.equalTo(self.view.snp.width)
            maker.height.equalTo(44)
        }

        let titleText = UILabel()
        titleText.text = "设定"
        if #available(iOS 13.0, *) {
            titleText.textColor = UIColor.label
        } else {
            titleText.textColor = UIColor.black
        }
        titleBar.addSubview(titleText)
        titleText.snp.makeConstraints { maker in
            maker.center.equalTo(titleBar.snp.center)
        }

        toolbar.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.snp.top)
            maker.width.equalTo(self.view.snp.width)
            maker.bottom.equalTo(titleBar.snp.bottom)
        }

        let toolbarDivider = UIView()
        if #available(iOS 13.0, *) {
            toolbarDivider.backgroundColor = UIColor.separator
        } else {
            toolbarDivider.backgroundColor = UIColor(hexString: "#DDDDDD")
        }
        toolbar.addSubview(toolbarDivider)
        toolbarDivider.snp.makeConstraints { maker in
            maker.width.equalTo(toolbar.snp.width)
            maker.height.equalTo(1)
            maker.bottom.equalTo(toolbar.snp.bottom)
        }

        let closeBtn = UIButton(type: .system)
        closeBtn.setTitle("关闭", for: .normal)
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        titleBar.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { maker in
            maker.centerY.equalTo(titleBar.snp.centerY)
            maker.right.equalTo(titleBar.snp.right).offset(-16)
        }

        if #available(iOS 13.0, *) {
            settingTable = UITableView(frame: CGRect.zero, style: .insetGrouped)
        } else {
            settingTable = UITableView(frame: CGRect.zero, style: .grouped)
        }
        settingTable.delegate = self
        settingTable.dataSource = self
        if #available(iOS 13.0, *) {
            settingTable.backgroundColor = UIColor.systemGroupedBackground
        } else {
            settingTable.backgroundColor = UIColor.clear
        }
        self.view.addSubview(settingTable)
        settingTable.snp.makeConstraints { maker in
            maker.width.equalTo(self.view.snp.width)
            maker.top.equalTo(toolbar.snp.bottom)
            maker.bottom.equalTo(self.view.snp.bottom)
        }
        CacheManager.checkCachedfiles()
    }

    @objc func close() {
        dismiss(animated: true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.landscape = true
         }
    }

extension SettingVC: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                var connection = String()
                if Setting.getconnection() == 1{
                    connection = "官方DMM网站（VPN/日本）"
                } else if Setting.getconnection() == 2 {
                    connection = "缓存系统ooi"
                } else if Setting.getconnection() == 3 {
                    connection = "缓存系统kancolle.su"
                } else if Setting.getconnection() == 4 {
                    connection = "官方DMM网站（修改Cookies，海外）"
                } else {
                    connection = "未知"
                }
                let info = UIAlertController(title: "请选择连线方式", message: "目前使用：\(connection)", preferredStyle: .actionSheet)
                if let popoverController = info.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
                info.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                info.addAction(UIAlertAction(title: "官方DMM网站（VPN/日本）", style: .default) { action in
                    Setting.saveconnection(value: 1)
                    self.close()
                })
                info.addAction(UIAlertAction(title: "官方DMM网站（修改Cookies，海外）", style: .default) { action in
                    Setting.saveconnection(value: 4)
                    self.close()
                })
                info.addAction(UIAlertAction(title: "缓存系统ooi（全球用户可用）", style: .default) { action in
                    Setting.saveconnection(value: 2)
                    self.close()
                })
                info.addAction(UIAlertAction(title: "缓存系统kancolle.su（大陆地区以外）", style: .default) { action in
                    Setting.saveconnection(value: 3)
                    self.close()
                })
                self.present(info, animated: true)
                print("Selected: ", Setting.getconnection())
                self.settingTable.reloadData()
            } else if (indexPath.row == 1) {
                let info = UIAlertController(title: "请选择大破警告的类型", message: "选择类型2的情况下关闭推播通知会自动改为类型1\n\n目前使用：类型\(Setting.getwarningAlert())" ,preferredStyle: .actionSheet)
                if let popoverController = info.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
                info.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                info.addAction(UIAlertAction(title: "1. 增强型（警告视窗）", style: .default) { action in
                    Setting.savewarningAlert(value: 1)
                    self.close()
                })
                info.addAction(UIAlertAction(title: "2. 增强型（推播通知）", style: .default) { action in
                    Setting.savewarningAlert(value: 2)
                    self.close()
                })
                info.addAction(UIAlertAction(title: "3. 一般型（仅有画面红框）", style: .default) { action in
                    Setting.savewarningAlert(value: 3)
                    self.close()
                })
                self.present(info, animated: true)
                print("Selected: ", Setting.getwarningAlert())
                self.settingTable.reloadData()
            } else if (indexPath.section == 2){
                //App Appearance
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0){
                print("[INFO] Retry setting started by user.")
                let selector: UIAlertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
                let picker = UIPickerView()
                selector.view.addSubview(picker)
                picker.snp.makeConstraints { maker in
                    maker.width.equalTo(selector.view.snp.width)
                    maker.height.equalTo(200)
                }
                picker.dataSource = self
                picker.delegate = self
                picker.selectRow(Setting.getRetryCount(), inComponent: 0, animated: false)
                if let popoverController = selector.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
                selector.addAction(UIAlertAction(title: "确定", style: .default) { action in
                    let selected = picker.selectedRow(inComponent: 0)
                    print("Selected : \(selected)")
                    Setting.saveRetryCount(value: selected)
                    self.settingTable.reloadData()
                    print("[INFO] New retry setting has been set.")
                })
                selector.addAction(UIAlertAction(title: "取消", style: .cancel))
                self.present(selector, animated: true)
            } else if (indexPath.row == 1) {
                print("[INFO] Cleaner started by user.")
                let dialog = UIAlertController(title: "使用须知", message: "1. 这功能会清空App所下载的Caches和Cookies\n2. 下次游戏载入时就会重新下载Caches，Cookies会自动重设\n3. 清除完毕后会自动关闭本App以确保完整清除", preferredStyle: .actionSheet)
                if let popoverController = dialog.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
                dialog.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                dialog.addAction(UIAlertAction(title: "我了解了，执行清理", style: .destructive) { action in
                    print("[INFO] Cleaner confirmed by user. Start cleaning.")
                    if let cookies = HTTPCookieStorage.shared.cookies {
                        for cookie in cookies {
                            HTTPCookieStorage.shared.deleteCookie(cookie)
                        }
                    }
                    CacheManager.clearCache()
                    print("[INFO] Everything cleaned.")
                    let result = UIAlertController(title: "清理完成", message: "本App即将关闭", preferredStyle: .alert)
                    result.addAction(UIAlertAction(title: "确定", style: .default) { action in
                        exit(0)
                    })
                    self.present(result, animated: true)
                })
                self.present(dialog, animated: true)
            } else if (indexPath.row == 2) {
                if Setting.getchangeCacheDir() == 0 {
                    let dialog = UIAlertController(title: "功能说明", message: "1. 本功能开启后，用户能自行修改Cache内容\n2. 启用前会先清理缓存，功能启用完成后会关闭本App\n\n免责声明：如自行修改造成游戏不稳定或白底黑字的状况，本App相关所有开发者均不对此负责",    preferredStyle: .actionSheet)
                    if let popoverController = dialog.popoverPresentationController {
                        popoverController.sourceView = self.view
                        popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                        popoverController.permittedArrowDirections = []
                    }
                    dialog.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                    dialog.addAction(UIAlertAction(title: "我已了解,使用本功能", style: .destructive) { action in
                        print("[INFO] Cleaner confirmed by user. Start cleaning.")
                        if let cookies = HTTPCookieStorage.shared.cookies {
                            for cookie in cookies {
                                HTTPCookieStorage.shared.deleteCookie(cookie)
                            }
                        }
                        CacheManager.clearCache()
                        print("[INFO] Everything cleaned.")
                        Setting.savechangeCacheDir(value: 1)
                        let result = UIAlertController(title: "功能开启完成", message: "本App即将关闭", preferredStyle: .alert)
                        result.addAction(UIAlertAction(title: "确定", style: .default) { action in
                            exit(0)
                        })
                        self.present(result, animated: true)
                    })
                    self.present(dialog, animated: true)
                } else {
                    let dialog = UIAlertController(title: "功能说明", message: "1. 本功能关闭后，用户不再能自行修改Cache内容\n2. 关闭前会先清理缓存，所有之前做出的变更均会被删除，功能关闭完成后会关闭本App", preferredStyle: .actionSheet)
                    if let popoverController = dialog.popoverPresentationController {
                        popoverController.sourceView = self.view
                        popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                        popoverController.permittedArrowDirections = []
                    }
                    dialog.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                    dialog.addAction(UIAlertAction(title: "关闭本功能", style: .destructive) { action in
                        print("[INFO] Cleaner confirmed by user. Start cleaning.")
                        if let cookies = HTTPCookieStorage.shared.cookies {
                            for cookie in cookies {
                                HTTPCookieStorage.shared.deleteCookie(cookie)
                            }
                        }
                        CacheManager.clearCache()
                        print("[INFO] Everything cleaned.")
                        Setting.savechangeCacheDir(value: 0)
                        let result = UIAlertController(title: "功能关闭完成", message: "本App即将关闭", preferredStyle: .alert)
                        result.addAction(UIAlertAction(title: "确定", style: .default) { action in
                            exit(0)
                        })
                        self.present(result, animated: true)
                    })
                    self.present(dialog, animated: true)
                }
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row == 1) {
                let info = UIAlertController(title: "关于本App", message: "本App修改自NGA用户亖葉(UID42542015)于2019年7月4号发布的iKanColleCommand专案，提供iOS用户稳定的舰队收藏游戏环境和基本的辅助程式功能。\n\n修​​改者：Ming Chang\n\n特别感谢\nDavid Huang（图形技术支援、巴哈文维护）\n@Senka_Viewer（OOI相关技术支援）",preferredStyle: .actionSheet)
                if let popoverController = info.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
                info.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                info.addAction(UIAlertAction(title: "前往本修改版App官方网站", style: .default) { action in
                    if let url = URL(string:"https://kc2tweaked.github.io") {
                    UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                    }
                })
                info.addAction(UIAlertAction(title: "加入Discord", style: .default) { action in
                    if let url = URL(string:"https://discord.gg/Yesf3cN") {
                    UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                    }
                })
                self.present(info, animated: true)
            } else if (indexPath.row == 2) {
                let dialog = UIAlertController(title: "请选择渠道", message: nil, preferredStyle: .actionSheet)
                if let popoverController = dialog.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
                dialog.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                dialog.addAction(UIAlertAction(title: "支付宝", style: .default) { action in
                    if let url = URL(string: "https://qr.alipay.com/tsx04467wmwmuqfxcmwmt7e") {
                        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                    }
                })
                dialog.addAction(UIAlertAction(title: "微信", style: .default) { action in
                    if let url = URL(string:"https://ming900518.github.io/page/wechat_qrcode.png") {
                        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                    }
                })
                self.present(dialog, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
}

extension SettingVC: UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title2 = section == 2 ? "其他" : nil
        let title1 = section == 1 ? "连线与缓存" : title2
        let title = section == 0 ? "App设定" : title1
        return title
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                var connection = String()
                if Setting.getconnection() == 1{
                    connection = "官方DMM网站（VPN/日本）"
                } else if Setting.getconnection() == 2 {
                    connection = "缓存系统ooi"
                } else if Setting.getconnection() == 3 {
                    connection = "缓存系统kancolle.su"
                } else if Setting.getconnection() == 4 {
                    connection = "官方DMM网站（修改Cookies，海外）"
                } else {
                    connection = "未知"
                }
                let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
                cell.textLabel?.text = "连线方式"
                cell.detailTextLabel?.text = connection
                cell.accessoryType = .disclosureIndicator
                return cell
            } else if (indexPath.row == 1) {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
                cell.textLabel?.text = "大破警告"
                cell.detailTextLabel?.text = "类型\(Setting.getwarningAlert())"
                cell.accessoryType = .disclosureIndicator
                return cell
            } else if (indexPath.row == 2) {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
                cell.textLabel?.text = "App Icon切换"
                let switchView = UISwitch(frame: .zero)
                if Setting.getAppIconChange() == 0 {
                    switchView.setOn(false, animated: false)
                } else {
                    switchView.setOn(true, animated: false)
                }
                switchView.tag = indexPath.row // for detect which row switch Changed
                switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
                cell.accessoryView = switchView
                return cell
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
                cell.textLabel?.text = "连接重试次数 (0为不重试)"
                cell.detailTextLabel?.text = "\(Setting.getRetryCount())"
                cell.accessoryType = .disclosureIndicator
                return cell
            } else if (indexPath.row == 1) {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
                cell.textLabel?.text = "清理Caches和Cookies"
                cell.accessoryType = .disclosureIndicator
                return cell
            } else if (indexPath.row == 2) {
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
                cell.textLabel?.text = "App File Sharing"
                cell.detailTextLabel?.textColor = UIColor.lightGray
                if Setting.getchangeCacheDir() == 0 {
                    cell.detailTextLabel?.text = "功能尚未启用，启用本功能后无需越狱即可使用iFunBox等档案管理工具对Cache进行修改"
                } else {
                    cell.detailTextLabel?.text = "功能已启用"
                }
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
                cell.textLabel?.text = "App版本"
                cell.isUserInteractionEnabled = false
                if let versionCode = Bundle.main.infoDictionary?["CFBundleShortVersionString"] {
                    cell.detailTextLabel?.text = "\(versionCode)"
                }
                return cell
            } else if (indexPath.row == 1) {
                let cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
                cell.textLabel?.text = "关于本App"
                cell.accessoryType = .disclosureIndicator
                return cell
            } else if (indexPath.row == 2) {
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
                cell.textLabel?.text = "捐赠原作者"
                cell.detailTextLabel?.text = "支持原本的大佬吧～"
                cell.detailTextLabel?.textColor = UIColor.lightGray
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        }
    return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
    }

    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(40)
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 6
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    @objc public func switchChanged(_ sender : UISwitch!){
        print("table row switch Changed \(sender.tag)")
        print("The switch is \(sender.isOn ? "ON" : "OFF")")
        if sender.isOn == true {
            if UIApplication.shared.supportsAlternateIcons {
                print("current icon is primary icon, change to alternative icon")
                UIApplication.shared.setAlternateIconName("AlternateIcon"){ error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Done!")
                    }
                }
                Setting.saveAppIconChange(value: 1)
            }
        } else {
            print("change to primary icon")
            UIApplication.shared.setAlternateIconName(nil)
            Setting.saveAppIconChange(value: 0)
        }
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
