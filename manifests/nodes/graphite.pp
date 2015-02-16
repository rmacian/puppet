# install graphite from git 
node /graphite01.*/ {
    include basic
    include puppet::client
    include graphite::server_git
    include graphite::diamond
    #include zabbix::agent
    Class['puppet::client'] -> Class['basic'] -> Class['graphite::server_git'] 
}
