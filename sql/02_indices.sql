CREATE INDEX idx_estab_comuna     ON establecimiento (c_cod_com_rbd);
CREATE INDEX idx_estsost_rut      ON establecimiento_sostenedor (s_rut);
CREATE INDEX idx_estnivel_rbd_niv ON establecimiento_nivel (e_rbd, n_id_nivel);
CREATE INDEX idx_estense_rbd_ense ON establecimiento_ensenanza (e_rbd, en_cod_ense);
CREATE INDEX idx_comuna_provincia ON comuna (p_cod_pro_rbd);
CREATE INDEX idx_provincia_region ON provincia (r_cod_reg_rbd);