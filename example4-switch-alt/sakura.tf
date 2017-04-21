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

    # 最初のNICはインターネットへ接続
    # (デフォルトでインターネット接続されるため、省略可能)
    base_interface = "shared"

    # 2番目以降のNICは接続するスイッチのIDをリストで設定することで作成される
    additional_interfaces = ["${sakuracloud_switch.sw01.id}"]

}

# スイッチ
resource "sakuracloud_switch" "sw01" {
    name = "sw01"
}
