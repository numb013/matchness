//
//  AIConfig.swift
//  Aniimg
//
//  Created by k1e091 on 2017/12/07.
//  Copyright © 2017年 aniimg. All rights reserved.
//
/*
 
 */
public struct ApiConfig {
    
    /*
     //https://dev-yoru.purelovers.com/api/app/?mode=mapmenucategorysub
     let SITE_DOMAIN: String = "dev-yoru.purelovers.com";
     let SITE_BASE_URL: String = "https://" + SITE_DOMAIN;
     let SITE_URL_TEST_IMAGE: String = SITE_BASE_URL + "/test/img";
     let SITE_URL_API: String = SITE_BASE_URL + "/api/app";
     let SITE_URL_API_JSON: String = SITE_URL_API + "/?mode=mapmenucategorysub";
     let SITE_BASIC_AUTHENTICATION_ACCOUNT_ID: String = "k11025";
     let SITE_BASIC_AUTHENTICATION_ACCOUNT_PASSWORD: String = "52011k";
     */
    #if DEBUG
    static var SITE_DOMAIN: String = "fef254fe.ngrok.io";
    #else
    static var SITE_DOMAIN: String = "fef254fe.ngrok.io";
    #endif
    
    //
    static let SITE_BASE_URL: String = "http://" + SITE_DOMAIN;
    static let REQUEST_URL_API: String = SITE_BASE_URL + "/api";
    
    //ユーザー一覧
    static let REQUEST_URL_API_USER_SEARCH: String = REQUEST_URL_API + "/user/search";
    //ユーザー詳細
    static let REQUEST_URL_API_USER_DETAIL: String = REQUEST_URL_API + "/user/detail";
    //ユーザー作成
    static let REQUEST_URL_API_USER_ADD: String = REQUEST_URL_API + "/user/add";
    //プロフィール編集
    static let REQUEST_URL_API_USER_PROFILE_EDIT: String = REQUEST_URL_API + "/user/profile_edit";
    //マイデータ
    static let REQUEST_URL_API_ME: String = REQUEST_URL_API + "/me";
    //足跡
    static let REQUEST_URL_API_USER_FOOTPRINT: String = REQUEST_URL_API + "/footprint/user_footprint";
    //自分の足跡
    static let REQUEST_URL_API_MY_FOOTPRINT: String = REQUEST_URL_API + "/footprint/my_footprint";

    //いいね
    static let REQUEST_URL_API_ADD_LIKE: String = REQUEST_URL_API + "/like/add_like";

    //グループ取得
    static let REQUEST_URL_API_GET_GROUP: String = REQUEST_URL_API + "/get_group";
    static let REQUEST_URL_API_ADD_GROUP: String = REQUEST_URL_API + "/add_group";
    static let REQUEST_URL_API_GET_JOIN_AND_END_GROUP: String = REQUEST_URL_API + "/select_join_and_end_group";
    
    static let REQUEST_URL_API_SELECT_GROUP_EVENT: String = REQUEST_URL_API + "/select_group_event";

    static let REQUEST_URL_API_SELECT_REQUEST_GROUP_EVENT: String = REQUEST_URL_API + "/select_request_group_event";
    static let REQUEST_URL_API_REQUEST_GROUP_EVENT: String = REQUEST_URL_API + "/request_group_event";

    static let REQUEST_URL_API_DELETE_POINT: String = REQUEST_URL_API + "/delete_point";
    static let REQUEST_URL_API_UPDATE_POINT: String = REQUEST_URL_API + "/update_point";
    static let REQUEST_URL_API_ADD_POINT: String = REQUEST_URL_API + "/add_point";
    static let REQUEST_URL_API_SELECT_POINT: String = REQUEST_URL_API + "/select_point";

    static let REQUEST_URL_API_ADD_MESSAGE: String = REQUEST_URL_API + "/create_message";
    static let REQUEST_URL_API_SELECT_MESSAGE: String = REQUEST_URL_API + "/search_message";

    static let REQUEST_URL_API_SELECT_MATCHE: String = REQUEST_URL_API + "/search_matche";

    

    static let WORK_LIST: [String] = ["未選択", "クリエイティブ", "コンピューター","出版", "放送", "流通", "金融", "医療・福祉", "教育・語学", "国家・自治体", "旅行関係", "料理関係", "動物・自然", "オフィス", "サービス", "エンターテイメント", "美容・ファッション", "建築・インテリア", "モノづくり", "交通機関", "冠婚葬祭", "自由業", "学生"]

    static let PREFECTURE_LIST: [String] = ["未選択", "北海道","青森","岩手","秋田","宮城","山形","福島","新潟","茨城","栃木","群馬","埼玉","千葉","東京","神奈川","長野","山梨","静岡","岐阜","愛知","富山","石川","福井","滋賀","三重","京都","奈良","和歌山","大阪","兵庫","岡山","鳥取","島根","広島","山口","香川","愛媛","徳島","高知","福岡","佐賀","大分","長崎","熊本","宮崎","鹿児島","沖縄","海外"]
    static let FITNESS_LIST: [String] = ["未選択", "顔・フェイス","あご・首","胸・バスト","手首・足首","腕・二の腕","お腹・下腹","お尻・ヒップ","肩・背中","太もも・ふくらはぎ"]
    static let WEIGHT_LIST: [String] = ["未選択", "10kg", "15kg", "20kg", "25kg", "30kg", "35kg", "40kg", "45kg", "50kg", "55kg", "60kg", "65kg", "70kg", "75kg", "80kg", "85kg"]
    static let SEX_LIST: [String] = ["未選択", "女性", "男性", "ジェンダレス"]
    static let BLOOD_LIST: [String] = ["未選択", "A型","B型","O型","AB型"]
    
    static let EVENT_PEPLE_LIST: [String] = ["未選択", "4","5","6","7"," 8"]
    static let EVENT_START_TYPE: [String] = ["未選択", "集まり次第","主催者決定"]
    static let EVENT_TYPE_LIST: [String] = ["未選択", "半々","男性のみ","女性のみ"]
    static let EVENT_PRESENT_POINT: [String] = ["100","200","300","400","500","600","700","800","900","1000"]
    static let EVENT_PERIOD_LIST: [String] = ["未選択", "2","3","4","5","6","7", "14"]
    //
    init(){
        
    }
    
}

