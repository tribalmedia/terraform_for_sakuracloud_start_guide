# データソース(アーカイブ)
data sakuracloud_archive "centos" {
    os_type="centos"
}

# ディスク
resource "sakuracloud_disk" "disk"{
    # ディスク名
    name = "disk"
    # コピー元アーカイブ(CentOS7を利用)
    source_archive_id = "${data.sakuracloud_archive.centos.id}"
    # パスワード
    password = "YOUR_PASSWORD_HERE"
}

# サーバー
resource "sakuracloud_server" "server" {
    # サーバー名
    name = "server"
    # 接続するディスク
    disks = ["${sakuracloud_disk.disk.id}"]
    # タグ(NICの準仮想化モード有効化)
    tags = ["@virtio-net-pci"]
}

# シンプル監視
resource "sakuracloud_simple_monitor" "monitor" {
    # 監視対象IPアドレス
    target = "${sakuracloud_server.server.base_nw_ipaddress}"

    health_check = {
        protocol = "ping"
    }
}
