var
  c:char;
  s:string;

begin
        assign(input,ParamStr(1)+'tex.txt');
        assign(output,ParamStr(1)+'tex_r.txt');
        reset(input);
        rewrite(output);

        readln(s);
        writeln(s);
        while(not eof)do begin
          read(c);
          if(not(c in (['a'..'z']+['A'..'Z'])))then
            write(c);
        end;

        close(input);
        close(output);
        erase(input);
        rename(output,ParamStr(1)+'tex.txt');
end.
