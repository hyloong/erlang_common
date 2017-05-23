{module, test_unit}.  %% version = 0

{exports, [{busy,0},
           {do_t1,0},
           {do_t2,0},
           {fib,1},
           {module_info,0},
           {module_info,1},
           {param_default,1},
           {param_default1,1},
           {send_msg,2},
           {t1,0},
           {t2,0}]}.

{attributes, []}.

{labels, 39}.


{function, t1, 0, 2}.
  {label,1}.
    {line,[{location,"test_unit.erl",12}]}.
    {func_info,{atom,test_unit},{atom,t1},0}.
  {label,2}.
    {allocate,0,0}.
    {make_fun2,{f,38},0,0,0}.
    {line,[{location,"test_unit.erl",13}]}.
    {call_ext,1,{extfunc,erlang,spawn,1}}.
    {move,{integer,100000},{x,1}}.
    {call_last,2,{f,6},0}.


{function, t2, 0, 4}.
  {label,3}.
    {line,[{location,"test_unit.erl",16}]}.
    {func_info,{atom,test_unit},{atom,t2},0}.
  {label,4}.
    {allocate,0,0}.
    {make_fun2,{f,36},0,0,0}.
    {line,[{location,"test_unit.erl",17}]}.
    {call_ext,1,{extfunc,erlang,spawn,1}}.
    {move,{integer,100000},{x,1}}.
    {call_last,2,{f,6},0}.


{function, send_msg, 2, 6}.
  {label,5}.
    {line,[{location,"test_unit.erl",20}]}.
    {func_info,{atom,test_unit},{atom,send_msg},2}.
  {label,6}.
    {test,is_eq_exact,{f,7},[{x,1},{integer,0}]}.
    {move,{atom,ok},{x,0}}.
    return.
  {label,7}.
    {allocate_zero,2,2}.
    {line,[{location,"test_unit.erl",23}]}.
    {bs_add,{f,0},[{integer,0},{x,1},1],{x,2}}.
    {bs_init_bits,{f,0},{x,2},0,2,{field_flags,[]},{x,2}}.
    {bs_put_integer,{f,0},{x,1},1,{field_flags,[unsigned,big]},{integer,2}}.
    {move,{x,1},{y,0}}.
    {move,{x,2},{x,1}}.
    {move,{x,0},{y,1}}.
    {line,[{location,"test_unit.erl",23}]}.
    send.
    {move,{integer,200},{x,0}}.
    {line,[{location,"test_unit.erl",24}]}.
    {call_ext,1,{extfunc,timer,sleep,1}}.
    {line,[{location,"test_unit.erl",25}]}.
    {gc_bif,'-',{f,0},0,[{y,0},{integer,1}],{x,1}}.
    {move,{y,1},{x,0}}.
    {call_last,2,{f,6},2}.


{function, do_t1, 0, 9}.
  {label,8}.
    {line,[{location,"test_unit.erl",27}]}.
    {func_info,{atom,test_unit},{atom,do_t1},0}.
  {label,9}.
    {allocate_zero,1,0}.
    {bif,self,{f,0},[],{x,0}}.
    {line,[{location,"test_unit.erl",28}]}.
    {call_ext,1,{extfunc,erlang,garbage_collect,1}}.
    {bif,self,{f,0},[],{x,0}}.
    {move,{literal,[memory,garbage_collection]},{x,1}}.
    {line,[{location,"test_unit.erl",29}]}.
    {call_ext,2,{extfunc,erlang,process_info,2}}.
    {test_heap,2,1}.
    {put_list,{x,0},nil,{x,1}}.
    {move,{literal,"~w~n"},{x,0}}.
    {line,[{location,"test_unit.erl",30}]}.
    {call_ext,2,{extfunc,io,format,2}}.
    {bif,self,{f,0},[],{x,0}}.
    {move,{atom,backtrace},{x,1}}.
    {line,[{location,"test_unit.erl",31}]}.
    {call_ext,2,{extfunc,erlang,process_display,2}}.
    {test_heap,2,1}.
    {put_list,{x,0},nil,{x,1}}.
    {move,{literal,"backtrace:~w~n~n"},{x,0}}.
    {line,[{location,"test_unit.erl",31}]}.
    {call_ext,2,{extfunc,io,format,2}}.
    {'try',{y,0},{f,13}}.
    {line,[{location,"test_unit.erl",33}]}.
  {label,10}.
    {loop_rec,{f,11},{x,0}}.
    remove_message.
    {line,[{location,"test_unit.erl",35}]}.
    {call,0,{f,9}}.
    {jump,{f,12}}.
  {label,11}.
    {wait,{f,10}}.
  {label,12}.
    {try_end,{y,0}}.
    {deallocate,1}.
    return.
  {label,13}.
    {try_case,{y,0}}.
    {call_last,0,{f,9},1}.


{function, do_t2, 0, 15}.
  {label,14}.
    {line,[{location,"test_unit.erl",42}]}.
    {func_info,{atom,test_unit},{atom,do_t2},0}.
  {label,15}.
    {allocate,0,0}.
    {bif,self,{f,0},[],{x,0}}.
    {line,[{location,"test_unit.erl",43}]}.
    {call_ext,1,{extfunc,erlang,garbage_collect,1}}.
    {bif,self,{f,0},[],{x,0}}.
    {move,{literal,[memory,garbage_collection]},{x,1}}.
    {line,[{location,"test_unit.erl",44}]}.
    {call_ext,2,{extfunc,erlang,process_info,2}}.
    {test_heap,2,1}.
    {put_list,{x,0},nil,{x,1}}.
    {move,{literal,"~w~n"},{x,0}}.
    {line,[{location,"test_unit.erl",45}]}.
    {call_ext,2,{extfunc,io,format,2}}.
    {bif,self,{f,0},[],{x,0}}.
    {move,{atom,backtrace},{x,1}}.
    {line,[{location,"test_unit.erl",46}]}.
    {call_ext,2,{extfunc,erlang,process_display,2}}.
    {test_heap,2,1}.
    {put_list,{x,0},nil,{x,1}}.
    {move,{literal,"backtrace:~w~n~n"},{x,0}}.
    {line,[{location,"test_unit.erl",46}]}.
    {call_ext,2,{extfunc,io,format,2}}.
    {line,[{location,"test_unit.erl",47}]}.
  {label,16}.
    {loop_rec,{f,17},{x,0}}.
    remove_message.
    {call_last,0,{f,15},0}.
  {label,17}.
    {wait,{f,16}}.


{function, fib, 1, 19}.
  {label,18}.
    {line,[{location,"test_unit.erl",57}]}.
    {func_info,{atom,test_unit},{atom,fib},1}.
  {label,19}.
    {test,is_integer,{f,21},[{x,0}]}.
    {select_val,{x,0},{f,21},{list,[{integer,1},{f,20},{integer,0},{f,20}]}}.
  {label,20}.
    {move,{integer,1},{x,0}}.
    return.
  {label,21}.
    {allocate_zero,1,1}.
    {line,[{location,"test_unit.erl",59}]}.
    {gc_bif,'-',{f,0},1,[{x,0},{integer,1}],{x,1}}.
    {move,{x,0},{y,0}}.
    {move,{x,1},{x,0}}.
    {line,[{location,"test_unit.erl",59}]}.
    {call,1,{f,19}}.
    {line,[{location,"test_unit.erl",59}]}.
    {gc_bif,'-',{f,0},1,[{y,0},{integer,2}],{x,1}}.
    {move,{x,0},{y,0}}.
    {move,{x,1},{x,0}}.
    {line,[{location,"test_unit.erl",59}]}.
    {call,1,{f,19}}.
    {line,[{location,"test_unit.erl",59}]}.
    {gc_bif,'+',{f,0},1,[{y,0},{x,0}],{x,0}}.
    {deallocate,1}.
    return.


{function, busy, 0, 23}.
  {label,22}.
    {line,[{location,"test_unit.erl",60}]}.
    {func_info,{atom,test_unit},{atom,busy},0}.
  {label,23}.
    {allocate,0,0}.
    {move,{integer,10},{x,0}}.
    {line,[{location,"test_unit.erl",60}]}.
    {call,1,{f,19}}.
    {call_last,0,{f,23},0}.


{function, param_default, 1, 25}.
  {label,24}.
    {line,[{location,"test_unit.erl",64}]}.
    {func_info,{atom,test_unit},{atom,param_default},1}.
  {label,25}.
    {test,is_eq,{f,26},[{x,0},{integer,1}]}.
    {move,{integer,5},{x,0}}.
    return.
  {label,26}.
    {move,{integer,0},{x,0}}.
    return.


{function, param_default1, 1, 28}.
  {label,27}.
    {line,[{location,"test_unit.erl",72}]}.
    {func_info,{atom,test_unit},{atom,param_default1},1}.
  {label,28}.
    {test,is_eq,{f,29},[{x,0},{integer,1}]}.
    {move,{integer,5},{x,1}}.
    {jump,{f,30}}.
  {label,29}.
    {move,{integer,0},{x,1}}.
  {label,30}.
    {move,{x,1},{x,0}}.
    return.


{function, module_info, 0, 32}.
  {label,31}.
    {line,[]}.
    {func_info,{atom,test_unit},{atom,module_info},0}.
  {label,32}.
    {move,{atom,test_unit},{x,0}}.
    {line,[]}.
    {call_ext_only,1,{extfunc,erlang,get_module_info,1}}.


{function, module_info, 1, 34}.
  {label,33}.
    {line,[]}.
    {func_info,{atom,test_unit},{atom,module_info},1}.
  {label,34}.
    {move,{x,0},{x,1}}.
    {move,{atom,test_unit},{x,0}}.
    {line,[]}.
    {call_ext_only,2,{extfunc,erlang,get_module_info,2}}.


{function, '-t2/0-fun-0-', 0, 36}.
  {label,35}.
    {line,[{location,"test_unit.erl",17}]}.
    {func_info,{atom,test_unit},{atom,'-t2/0-fun-0-'},0}.
  {label,36}.
    {call_only,0,{f,15}}.


{function, '-t1/0-fun-0-', 0, 38}.
  {label,37}.
    {line,[{location,"test_unit.erl",13}]}.
    {func_info,{atom,test_unit},{atom,'-t1/0-fun-0-'},0}.
  {label,38}.
    {call_only,0,{f,9}}.
