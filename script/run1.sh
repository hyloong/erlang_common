cd ./config
erl -name c1@127.0.0.1 -setcookie cs  -config common -pa ../ebin -s common start -extra 5201
