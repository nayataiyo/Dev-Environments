<?php
// Zabbix database settings
$DB['TYPE']     = 'MYSQL';
$DB['SERVER']   = 'localhost';
$DB['PORT']     = '0';
$DB['DATABASE'] = 'zabbix5';  // ここをZabbixのデータベース名に変更
$DB['USER']     = '{{ user_vars }}';      // ここをZabbixのデータベースユーザー名に変更
$DB['PASSWORD'] = '{{ user_password }}';    // ここをZabbixのデータベースパスワードに変更
?>
