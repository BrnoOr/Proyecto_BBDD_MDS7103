--Pregunta 1
WITH establecimientos_tp AS (
    -- Establecimientos que imparten alguna modalidad TP (niveles 7 u 8)
    SELECT DISTINCT en.e_RBD
    FROM establecimiento_nivel en
    WHERE en.n_ID_NIVEL IN (7, 8)
    UNION  -- combinamos con la evidencia de la tabla ensenanza
    SELECT DISTINCT ee.e_RBD
    FROM establecimiento_ensenanza ee
    WHERE ee.en_COD_ENSE IN (410,460,461,463,  -- Comercial
                             510,560,561,563,  -- Industrial
                             610,660,661,663,  -- Técnica
                             710,760,761,763,  -- Agrícola
                             810,860,863)      -- Marítima
)
SELECT
    r.NOM_REG_RBD                                   AS region,
    COUNT(DISTINCT etp.e_RBD)                         AS n_estab_tp,
    SUM(COUNT(DISTINCT etp.e_RBD)) OVER ()            AS total_nacional_tp,
    ROUND(
        100.0 * COUNT(DISTINCT etp.e_RBD)
        / NULLIF(SUM(COUNT(DISTINCT etp.e_RBD)) OVER (), 0)
    , 2)                                              AS pct_del_total_tp,
    RANK() OVER (ORDER BY COUNT(DISTINCT etp.e_RBD) DESC) AS ranking
FROM region r
LEFT JOIN provincia p          ON p.r_COD_REG_RBD     = r.COD_REG_RBD
LEFT JOIN comuna c             ON c.p_COD_PRO_RBD     = p.COD_PRO_RBD
LEFT JOIN establecimiento e    ON e.c_COD_COM_RBD   = c.COD_COM_RBD
LEFT JOIN establecimientos_tp etp ON etp.e_RBD      = e.RBD
GROUP BY r.NOM_REG_RBD
ORDER BY n_estab_tp DESC



;
--Pregunta 2
SELECT
    c.nom_com_rbd,
    COUNT(*) AS estab_caros,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS ranking
FROM establecimiento e
JOIN comuna c     ON c.cod_com_rbd = e.c_cod_com_rbd
JOIN provincia p  ON p.cod_pro_rbd = c.p_cod_pro_rbd
JOIN region r     ON r.cod_reg_rbd = p.r_cod_reg_rbd
WHERE r.cod_reg_rbd = 13
  AND e.pago_mensual = 'MAS DE $100.000'
GROUP BY c.nom_com_rbd
ORDER BY estab_caros DESC

;
--Pregunta 3
WITH pago_ord AS (
    SELECT e.rbd, es.s_rut,
        CASE e.pago_mensual
            WHEN 'GRATUITO'          THEN 0
            WHEN '$1.000 A $10.000'  THEN 1
            WHEN '$10.001 A $25.000' THEN 2
            WHEN '$25.001 A $50.000' THEN 3
            WHEN '$50.001 A $100.000' THEN 4
            WHEN 'MAS DE $100.000'   THEN 5
            ELSE NULL
        END AS nivel_pago
    FROM establecimiento e
    JOIN establecimiento_sostenedor es ON es.e_rbd = e.rbd
),
sost AS (
    SELECT s_rut,
           COUNT(*) AS n_estab,
           AVG(nivel_pago) AS pago_promedio
    FROM pago_ord
    WHERE nivel_pago IS NOT NULL
    GROUP BY s_rut
)
SELECT
    CASE
        WHEN n_estab = 1            THEN '1'
        WHEN n_estab BETWEEN 2 AND 5  THEN '2-5'
        WHEN n_estab BETWEEN 6 AND 20 THEN '6-20'
        ELSE '20+'
    END AS tramo_concentracion,
    COUNT(*)                 AS n_sostenedores,
    ROUND(AVG(pago_promedio), 3) AS pago_ordinal_medio
FROM sost
GROUP BY 1
ORDER BY MIN(n_estab)
;
--Pregunta 4
SELECT
    COUNT(DISTINCT e.rbd)                                          AS n_estab_pace,
    SUM(en.cantidad_nivel) FILTER (WHERE en.n_id_nivel IN (5,6))   AS matricula_hc,
    SUM(en.cantidad_nivel) FILTER (WHERE en.n_id_nivel IN (7,8))   AS matricula_tp,
    ROUND(
        100.0 * SUM(en.cantidad_nivel) FILTER (WHERE en.n_id_nivel IN (5,6))
        / NULLIF(SUM(en.cantidad_nivel) FILTER (WHERE en.n_id_nivel IN (5,6,7,8)), 0)
    , 2)                                                           AS pct_hc,
    ROUND(
        100.0 * SUM(en.cantidad_nivel) FILTER (WHERE en.n_id_nivel IN (7,8))
        / NULLIF(SUM(en.cantidad_nivel) FILTER (WHERE en.n_id_nivel IN (5,6,7,8)), 0)
    , 2)                                                           AS pct_tp
FROM establecimiento e
JOIN establecimiento_nivel en ON en.e_rbd = e.rbd
WHERE e.pace = TRUE
  AND en.n_id_nivel IN (5,6,7,8)
  ;

--Pregunta 5

SELECT
    CASE WHEN e.rural_rbd = 1 THEN 'Rural' ELSE 'Urbano' END      AS ruralidad,
    COUNT(*) FILTER (WHERE e.ori_religiosa = '2')        AS n_catolica,
    COUNT(*) FILTER (WHERE e.ori_religiosa = '3')        AS n_evangelica,
    ROUND(
        1.0 * COUNT(*) FILTER (WHERE e.ori_religiosa = '3')
        / NULLIF(COUNT(*) FILTER (WHERE e.ori_religiosa = '2'), 0)
    , 3)                                                           AS ratio_evangelica_catolica,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE e.ori_religiosa = '3')
        / NULLIF(COUNT(*) FILTER (WHERE e.ori_religiosa = '3'
                                     OR e.ori_religiosa = '2'), 0)
    , 2)                                                           AS pct_evangelica_entre_religiosos
FROM establecimiento e
WHERE e.ori_religiosa IS NOT NULL
  AND (e.ori_religiosa = '3'
       OR e.ori_religiosa = '2')
GROUP BY CASE WHEN e.rural_rbd = 1 THEN 'Rural' ELSE 'Urbano' END
ORDER BY ruralidad

;
--Pregunta 6
WITH clasificacion AS (
    SELECT
        e.rbd,
        e.mat_total,
        (EXISTS (SELECT 1 FROM establecimiento_ensenanza ee
                 WHERE ee.e_rbd = e.rbd AND ee.en_cod_ense = 310)
         AND EXISTS (SELECT 1 FROM establecimiento_ensenanza ee
                 WHERE ee.e_rbd = e.rbd AND ee.en_cod_ense IN (360,361,362,363))
        ) AS dual_hc,
        (EXISTS (SELECT 1 FROM establecimiento_ensenanza ee
                 WHERE ee.e_rbd = e.rbd
                   AND ee.en_cod_ense IN (410,510,610,710,810,910))
         AND EXISTS (SELECT 1 FROM establecimiento_ensenanza ee
                 WHERE ee.e_rbd = e.rbd
                   AND ee.en_cod_ense IN (460,461,463,560,561,563,
                                          660,661,663,760,761,763,860,863))
        ) AS dual_tp
    FROM establecimiento e
),
grupos AS (
    SELECT
        rbd,
        mat_total,
        CASE WHEN dual_hc OR dual_tp
             THEN 'Ofrece misma área jóvenes+adultos'
             ELSE 'Solo una modalidad'
        END AS grupo
    FROM clasificacion
)
SELECT
    grupo,
    COUNT(*)                                               AS n_establecimientos,
    ROUND(AVG(mat_total), 1)                               AS matricula_total_promedio,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY mat_total) AS mediana_matricula,
    MIN(mat_total)                                         AS min_mat,
    MAX(mat_total)                                         AS max_mat
FROM grupos
WHERE mat_total IS NOT NULL
GROUP BY grupo
ORDER BY matricula_total_promedio DESC;