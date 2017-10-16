# ディスク
resource "sakuracloud_disk" "disk01"{
    # ディスク名
    name = "disk01"
    # コピー元アーカイブ(CentOS 7.3 64bitを利用)
    source_archive_id = "112900062806" //tk1a(東京第1ゾーン)
    # パスワード
    password = "YOUR_PASSWORD_HERE"
}

# サーバー
resource "sakuracloud_server" "server01" {
    # サーバー名
    name = "server01"
    # 接続するディスク
    disks = ["${sakuracloud_disk.disk01.id}"]
}

# アウトプット(SSHコマンド)
output "ssh_command" {
    value = "ssh root@${sakuracloud_server.server01.ipaddress}"
}
