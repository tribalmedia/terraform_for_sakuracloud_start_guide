#--------------------------------------
# 変数への投入値
#--------------------------------------

# Webサーバ 管理者パスワード
web_server_password = "PUT_YOUR_PASSWORD_HERE"

# Webサーバの定義
web_servers = [ 
    {
        name = "web-is1b-01"
        zone = "is1b"
        private_ipaddr = "192.168.0.101"
        private_mask_len = 24
        private_gateway = "192.168.0.254"
    },
    {
        name = "web-is1b-02"
        zone = "is1b"
        private_ipaddr = "192.168.0.102"
        private_mask_len = 24
        private_gateway = "192.168.0.254"
    },
    {
        name = "web-tk1a-01"
        zone = "tk1a"
        private_ipaddr = "192.168.0.201"
        private_mask_len = 24
        private_gateway = "192.168.0.254"
    },
    {
        name = "web-tk1a-02"
        zone = "tk1a"
        private_ipaddr = "192.168.0.202"
        private_mask_len = 24
        private_gateway = "192.168.0.254"
    }
]

# DBサーバ 管理者パスワード
db_server_password = "PUT_YOUR_PASSWORD_HERE"

# DBサーバの定義
db_servers = [ 
    {
        name = "db01"
        zone = "is1b"
        ipaddr = "192.168.0.51"
        mask_len = 24
        gateway = "192.168.0.254"
        is_master = true # DBレプリケーション用
    },
    {
        name = "db02"
        zone = "tk1a"
        ipaddr = "192.168.0.52"
        mask_len = 24
        gateway = "192.168.0.254"
        is_master = false # DBレプリケーション用
    }
]

# VPCルータ リモートアクセス ユーザー名
vpn_username = "PUT_YOUR_USER_NAME"
# VPCルータ リモートアクセス パスワード
vpn_password = "PUT_YOUR_PW_HERE"
# VPCルータ 事前共有鍵
vpc_pre_shared_secret = "PUT_YOUR_SECRET_HERE"
# VPCルータ 配置ゾーン
vpc_zone = "is1b"

# スイッチを配置するゾーン
switch_zones = ["is1b", "tk1a"]
