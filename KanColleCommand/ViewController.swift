import UIKit
import SnapKit
import WebKit
import RxSwift
import UserNotifications

class ViewController: UIViewController, UIScrollViewDelegate {

    static let DEFAULT_BACKGROUND = UIColor(white: 0.23, alpha: 1)
    private var webView: KCWebView!
    private var scrollView: UIScrollView!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.landscape = true
        UIApplication.shared.isIdleTimerDisabled = true
        if Setting.getUseTheme() == 1 {
            self.view.backgroundColor = UIColor.init(white: 0, alpha: 1)
        } else {
            self.view.backgroundColor = UIColor.init(white: 0.185, alpha: 1)
        }
        
        if Setting.getfirstStartup() != 0 {
            if Setting.getconnection() == 0 {
                self.loginChanger()
            }
        }

        webView = KCWebView()
        webView.setup(parent: self.view)
        webView.load()
        if Setting.getconnection() == 1 {
            if self.isConnectedToVpn == true {
                if Setting.getfirstStartup() != 0 {
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                    let notificationCenter = UNUserNotificationCenter.current()
                    let content = UNMutableNotificationContent()
                    content.title = "侦测到使用VPN"
                    content.body = "ACGP用户请至设定中将大小调整为1，以免出现白边"
                    let identifier = "VPN Notification"
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
                    notificationCenter.add(request) { (error) in
                        if let error = error {
                            print("Error \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
        webView.scrollView.isScrollEnabled = true;
        self.webView.isOpaque = false;
        self.webView.backgroundColor = UIColor.black
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .always;
            webView.scalesPageToFit = true;
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadGame), name: Constants.RELOAD_GAME, object: nil)

        let badlyDamageWarning = UIImageView(image: UIImage(named: "badly_damage_warning.png")?.resizableImage(
                withCapInsets: UIEdgeInsets.init(top: 63, left: 63, bottom: 63, right: 63), resizingMode: .stretch))
        badlyDamageWarning.isHidden = true
        self.view.addSubview(badlyDamageWarning)
        badlyDamageWarning.snp.makeConstraints { maker in
            maker.edges.equalTo(webView)
        }
        Oyodo.attention().watch(data: Fleet.instance.shipWatcher) { (event: Event<Transform>) in
            var show = false
                if (Battle.instance.friendCombined) {
                    var phase = Phase.Idle
                        do {
                            phase = try Battle.instance.phase.value()
                        } catch {
                            print("Error when call phase.value()")
                        }
                    show = (Fleet.instance.isBadlyDamage(index: 0) || Fleet.instance.isBadlyDamage(index: 1))
                        && (phase != Phase.Idle)
                } else {
                    let battleFleet = Battle.instance.friendIndex
                    show = battleFleet >= 0 && Fleet.instance.isBadlyDamage(index: battleFleet)
                }
                badlyDamageWarning.isHidden = !show
            if Setting.getwarningAlert() == 1 {
                let warningAlert = UIAlertController(title: "⚠️ 大破 ⚠️", message: "あうぅっ！ 痛いってばぁっ！\n(つД`)", preferredStyle: .alert)
                warningAlert.addAction(UIAlertAction(title: "はい、はい、知っています", style: .destructive, handler: nil))
                if show == true {
                    self.present(warningAlert, animated: true)
                }
            } else if Setting.getwarningAlert() == 2 {
                let notificationCenter = UNUserNotificationCenter.current()
                let warningAlert = UNMutableNotificationContent()
                warningAlert.title = "⚠️ 大破 ⚠️"
                warningAlert.body = "あうぅっ！ 痛いってばぁっ！(つД`)"
                warningAlert.sound = UNNotificationSound.default
                let identifier = "EHDA Notification"
                let request = UNNotificationRequest(identifier: identifier, content: warningAlert, trigger: nil)
                if show == true {
                    notificationCenter.add(request) { (error) in
                        if let error = error {
                            print("Error \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
        let settingBtn = UIButton(type: .custom)
        settingBtn.setImage(UIImage(named: "setting.png"), for: .normal)
        settingBtn.imageEdgeInsets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        if Setting.getUseTheme() == 1 {
            settingBtn.backgroundColor = UIColor.init(white: 0, alpha: 1)
        } else {
            settingBtn.backgroundColor = UIColor.init(white: 0.185, alpha: 1)
        }
        self.view.addSubview(settingBtn)
        if (UIScreen.current == .iPhone5_8) { //iPhone X XS 11Pro
            settingBtn.snp.makeConstraints { maker in
                maker.width.equalTo(40)
                maker.height.equalTo(40)
                maker.right.equalTo(webView.snp.left)
                maker.top.equalTo(webView.snp.top).inset(11)
            }
        } else if (UIScreen.current == .iPhone6_1) { //iPhone XR 11
            settingBtn.snp.makeConstraints { maker in
                maker.width.equalTo(40)
                maker.height.equalTo(40)
                maker.right.equalTo(webView.snp.left)
                maker.top.equalTo(webView.snp.top).inset(11)
            }
        } else if (UIScreen.current == .iPhone6_5) { //iPhone XS Max 11Pro Max
            settingBtn.snp.makeConstraints { maker in
                maker.width.equalTo(40)
                maker.height.equalTo(40)
                maker.right.equalTo(webView.snp.left)
                maker.top.equalTo(webView.snp.top).inset(11)
            }
        } else if (UIScreen.current > .iPad10_5) { //iPad Pro
            settingBtn.snp.makeConstraints { maker in
                maker.width.equalTo(40)
                maker.height.equalTo(40)
                maker.right.equalTo(webView.snp.left)
                maker.top.equalTo(webView.snp.top).inset(11)
            }
        } else {
            settingBtn.snp.makeConstraints { maker in
                maker.width.equalTo(40)
                maker.height.equalTo(40)
                maker.right.equalTo(webView.snp.left)
                maker.top.equalTo(webView.snp.top)
            }
        }
        settingBtn.addTarget(self, action: #selector(openSetting), for: .touchUpInside)

        let refreshBtn = UIButton(type: .custom)
        refreshBtn.setImage(UIImage(named: "reload.png"), for: .normal)
        refreshBtn.imageEdgeInsets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        if Setting.getUseTheme() == 1 {
            refreshBtn.backgroundColor = UIColor.init(white: 0, alpha: 1)
        } else {
            refreshBtn.backgroundColor = UIColor.init(white: 0.185, alpha: 1)
        }
        self.view.addSubview(refreshBtn)
        refreshBtn.snp.makeConstraints { maker in
            maker.width.equalTo(40)
            maker.height.equalTo(40)
            maker.right.equalTo(settingBtn.snp.right)
            maker.top.equalTo(settingBtn.snp.bottom)
        }
        refreshBtn.addTarget(self, action: #selector(confirmRefresh), for: .touchUpInside)
        
        let appearanceBtn = UIButton(type: .custom)
        if #available(iOS 13.0, *) {
            let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
            appearanceBtn.setImage(UIImage(systemName: "pencil", withConfiguration: boldConfig), for: .normal)
            appearanceBtn.tintColor = UIColor.white
        } else {
            appearanceBtn.setImage(UIImage(named: "refresh.png"), for: .normal)
        }
        appearanceBtn.imageEdgeInsets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        if Setting.getUseTheme() == 1 {
            appearanceBtn.backgroundColor = UIColor.init(white: 0, alpha: 1)
        } else {
            appearanceBtn.backgroundColor = UIColor.init(white: 0.185, alpha: 1)
        }
        self.view.addSubview(appearanceBtn)
        appearanceBtn.snp.makeConstraints { maker in
            maker.width.equalTo(40)
            maker.height.equalTo(40)
            maker.centerX.equalTo(refreshBtn.snp.centerX)
            maker.bottom.equalTo(view.snp.bottom).inset(20)
        }
        appearanceBtn.addTarget(self, action: #selector(openAppearance), for: .touchUpInside)

        Drawer().attachTo(controller: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Setting.getfirstStartup() == 0 {
            self.loginChanger()
        } else {
            if Setting.getconnection() == 0{
                let alert = UIAlertController(title: "未选择预设登入方式", message: "请选择以下其中一种操作", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "选择预设登入方式", style: .default) { action in
                    self.loginChanger()
                })
                alert.addAction(UIAlertAction(title: "清理Caches和Cookies", style: .default) { action in
                    self.cleaner()
                })
                alert.addAction(UIAlertAction(title: "关闭本App", style: .destructive) { action in
                    exit(0)
                    })
                self.present(alert, animated: true)
            }
        }
    }

    @objc func confirmRefresh() {
        let dialog = UIAlertController(title: nil, message: "重新整理页面", preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        dialog.addAction(UIAlertAction(title: "确定", style: .default) { action in
            self.reloadGame()
        })
        present(dialog, animated: true)
    }

    @objc func openSetting() {
        let settingVC = SettingVC()
        present(settingVC, animated: true)
    }
    
    @objc func openAppearance() {
        let appearanceVC = AppearanceVC()
        present(appearanceVC, animated: true)
    }

    @objc func reloadGame() {
        self.webView.loadBlankPage()
        self.webView.load()
    }
    
    func cleaner() {
        print("[INFO] Cleaner started by user.")
        let dialog = UIAlertController(title: "使用须知", message: "1. 这功能会清空App所下载的Caches和Cookies\n2. 下次游戏载入时就会重新下载Caches，Cookies会自动重设\n3. 清除完毕后会自动关闭本App以确保完整清除", preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "取消", style: .cancel) { action in
            self.blankPage()
        })
        dialog.addAction(UIAlertAction(title: "我了解了，执行清理", style: .destructive) { action in
            print("[INFO] Cleaner confirmed by user. Start cleaning.")
            if let cookies = HTTPCookieStorage.shared.cookies {
                for cookie in cookies {
                    HTTPCookieStorage.shared.deleteCookie(cookie)
                }
            }
            CacheManager.clearCache()
            print("[INFO] Everything cleaned.")
            let result = UIAlertController(title: "清理完成", message: nil, preferredStyle: .alert)
            result.addAction(UIAlertAction(title: "确定", style: .default) { action in
                self.blankPage()
            })
            self.present(result, animated: true)
        })
        self.present(dialog, animated: true)
    }
    
    @objc func loginChanger(){
        let dialog = UIAlertController(title: "欢迎使用便携式舰队司令部", message: "请选择预设登入游戏方式\n需要变更可至设定中进行变更", preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "官方DMM网站（VPN/日本）", style: .default) { action in
            Setting.saveconnection(value: 1)
            let url = URL(string: Constants.HOME_PAGE)
            self.webView.loadRequest(URLRequest(url: url!))
        })
        dialog.addAction(UIAlertAction(title: "官方DMM网站（修改Cookies，海外）", style: .default) { action in
            Setting.saveconnection(value: 4)
            let url = URL(string: Constants.HOME_PAGE)
            self.webView.loadRequest(URLRequest(url: url!))
        })
        dialog.addAction(UIAlertAction(title: "缓存系统ooi（全球用户可用）", style: .default) { action in
            Setting.saveconnection(value: 2)
            let url = URL(string: Constants.OOI)
            self.webView.loadRequest(URLRequest(url: url!))
            if UIScreen.current <= .iPhone6_5 {
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                let notificationCenter = UNUserNotificationCenter.current()
                let content = UNMutableNotificationContent()
                content.title = "首次使用ooi登入方式提示"
                content.body = "请选择以「在POI中运行」方式登入以获得最佳游戏体验"
                let identifier = "ooi Notification"
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
                notificationCenter.add(request) { (error) in
                    if let error = error {
                        print("Error \(error.localizedDescription)")
                    }
                }
            }
        })
        dialog.addAction(UIAlertAction(title: "缓存系统kancolle.su（大陆地区以外）", style: .default) { action in
            Setting.saveconnection(value: 3)
            let url = URL(string: Constants.kcsu)
            self.webView.loadRequest(URLRequest(url: url!))
            if UIScreen.current <= .iPhone6_5 {
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                let notificationCenter = UNUserNotificationCenter.current()
                let content = UNMutableNotificationContent()
                content.title = "首次使用kancolle.su登入方式提示"
                content.body = "请选择以「Fullscreen - Optimised for poi and smartphones」方式登入以获得最佳游戏体验"
                let identifier = "kcsu Notification"
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
                notificationCenter.add(request) { (error) in
                    if let error = error {
                        print("Error \(error.localizedDescription)")
                    }
                }
            }
        })
        dialog.addAction(UIAlertAction(title: "取消", style: .destructive) { action in
            self.blankPage()
        })
        present(dialog, animated: true)
        Setting.savefirstStartup(value: 1)
    }
    
    @objc func blankPage(){
        let blank = "about:blank"
        let currentPage = self.webView.request!.url!.absoluteString
        if currentPage == blank {
            var titleText: String?
            if Setting.getconnection() == 0 {
                titleText = "未选择预设登入方式"
            } else {
                titleText = "游戏尚未开启"
            }
            let alert = UIAlertController(title: titleText, message: "请选择以下其中一种操作", preferredStyle: .alert)
            if Setting.getconnection() == 0 {
                alert.addAction(UIAlertAction(title: "选择预设登入方式", style: .default) { action in
                    self.loginChanger()
                })
            } else {
                
            }
            alert.addAction(UIAlertAction(title: "清理Caches和Cookies", style: .default) { action in
                self.cleaner()
            })
            alert.addAction(UIAlertAction(title: "关闭本App", style: .destructive) { action in
                exit(0)
                })
            self.present(alert, animated: true)
        } else {
            return
        }
    }
    private var isConnectedToVpn: Bool {
        if let settings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? Dictionary<String, Any>,
            let scopes = settings["__SCOPED__"] as? [String:Any] {
            for (key, _) in scopes {
             if key.contains("tap") || key.contains("tun") || key.contains("ppp") || key.contains("ipsec") {
                    return true
                }
            }
        }
        return false
    }
    override func viewWillDisappear(_ animated: Bool) {
        webView.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        webView.setup(parent: self.view)
        self.view.sendSubviewToBack(webView)
    }
}
