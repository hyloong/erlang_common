cd ./config
erl -smp true -nostick -name c0@127.0.0.1 -setcookie cs -boot start_sasl -config gs  -pa ../ebin  -pz /root/erl_rebin -s gs start -extra 5200
