/**
 * Permissoes para conectar no schema
 */
GRANT CREATE SESSION TO ${defaultSchema} WITH ADMIN OPTION;
GRANT ALL PRIVILEGES TO ${defaultSchema};
GRANT DBA TO ${defaultSchema};
GRANT SELECT ON sys.V_$SESSION TO ${defaultSchema};

/**
 * Habilita semantica de tamanho para caracteres UTF-8
 * Resumindo: 1 char = 4 bytes
 */
ALTER session SET nls_length_semantics=CHAR;

/**
 * Habilita EBR (Edition-Based Redefinition) para usuario
 */
ALTER USER ${defaultSchema} ENABLE EDITIONS;