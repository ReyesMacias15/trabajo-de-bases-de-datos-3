do $cursor$
declare
	registro Record;
	Cur_policia Cursor for 
	SELECT 
	  periodo.ano_periodo,
	  count(*) as cantidad
		FROM 
		  public.matricula
		  inner join periodo on  matricula.code_periodo = periodo.code_periodo
		  group by
		  periodo.ano_periodo;
begin
	Open Cur_policia;
	fetch Cur_policia into registro;
	while(FOUND) loop
	Raise Notice 'Periodo: %, Cantidad: %', registro.ano_periodo,registro.cantidad;
	fetch Cur_policia into registro;
	end loop;
end $cursor$
language 'plpgsql'