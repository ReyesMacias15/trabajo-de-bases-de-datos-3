CREATE OR REPLACE FUNCTION public.matri()
  RETURNS trigger AS
$BODY$
DECLARE
periodo1 varchar;
 cantidad_va integer;
 cantidad_es numeric;
 cantidad_ant numeric;
 cantidad_borr numeric;


    BEGIN
	
  
 IF (TG_OP = 'INSERT') THEN

 SELECT 
  curso.code_periodo into periodo1
FROM 
  public.matricula, 
  public.curso
WHERE 
  curso.code_curso = new.code_curso;

  if(periodo1!=new.code_periodo)then
   RAISE exception '%',  'Periodo no valido';
  end if;
   SELECT 
	 count(*) into cantidad_va
	 FROM 
	  matricula
	  WHERE 
	  code_periodo = new.code_periodo AND
	  codigo_estudiante =new.codigo_estudiante;

   IF (cantidad_va >1) then
   RAISE exception '%',  'Estudiante ya registrado en ese periodo';
   END if;
SELECT 
  curso.numero_est into cantidad_es
FROM 
  public.curso, 
  public.matricula
WHERE 
  curso.code_curso = new.code_curso;

  UPDATE curso
SET numero_est= cantidad_es+1
WHERE  curso.code_curso = new.code_curso;
RETURN NEW;

  END IF;


IF (TG_OP = 'UPDATE') THEN
  IF (old.code_periodo != new.code_periodo)   then
SELECT 
	 count(*) into cantidad_va
	 FROM 
	  matricula
	  WHERE 
	  code_periodo = new.code_periodo AND
	  codigo_estudiante =old.codigo_estudiante;

   IF (cantidad_va >1) then
   RAISE exception '%',  ' Estudiante repetido, no se ingreso';
  END IF;

END IF;
     SELECT 
  curso.numero_est into cantidad_ant
FROM 
  public.curso, 
  public.matricula
WHERE 
  curso.code_curso =old.code_curso;
   UPDATE curso
SET numero_est= cantidad_ant-1
WHERE  curso.code_curso = old.code_curso;

SELECT 
  curso.numero_est into cantidad_es
FROM 
  public.curso, 
  public.matricula
WHERE 
  curso.code_curso = new.code_curso;

  UPDATE curso
SET numero_est= cantidad_es+1
WHERE  curso.code_curso = new.code_curso;
 return new; 
END IF;




 IF (TG_OP = 'DELETE') THEN

    SELECT 
  curso.numero_est into cantidad_borr
FROM 
  public.curso, 
  public.matricula
WHERE 
  curso.code_curso =old.code_curso;
   UPDATE curso
SET numero_est= cantidad_borr-1
WHERE  curso.code_curso = old.code_curso;
 RETURN old;
END IF;



end;
$BODY$
  LANGUAGE plpgsql;





Create  trigger matricula after delete or insert or update
on matricula
for each row execute  procedure matri();