#--------------------------------------
# VPCルータの定義
#--------------------------------------
# VPCルータ本体
resource "sakuracloud_vpc_router" "vpc" {
    name = "vpc_router"
    zone = "${var.vpc_zone}"
}

# インターフェースの定義
resource "sakuracloud_vpc_router_interface" "eth1"{
    vpc_router_id = "${sakuracloud_vpc_router.vpc.id}"
    index = 1                                       # NICのインデックス(1〜7)
    switch_id = "${
        lookup(
            zipmap(
                var.switch_zones,
                sakuracloud_switch.switch.*.id
            ),
            var.vpc_zone
        )
    }"                                              # スイッチのID
    ipaddress = ["192.168.0.254"]                   # 実IPリスト
    nw_mask_len = 24                                # ネットマスク長
}

# リモートアクセス:L2TP/IPSec
resource "sakuracloud_vpc_router_l2tp" "l2tp" {
    vpc_router_id = "${sakuracloud_vpc_router.vpc.id}"
    vpc_router_interface_id = "${sakuracloud_vpc_router_interface.eth1.id}"

    pre_shared_secret = "${var.vpc_pre_shared_secret}" # 事前共有シークレット
    range_start = "192.168.0.11"                 # IPアドレス動的割り当て範囲(開始)
    range_stop = "192.168.0.20"                  # IPアドレス動的割り当て範囲(終了)
}

# リモートユーザアカウント
resource "sakuracloud_vpc_router_user" "user1" {
    vpc_router_id = "${sakuracloud_vpc_router.vpc.id}"

    name = "${var.vpn_username}"     # ユーザ名
    password = "${var.vpn_password}" # パスワード
}