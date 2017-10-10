#--------------------------------------
# DBサーバの定義
#--------------------------------------

# OS(CentOS 7.3)
data sakuracloud_archive "db_os" {
    os_type = "centos"

    count = "${length(var.db_servers)}"
    zone = "${lookup(var.db_servers[count.index], "zone")}"
}
# ディスクの定義
resource sakuracloud_disk "db_disks" {
    name = "${lookup(var.db_servers[count.index], "name")}"
    source_archive_id = "${data.sakuracloud_archive.db_os.*.id[count.index]}"
    hostname = "${lookup(var.db_servers[count.index], "name")}"
    password = "${var.web_server_password}"
    # 生成した公開鍵のIDを指定
    ssh_key_ids = ["${sakuracloud_ssh_key_gen.key.id}"]
    # SSH接続時のパスワード/チャレンジレスポンス認証を無効化
    disable_pw_auth = true

    # スタートアップスクリプト(DBセットアップ + master/slaveそれぞれ固有の処理)
    note_ids = [
        "${sakuracloud_note.setup_database.id}", #DBセットアップ
        "${lookup(var.db_servers[count.index], "is_master") ? sakuracloud_note.setup_master.id : sakuracloud_note.setup_slave.id }"
    ]

    count = "${length(var.db_servers)}"
    zone = "${lookup(var.db_servers[count.index], "zone")}"
}

# サーバーの定義
resource sakuracloud_server "db_servers" {
    name = "${lookup(var.db_servers[count.index], "name")}"
    disks = ["${sakuracloud_disk.db_disks.*.id[count.index]}"]
    tags = ["@virtio-net-pci"]
    nic = "${
        lookup(
            zipmap(
                var.switch_zones,
                sakuracloud_switch.switch.*.id
            ),
            lookup(var.db_servers[count.index], "zone")
        )
    }"
    ipaddress = "${lookup(var.db_servers[count.index], "ipaddr")}"
    gateway = "${lookup(var.db_servers[count.index], "gateway")}"
    nw_mask_len = "${lookup(var.db_servers[count.index], "mask_len")}"

    # 直接SSH接続できないため、プロビジョニングはスタートアップスクリプトで行う

    count = "${length(var.db_servers)}"
    zone = "${lookup(var.db_servers[count.index], "zone")}"
}


# スタートアップスクリプト(DBセットアップ:master/slave共通部分)
resource sakuracloud_note "setup_database" {
    name = "setup_database"
    content = <<EOS
#!/bin/bash

# @sacloud-once

# TODO:ここにデータベースのインストール処理などを記載する(今回は省略)
echo "setup_database done" || exit 1
exit 0
EOS
}

# スタートアップスクリプト(DBセットアップ:master側)
resource sakuracloud_note "setup_master" {
    name = "setup_master"
    content = <<EOS
#!/bin/bash

# @sacloud-once

# TODO:ここにレプリケーションのmasterのセットアップ処理などを記載する(今回は省略)
echo "setup_master done" || exit 1
exit 0
EOS
}

# スタートアップスクリプト(DBセットアップ:slave側)
resource sakuracloud_note "setup_slave" {
    name = "setup_slave"
    content = <<EOS
#!/bin/bash

# @sacloud-once

# TODO:ここにレプリケーションのslaveのセットアップ処理などを記載する(今回は省略)
echo "setup_slave done" || exit 1
exit 0
EOS
}