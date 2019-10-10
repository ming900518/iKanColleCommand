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
        let backgroundColor = UIColor(hexString: "#FBFBFB")
        self.view.backgroundColor = backgroundColor
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.landscape = true
        //UIDevice.current.setValue(NSNumber(value: UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")

        let toolbar = UIView()
        toolbar.backgroundColor = backgroundColor
        self.view.addSubview(toolbar)

        let titleBar = UIView()
        toolbar.addSubview(titleBar)
        titleBar.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.width.equalTo(self.view.snp.width)
            maker.height.equalTo(44)
        }

        let titleText = UILabel()
        titleText.text = "便携式舰队司令部-简体版设定"
        titleText.textColor = UIColor.black
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
        toolbarDivider.backgroundColor = UIColor(hexString: "#DDDDDD")
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

        settingTable = UITableView(frame: CGRect.zero, style: .grouped)
        settingTable.delegate = self
        settingTable.dataSource = self
        settingTable.backgroundColor = UIColor.clear
        self.view.addSubview(settingTable)
        settingTable.snp.makeConstraints { maker in
            maker.width.equalTo(self.view.snp.width)
            maker.top.equalTo(toolbar.snp.bottom)
            maker.bottom.equalTo(self.view.snp.bottom)
        }
    }

    @objc func close() {
        dismiss(animated: true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.landscape = true
        //UIDevice.current.setValue(NSNumber(value: UIInterfaceOrientation.landscapeRight.rawValue), forKey: "orientation")
    }

}

extension SettingVC: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
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
                selector.addAction(UIAlertAction(title: "确定", style: .default) { action in
                    let selected = picker.selectedRow(inComponent: 0)
                    print("Selected : \(selected)")
                    Setting.saveRetryCount(value: selected)
                    self.settingTable.reloadData()
                })
                selector.addAction(UIAlertAction(title: "取消", style: .cancel))
                self.present(selector, animated: true)
            } else if (indexPath.row == 1) {
                let dialog = UIAlertController(title: nil, message: "使用后游戏会被登出", preferredStyle: .alert)
                dialog.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                dialog.addAction(UIAlertAction(title: "执行", style: .default) { action in
                    if let cookies = HTTPCookieStorage.shared.cookies {
                        for cookie in cookies {
                            HTTPCookieStorage.shared.deleteCookie(cookie)
                        }
                    }
                    NotificationCenter.default.post(Notification.init(name: Constants.RELOAD_GAME))
                    self.close()
                })
                self.present(dialog, animated: true)
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row == 1) {
                let dialog = UIAlertController(title: "请选择渠道", message: nil, preferredStyle: .alert)
                dialog.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                dialog.addAction(UIAlertAction(title: "支付宝", style: .default) { action in
                    if let url = URL(string: "https://qr.alipay.com/tsx04467wmwmuqfxcmwmt7e") {
                        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                    }
                })
//                dialog.addAction(UIAlertAction(title: "微信", style: .default) { action in
//                    PHPhotoLibrary.requestAuthorization { status in
//                        switch (status) {
//                        case .authorized:
//                            if let codeImage = UIImage(named: "wechat_qrcode.png") {
//                                UIImageWriteToSavedPhotosAlbum(codeImage, nil, nil, nil)
//                                let dialog = UIAlertController(title: nil, message: "二维码已保存到相册。请至微信[右上角加号]→[扫一扫]→[相册]选择二维码完成捐赠", preferredStyle: .alert)
//                                dialog.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
//                                dialog.addAction(UIAlertAction(title: "去微信", style: .default) { action in
//                                    if let url = URL(string: "weixin://") {
//                                        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
//                                    }
//                                })
//                                self.present(dialog, animated: true)
//                            }
//                            break
//                        default:
//                            let dialog = UIAlertController(title: nil, message: "App需要相册权限，请授予", preferredStyle: .alert)
//                            dialog.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
//                            dialog.addAction(UIAlertAction(title: "去设置", style: .default) { action in
//                                if let url = URL(string: UIApplication.openSettingsURLString) {
//                                    UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
//                                }
//                            })
//                            self.present(dialog, animated: true)
//                            break
//                        }
//                    }
//                })
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
        return 2
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
                cell.backgroundColor = UIColor.white
                cell.textLabel?.text = "连接重试次数 (0为不重试)"
                cell.detailTextLabel?.text = "\(Setting.getRetryCount())"
                cell.accessoryType = .disclosureIndicator
                return cell
            } else if (indexPath.row == 1) {
                let cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
                cell.backgroundColor = UIColor.white
                cell.textLabel?.text = "清除Cookie"
                cell.detailTextLabel?.text = "当游戏出现问题时可以尝试看看"
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
                cell.backgroundColor = UIColor.white
                cell.textLabel?.text = "当前版本"
                if let versionCode = Bundle.main.infoDictionary?["CFBundleShortVersionString"] {
                    cell.detailTextLabel?.text = "\(versionCode)"
                }
                return cell
            } else if (indexPath.row == 1) {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
                cell.backgroundColor = UIColor.white
                cell.textLabel?.text = "程式功能"
                cell.detailTextLabel?.text = "基本游戏、辅助程式、大破警告"
                return cell
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
                cell.backgroundColor = UIColor.white
                cell.textLabel?.text = "提示：第一次游玩游戏时，会在背景下载缓存"
                cell.detailTextLabel?.text = "重启App就会使用缓存，让游戏更顺畅"
                cell.detailTextLabel?.textColor = UIColor.lightGray
                return cell
            } else if (indexPath.row == 1) {
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
                cell.backgroundColor = UIColor.white
                cell.textLabel?.text = "捐赠原作者（非修改版作者）"
                cell.detailTextLabel?.text = "支持原本的大佬吧～我就不用了，大家玩得开心最重要"
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

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
