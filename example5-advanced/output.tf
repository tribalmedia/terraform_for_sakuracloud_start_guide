#--------------------------------------
# アウトプットの定義
#--------------------------------------
# WebサーバへのSSH接続コマンド
output "ssh_to_web" {
    value = "${
        zipmap(
            sakuracloud_server.web_servers.*.name, 
            formatlist("ssh -i id_rsa root@%s", sakuracloud_server.web_servers.*.ipaddress)
        )
    }"
}

# DBサーバへのSSH接続コマンド(VPN接続必須)
output "ssh_to_db" {
    value = "${
        zipmap(
            sakuracloud_server.db_servers.*.name, 
            formatlist("ssh -i id_rsa root@%s", sakuracloud_server.db_servers.*.ipaddress)
        )
    }"
}

# GSLBのFQDN
# 本来はロードバランシングしたいホスト名のCNAMEレコードとしてDNSの登録するもの
output "gslb_fqdn" {
    value = "${sakuracloud_gslb.gslb.FQDN}"
}