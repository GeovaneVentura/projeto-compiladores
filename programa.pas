program Somador;
var
    soma: integer;
    alvo: integer;
    contador: integer;
begin
    soma := 0;
    alvo := 10;
    contador := 1;

    while contador <= alvo do
    begin
        if contador > 5 then
            soma := soma + contador
        else
            soma := soma + 1;
            
        contador := contador + 1;
    end;
end.