#--------------------------------------
# Webサーバの定義
#--------------------------------------

# OS(CentOS 7.3)
data sakuracloud_archive "web_os" {
    os_type = "centos"

    count = "${length(var.web_servers)}"
    zone = "${lookup(var.web_servers[count.index], "zone")}"
}

# ディスクの定義
resource sakuracloud_disk "web_disks" {
    name = "${lookup(var.web_servers[count.index], "name")}"
    source_archive_id = "${data.sakuracloud_archive.web_os.*.id[count.index]}"
    hostname = "${lookup(var.web_servers[count.index], "name")}"
    password = "${var.web_server_password}"
    # 生成した公開鍵のIDを指定
    ssh_key_ids = ["${sakuracloud_ssh_key_gen.key.id}"]
    # SSH接続時のパスワード/チャレンジレスポンス認証を無効化
    disable_pw_auth = true

    count = "${length(var.web_servers)}"
    zone = "${lookup(var.web_servers[count.index], "zone")}"
}

# サーバーの定義
resource sakuracloud_server "web_servers" {
    name = "${lookup(var.web_servers[count.index], "name")}"
    disks = ["${sakuracloud_disk.web_disks.*.id[count.index]}"]
    tags = ["@virtio-net-pci"]
    # 追加NIC(スイッチに接続)
    additional_nics = ["${
        lookup(
            zipmap(
                var.switch_zones,
                sakuracloud_switch.switch.*.id
            ),
            lookup(var.web_servers[count.index], "zone")
        )
    }"]

    # プロビジョニング
    connection {
       user = "root"
       host = "${self.ipaddress}"
       private_key = "${sakuracloud_ssh_key_gen.key.private_key}"
    }
    # プライベートIP設定
    provisioner "remote-exec" {
        inline = [ <<EOS
            nmcli connection add \
                  type ethernet \
                  con-name local-eth1 \
                  ifname eth1 \
                  ip4 ${lookup(var.web_servers[count.index], "private_ipaddr")}/${lookup(var.web_servers[count.index], "private_mask_len")} \
                  gw4 ${lookup(var.web_servers[count.index], "private_gateway")}
            nmcli connection up local-eth1
EOS
        ]
    }
    # 動作確認用にApache(httpd)インストール + ファイアウォール(tcp:80)開放
    provisioner "remote-exec" {
        inline = [ 
            "yum install -y httpd",
            "hostname >> /var/www/html/index.html",
            "systemctl enable httpd.service",
            "systemctl start httpd.service",
            "firewall-cmd --add-service=http --zone=public --permanent",
            "firewall-cmd --reload"
        ]
    }

    count = "${length(var.web_servers)}"
    zone = "${lookup(var.web_servers[count.index], "zone")}"
}
