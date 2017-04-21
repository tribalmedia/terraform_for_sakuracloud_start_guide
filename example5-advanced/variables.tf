#--------------------------------------
# 変数定義
#--------------------------------------

# Webサーバ 管理者パスワード
variable web_server_password {}
# Webサーバ定義
variable web_servers { type = "list" }

# DBサーバ 管理者パスワード
variable db_server_password {}
# DBサーバ定義
variable db_servers { type = "list" }

# VPCルータ リモートアクセス ユーザー名
variable vpn_username {}
# VPCルータ リモートアクセス パスワード
variable vpn_password {}
# VPCルータ 事前共有鍵
variable vpc_pre_shared_secret {}
# VPCルータ 配置ゾーン
variable vpc_zone { }

# スイッチを配置するゾーン
variable switch_zones { type = "list" }
