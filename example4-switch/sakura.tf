variable "private_ip_addresses" {
    default = ["192.168.2.11" , "192.168.2.12"]
}

# データソース(アーカイブ)
data sakuracloud_archive "centos" {
    os_type="centos"
}

# ディスク
resource "sakuracloud_disk" "disks"{
    # 2台分
    count = 2
    # ディスク名
    name = "disk${count.index}"
    # コピー元アーカイブ(CentOS7を利用)
    source_archive_id = "${data.sakuracloud_archive.centos.id}"
    # パスワード
    password = "YOUR_PASSWORD_HERE"
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
    base_interface = "${sakuracloud_switch.sw01.id}"

    # eth0のIPアドレス/ネットマスク設定
    base_nw_ipaddress = "${var.private_ip_addresses[count.index]}"
    base_nw_mask_len = 24

    # デフォルトゲートウェイを設定する場合
    # base_nw_gateway = 192.168.2.1
}

# スイッチ
resource "sakuracloud_switch" "sw01" {
    name = "sw01"
}
