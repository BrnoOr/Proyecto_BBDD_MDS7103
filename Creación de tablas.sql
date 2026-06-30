CREATE SCHEMA IF NOT EXISTS educacion;

SET search_path TO educacion;

;
CREATE TABLE region (
    cod_reg_rbd INTEGER PRIMARY KEY,
    nom_reg_rbd VARCHAR(100)
);

CREATE TABLE provincia (
    cod_pro_rbd INTEGER PRIMARY KEY,
    r_cod_reg_rbd INTEGER NOT NULL,
    FOREIGN KEY (r_cod_reg_rbd)
        REFERENCES region(cod_reg_rbd)
);

CREATE TABLE comuna (
    cod_com_rbd INTEGER PRIMARY KEY,
    nom_com_rbd VARCHAR(150),
    p_cod_pro_rbd INTEGER NOT NULL,
    FOREIGN KEY (p_cod_pro_rbd)
        REFERENCES provincia(cod_pro_rbd)
);

CREATE TABLE sostenedor (
    rut VARCHAR(20) PRIMARY KEY,
    p_juridica VARCHAR(100)
);

CREATE TABLE departamento_provincial (
    cod_deprov_rbd INTEGER PRIMARY KEY,
    p_cod_pro_rbd INTEGER NOT NULL,
    nom_deprov_rbd VARCHAR(150),
    FOREIGN KEY (p_cod_pro_rbd)
        REFERENCES provincia(cod_pro_rbd)
);

CREATE TABLE especialidad (
    cod_espe INTEGER PRIMARY KEY,
    nombre_especialidad VARCHAR(200)
);

CREATE TABLE ensenanza (
    cod_ense INTEGER PRIMARY KEY,
    descripcion VARCHAR(250)
);

CREATE TABLE nivel_educativo (
    id_nivel INTEGER PRIMARY KEY,
    nombre_nivel VARCHAR(100)
);

CREATE TABLE establecimiento (

    rbd INTEGER PRIMARY KEY,
    c_cod_com_rbd INTEGER,
    dgv_rbd VARCHAR(5),
    nom_rbd VARCHAR(250),
    cod_depe INTEGER,
    cod_depe2 INTEGER,
    rural_rbd INTEGER,
    latitud NUMERIC(10,7),
    longitud NUMERIC(10,7),
    convenio_pie BOOLEAN,
    pace BOOLEAN,
    mat_total INTEGER,
    matricula INTEGER,
    estado_estab INTEGER,
    ori_religiosa VARCHAR(150),
    ori_otro_glosa TEXT,
    pago_matricula VARCHAR(100),
    pago_mensual VARCHAR(100),
    FOREIGN KEY (c_cod_com_rbd)
        REFERENCES comuna(cod_com_rbd)

);

CREATE TABLE establecimiento_ensenanza (
    e_rbd INTEGER,
    en_cod_ense INTEGER,
    PRIMARY KEY (e_rbd, en_cod_ense),
    FOREIGN KEY (e_rbd)
        REFERENCES establecimiento(rbd),
    FOREIGN KEY (en_cod_ense)
        REFERENCES ensenanza(cod_ense)
);

CREATE TABLE establecimiento_especialidad (
    e_rbd INTEGER,
    es_cod_espe INTEGER,
    PRIMARY KEY (e_rbd, es_cod_espe),
    FOREIGN KEY (e_rbd)
        REFERENCES establecimiento(rbd),
    FOREIGN KEY (es_cod_espe)
        REFERENCES especialidad(cod_espe)
);

CREATE TABLE establecimiento_nivel (
    e_rbd INTEGER,
    n_id_nivel INTEGER,
    cantidad_nivel INTEGER,
    PRIMARY KEY (e_rbd, n_id_nivel),
    FOREIGN KEY (e_rbd)
        REFERENCES establecimiento(rbd),
    FOREIGN KEY (n_id_nivel)
        REFERENCES nivel_educativo(id_nivel)
);

CREATE TABLE establecimiento_sostenedor (
    e_rbd INTEGER PRIMARY KEY,
    s_rut VARCHAR(20),
    FOREIGN KEY (e_rbd)
        REFERENCES establecimiento(rbd),
    FOREIGN KEY (s_rut)
        REFERENCES sostenedor(rut)
);