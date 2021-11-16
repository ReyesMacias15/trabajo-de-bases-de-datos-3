CREATE or replace FUNCTION public."buscar_alumno"( nombre_provincia text)  RETURNS TABLE( nombre text, ciudad VARCHAR, provincia varchar)
 
AS
 
$$
declare
	registro record;
  
begin
FOR registro IN
SELECT 
estudiante.apellidos  || ' ' || 
  estudiante.nombres as nombres,
  ciudad.nombre_ciudad,
  provincia.nombre_provincia
FROM 
  public.estudiante
  inner join ciudad on  estudiante.code_ciudad = ciudad.code_ciudad 
  inner join provincia on ciudad.code_provincia = provincia.code_provincia 
WHERE 
  provincia.nombre_provincia =$1 loop
  nombre := registro.nombres;
        ciudad   := registro.nombre_ciudad;
        provincia   := registro.nombre_provincia;
        
    RETURN NEXT;
    END LOOP;
    RETURN;	
  end;$$
 
LANGUAGE plpgsql 











select*from buscar_alumno('Guayas')