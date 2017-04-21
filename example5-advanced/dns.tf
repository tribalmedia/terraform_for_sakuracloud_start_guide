#--------------------------------------
# (付録)DNSサーバの定義
#--------------------------------------

# 新たにゾーンを登録する場合
# 注: ゾーン登録後にネームサーバの設定が必要です。
# 詳しくは以下を参照してください。
# https://www.slideshare.net/sakura_pr/sakuracloud-dns/14
#resource sakuracloud_dns "dns" {
#    zone = "example.com"
#}

# すでにゾーン登録済みの場合はデータソースで参照する
#data sakuracloud_dns "dns" {
#    filter = {
#        name = "Name"
#        values = ["example.com"]
#    }
#}

# レコードの登録
#resource "sakuracloud_dns_record" "gslb_cname" {
#    # 新たにゾーンを登録した場合
#    #dns_id = "${sakuracloud_dns.dns.id}" 
#    # 登録済みゾーンをデータソースで参照する場合
#    dns_id = "${data.sakuracloud_dns.dns.id}"
#
#    name = "target-host-name" # ロードバランス対象のホスト名
#    type = "CNAME"
#    value = "${sakuracloud_gslb.gslb.FQDN}." # GSLBで発行されたFQDNを指定(末尾のピリオドに注意)
#}
