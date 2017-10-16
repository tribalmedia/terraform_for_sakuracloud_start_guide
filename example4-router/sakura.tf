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

    # スイッチを接続
    nic = "${sakuracloud_internet.router01.switch_id}"

    # eth0のIPアドレス/ネットマスク設定
    ipaddress = "${sakuracloud_internet.router01.ipaddresses[count.index]}"
    nw_mask_len = "${sakuracloud_internet.router01.nw_mask_len}"
    # ゲートウェイ(ルーターに割り当てられた値を利用する)
    gateway = "${sakuracloud_internet.router01.gateway}"
}

# ルーター
resource "sakuracloud_internet" "router01" {
    name = "router01"
    # 割り当てるグローバルIPのネットマスク、デフォルト/28
    # nw_mask_len = 28
    # 帯域幅、デフォルト100(Mbps)
    # band_width = 100
}
