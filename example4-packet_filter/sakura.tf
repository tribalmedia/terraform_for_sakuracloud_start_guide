# データソース(アーカイブ)
data sakuracloud_archive "centos" {
    os_type="centos"
}

# ディスク
resource "sakuracloud_disk" "disk01"{
    # ディスク名
    name = "disk01"
    # コピー元アーカイブ(CentOS7を利用)
    source_archive_id = "${data.sakuracloud_archive.centos.id}"
    # パスワード
    password = "YOUR_PASSWORD_HERE"
}

# サーバー
resource "sakuracloud_server" "server01" {
    # サーバー名
    name = "server01"
    # 接続するディスク
    disks = ["${sakuracloud_disk.disk01.id}"]
    # タグ(NICの準仮想化モード有効化)
    tags = ["@virtio-net-pci"]

    # パケットフィルタを接続
    packet_filter_ids = ["${sakuracloud_packet_filter.filter01.id}"]
}

# パケットフィルタ
resource "sakuracloud_packet_filter" "filter01" {
    name = "filter01"
    # icmpを許可
    expressions = {
        protocol = "icmp"
        allow = true
    }
    # SSH(tcp:22)を許可
    expressions = {
        protocol = "tcp"
        dest_port = "22"
        allow = true
    }
    # 以外の全通信を拒否
    expressions = {
        protocol = "ip"
        allow = false
    }
}
