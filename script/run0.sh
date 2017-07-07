cd ./config
erl -smp true -nostick -name c0@127.0.0.1 -setcookie cs -boot start_sasl -config gs  -pa ../ebin  -pz /root/erl_rebin -s gs1 start -extra 127.0.0.1 5200 10
