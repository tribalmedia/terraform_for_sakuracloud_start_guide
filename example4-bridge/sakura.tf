variable "private_ip_addresses" {
    default = ["192.168.2.11" , "192.168.2.12"]
}
variable "target_zones" {
    default = ["is1b" , "tk1a"]
}

# データソース(アーカイブ)
data sakuracloud_archive "centos" {
    count = 2
    os_type="centos"
    zone = "${var.target_zones[count.index]}"
}

# ディスク
resource "sakuracloud_disk" "disks"{
    # 2台分
    count = 2
    # ディスク名
    name = "disk${count.index}"
    # コピー元アーカイブ(CentOS7を利用)
    source_archive_id = "${data.sakuracloud_archive.centos.*.id[count.index]}"
    # パスワード
    password = "YOUR_PASSWORD_HERE"
    # ゾーン
    zone = "${var.target_zones[count.index]}"
}

# サーバー
resource "sakuracloud_server" "servers" {
    # 2台分
    count = 2
    # サーバー名
    name = "server${count.index}"
    # 接続するディスク
    disks = ["${sakuracloud_disk.disks.*.id[count.index]}"]
    # タグ(NICの準仮想化モード有効化)
    tags = ["@virtio-net-pci"]

    # スイッチを接続
    base_interface = "${sakuracloud_switch.sw.*.id[count.index]}"

    # eth0のIPアドレス/ネットマスク設定
    base_nw_ipaddress = "${var.private_ip_addresses[count.index]}"
    base_nw_mask_len = 24

    # ゾーン
    zone = "${var.target_zones[count.index]}"
}

# スイッチ
resource "sakuracloud_switch" "sw" {
    count = 2
    name = "sw${count.index}"
    # ゾーン
    zone = "${var.target_zones[count.index]}"
    # ブリッジとの接続
    bridge_id = "${sakuracloud_bridge.bridge.id}"
}

# ブリッジ
resource "sakuracloud_bridge" "bridge" {
    name = "bridge"
}
