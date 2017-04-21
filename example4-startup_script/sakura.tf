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

    # スタートアップスクリプトの登録
    note_ids = ["${sakuracloud_note.install_httpd.id}"]
}

# サーバー
resource "sakuracloud_server" "server01" {
    # サーバー名
    name = "server01"
    # 接続するディスク
    disks = ["${sakuracloud_disk.disk01.id}"]
    # タグ(NICの準仮想化モード有効化)
    tags = ["@virtio-net-pci"]
}

# スタートアップスクリプト
resource "sakuracloud_note" "install_httpd" {
    name = "install_httpd"
    content = "${file("install_httpd.sh")}"
}
