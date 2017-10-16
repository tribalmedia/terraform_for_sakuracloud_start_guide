resource "sakuracloud_ssh_key" "key"{
    name = "sshkey"
    public_key = "${file("id_rsa.pub")}"
}

# ディスク
resource "sakuracloud_disk" "disk01"{
    # ディスク名
    name = "disk01"
    # コピー元アーカイブ(CentOS 7.3 64bitを利用)
    source_archive_id = "112900062806" //tk1a(東京第1ゾーン)
    # パスワード
    password = "YOUR_PASSWORD_HERE"
    # 以下を追記する
    ssh_key_ids = ["${sakuracloud_ssh_key.key.id}"]
    # パスワード/チャレンジレスポンスでのSSHログイン禁止
    disable_pw_auth = true
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
    value = "ssh -i id_rsa root@${sakuracloud_server.server01.ipaddress}"
}
