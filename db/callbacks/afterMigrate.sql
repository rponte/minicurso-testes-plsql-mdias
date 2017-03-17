/**
 * Recompila packages com problemas
 */
declare 
  CURSOR l_cPackages_invalidas IS
  SELECT 'alter package ' || o.OWNER || '.' || o.OBJECT_NAME || ' compile' comando
    FROM all_objects o
   WHERE o.status = 'INVALID'
     AND o.OBJECT_TYPE = 'PACKAGE BODY';
  l_nCont_atual    NUMBER := 1;
  l_nCont_anterior NUMBER := 0;
BEGIN
  WHILE (l_nCont_atual > 0) LOOP
    FOR l_rPackages_invalidas IN l_cPackages_invalidas LOOP
      BEGIN
        EXECUTE IMMEDIATE l_rPackages_invalidas.comando;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      dbms_output.put_line(l_rPackages_invalidas.comando);
    END LOOP;
    SELECT COUNT(*)
      INTO l_nCont_atual
      FROM all_objects o
     WHERE o.status = 'INVALID'
       AND o.OBJECT_TYPE = 'PACKAGE BODY';
    IF l_nCont_anterior != l_nCont_atual THEN
      l_nCont_anterior := l_nCont_atual;
    ELSE
      EXIT;
    END IF;
  END LOOP;
  dbms_output.put_line('Ainda restaram ' || l_nCont_atual || ' packages inválidas!!!');
end;