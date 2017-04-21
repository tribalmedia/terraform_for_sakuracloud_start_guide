#--------------------------------------
# SSH公開鍵の定義
#--------------------------------------

resource "sakuracloud_ssh_key_gen" "key" {
    name = "example-key"
    # 生成した秘密鍵をローカルマシンに保存
    provisioner "local-exec" {
        command = "echo \"${self.private_key}\" > id_rsa; chmod 0600 id_rsa"
    }
}