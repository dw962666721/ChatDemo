//
//  ChatDemo-Prefix.swift
//  ChatDemo
//
//  Created by user on 15/6/17.
//  Copyright (c) 2015年 user. All rights reserved.
//
// ChatDemo-Prefix.swift是Swift 代码用到的全局变量
// ChatDemo-Prefix.pch是oc代码用到的全局变量

//let ServerURL="http://115.28.200.220:8066/ajax/"
let ServerURL="http://139.129.10.129:8080/ajax/"

let screenHeight = UIScreen.mainScreen().bounds.height
let screenWidth = UIScreen.mainScreen().bounds.width
let ChatDemoUser = "userLoginName"
var getType="text/plain"
let sexArray = ["男","女"]
let womenFigure = ["苗条","丰满","高挑","娇小"];
let manFigure = ["精瘦","强壮","高大","偏矮"]
let nowLocation = "nowLocation"
let lastLocation = "lastLocation"
let  SystemVersion=atof(UIDevice.currentDevice().systemVersion)
let  IOS7:Bool=SystemVersion>=7.0&&SystemVersion<8
let  IOS8:Bool=SystemVersion>=8.0&&SystemVersion<9

let IS_IPHONE_5 = fabs(Double(screenHeight) - Double(568))<DBL_EPSILON
let IS_IPHONE_6 = fabs(Double(screenHeight) - Double(667))<DBL_EPSILON
let IS_IPHONE_6P = fabs(Double(screenHeight) - Double(736))<DBL_EPSILON

/// 注册登录
let PdUsernameURL = ServerURL + "pdusername.ashx" // 验证用户名是否存在
let RegistURL = ServerURL + "regist.ashx" // 注册
let LoginCheckBindUsers = ServerURL+"loginCheckBindUsers.ashx"// 验证第三方已登录
let LoginURL = ServerURL + "Login.ashx" // 登录
let kRedirectURL = "http://www.weibo.com"
let ReportURL = ServerURL + "Report.ashx" // 发送邮件
let XieYiURL = "http://139.129.10.129:8080/xieyi.html"

// 个人资料
let UpdateMyavatarURL = ServerURL + "updatemyavatar.ashx" // 修改头像
let GetMyphotoURL = ServerURL + "getmyphoto.ashx" // 获取相片
let AddphotoURL = ServerURL + "addphoto.ashx" // 添加相片
let DelphotoURL = ServerURL + "delphoto.ashx" // 删除相片
let GetMyDataURL = ServerURL + "getmydata.ashx" // 获取我的资料
let UpdateDataURL = ServerURL + "updatedata.ashx" // 修改个人资料
let GetUserDataURL = ServerURL + "getuserdata.ashx" // 获取用户资料
let GetUsermesByNumberURL = ServerURL + "getusermesbynumber.ashx" // 根据环信账号获取对方资料

// 会员
let GetMemberLevelURL = ServerURL + "getmemberlevel.ashx" // 获取会员等级
let BuyMemberOrderURL = ServerURL + "buymemberorder.ashx" // 生成订单号
let IapNotifyURL = ServerURL + "IapNotify.ashx" // 订单支付成功

// 安全中心
let SendMailURL = ServerURL + "sendmail.ashx" // 发送邮件
let UploadPwdURL = ServerURL + "uploadpwd.ashx" // 修改密码
let UpdateQQURL = ServerURL + "updateqq.ashx" // 修改QQ
let UpdateTelURL = ServerURL + "updatetel.ashx" // 修改手机
let ChangePwdURL = ServerURL + "changepwd.ashx" //忘记密码
let GetMailByUserName = ServerURL + "getmailbyusername.ashx" // 根据昵称获取用户邮箱

/// 附近的人
let GetUserListURL = ServerURL + "getuserlist.ashx" // 获取附近的人


// 好友
let GetMyFriendURL = ServerURL + "getmyfriend.ashx" // 获取好友列表
let AddFriendAskURL = ServerURL + "addfriendask.ashx" // 添加好友
let DelFriendURL = ServerURL + "delfriend.ashx" // 删除好友
let GetFriendAskURL = ServerURL + "getfriendask.ashx" // 获取好友请求
let AddFrienURL = ServerURL + "addfriend.ashx" // 同意好友请求
let RefusedFriendURL = ServerURL + "refusedfriend.ashx" // 拒绝好友请求
let GetfriendAskCountURL = ServerURL + "getfriendaskcount.ashx" // 获取好友请求未读个数

// 黑名单
let AddBlackListURL = ServerURL+"addblacklist.ashx" // 加入黑名单
let DelBlackListURL = ServerURL + "delblacklist.ashx" // 移除黑名单
let GetBlackListURL = ServerURL + "getblacklist.ashx" // 获取黑名单列表

let navigationController:()->UINavigationController!={
    var tabBarController=UIApplication.sharedApplication().keyWindow?.rootViewController as? UITabBarController
    
    return tabBarController?.selectedViewController as? UINavigationController
}

var messageBox:TFQAlertUtil! // 提示框
var bufferInfoView:BufferView! // 缓冲页面
let WXAppKey="wxf3e38f7900ef8e61"


//支付接口
let PdzfbURL = ServerURL + "pdzfb.ashx" // 判断是否允许支付宝支付
let PARTNER_ID = "j9nx1srgkm40n7zjsp1lzp0l124jao6n" //商户API密钥
let MCH_ID = "1252577701" // 微信商户号
let Partner = "2088121476526765" // 支付宝商户号
let Seller = "2088121476526765" // 支付宝商户号
let AlieServer = "mobile.securitypay.pay" // 支付宝移动支付服务
let AppScheme = "DwPayDemo" // 阿里支付后返回界面
let WxPayUrl = "https://api.mch.weixin.qq.com/pay/unifiedorder" // 微信支付服务
// 支付宝密钥
let privateKey = "MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAO67M55P0eCG1T3zkegcVckd6crfK8zMHwdnPMito28i8OKR1vswT6KZ0l5sNPUp5dZsKmvGhXNQzzbGnom4SAknFmZixgVlS5AfXZQ5g/tB0sTrtbXd7wlwvnHcCRfI2Kk1bLYrID10MWbKuFNAujU19odSxS9yYlSUrfWXM4HBAgMBAAECgYEA5Ytck6E+NXyP93SG2767AZlgni+95rpyL2UlvfOvjQH0ynXeV0JZoAf1jdLPjNgPZgA1PdHxqTKPO6T49YUaxM6Q9hyqBZXqF72OtoH4zjc7EEp51xbUt62ZHOi2VrlW7yOPCqlKK/GEOfNJ0phePvRuziRkiFuzMLknOjZV8NECQQD+qnxgsKaDX+g9Fngc8Kg/vEavAx17QsPKyxU5VJSAizTArhX0T4GYnBGsmEprEaUyOR33imLf0gpGv6iBv9kdAkEA7/tYzpDpNz40Ib2eEaqU2W7b6aSRsh/glFgxENGgjeH/yl6m4BTFpD4wfvj7X+tDiv6XqQQji9FPKnYOmIdN9QJBAIMukPlBpdSgr8Hf9Cl8Mj76njKC2UnoP3EUIa+xiPmaO6dRRY/e8LQLGPOeUx9KLJ1tXKlpyLrguFhvW77Sc2UCQFQU6o6lczDp2HYh66og7Doqf16jTHDufk87fyV3bRuJHYgYFbvZS046g99Y+SooUef3P8f2LUYltekYqBCFB6kCQQD7/a7Xztav2n0y43xRWk/bvF0YABuVMIvlIjdv91BHnp7t4h9Kh+EouQxIQ3DVOhC8vbULTFAetttLXZPZczh6"

let NotifyURL = ServerURL + "notify_url.ashx" // 支付异步回调页面