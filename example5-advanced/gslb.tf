#--------------------------------------
# GSLBの定義
#--------------------------------------

# GSLB本体の定義
resource "sakuracloud_gslb" "gslb" {
    name = "gslb"
    health_check = {
        protocol = "http"
        path = "/"
        status = "200"
    }
}

# GSLB配下のサーバ定義
resource "sakuracloud_gslb_server" "servers" {
    count = "${length(var.web_servers)}"
    gslb_id = "${sakuracloud_gslb.gslb.id}"
    ipaddress = "${sakuracloud_server.web_servers.*.ipaddress[count.index]}"
}