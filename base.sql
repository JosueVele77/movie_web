--
-- PostgreSQL database dump
--

-- Dumped from database version 16.0
-- Dumped by pg_dump version 16.0

-- Started on 2026-05-04 09:54:29

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 6 (class 2615 OID 16734)
-- Name: auditoria; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA auditoria;


ALTER SCHEMA auditoria OWNER TO postgres;

--
-- TOC entry 231 (class 1255 OID 16745)
-- Name: fn_log_audit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_log_audit() RETURNS trigger
    LANGUAGE plpgsql
AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO "auditoria".tb_auditoria ("tabla_aud", "operacion_aud", "valoranterior_aud", "valornuevo_aud", "fecha_aud", "usuario_aud")
        VALUES (TG_TABLE_NAME, 'D', OLD, NULL, now(), USER);
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO "auditoria".tb_auditoria ("tabla_aud", "operacion_aud", "valoranterior_aud", "valornuevo_aud", "fecha_aud", "usuario_aud")
        VALUES (TG_TABLE_NAME, 'U', OLD, NEW, now(), USER);
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO "auditoria".tb_auditoria ("tabla_aud", "operacion_aud", "valoranterior_aud", "valornuevo_aud", "fecha_aud", "usuario_aud")
        VALUES (TG_TABLE_NAME, 'I', NULL, NEW, now(), USER);
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION public.fn_log_audit() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 230 (class 1259 OID 16736)
-- Name: tb_auditoria; Type: TABLE; Schema: auditoria; Owner: postgres
--

CREATE TABLE auditoria.tb_auditoria (
                                        id_aud integer NOT NULL,
                                        tabla_aud text,
                                        operacion_aud text,
                                        valoranterior_aud text,
                                        valornuevo_aud text,
                                        fecha_aud date,
                                        usuario_aud text,
                                        esquema_aud text,
                                        activar_aud boolean,
                                        trigger_aud boolean
);


ALTER TABLE auditoria.tb_auditoria OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16735)
-- Name: tb_auditoria_id_aud_seq; Type: SEQUENCE; Schema: auditoria; Owner: postgres
--

CREATE SEQUENCE auditoria.tb_auditoria_id_aud_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auditoria.tb_auditoria_id_aud_seq OWNER TO postgres;

--
-- TOC entry 4910 (class 0 OID 0)
-- Dependencies: 229
-- Name: tb_auditoria_id_aud_seq; Type: SEQUENCE OWNED BY; Schema: auditoria; Owner: postgres
--

ALTER SEQUENCE auditoria.tb_auditoria_id_aud_seq OWNED BY auditoria.tb_auditoria.id_aud;


--
-- TOC entry 217 (class 1259 OID 16396)
-- Name: tb_categoria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tb_categoria (
                                     id_cat integer NOT NULL,
                                     descripcion_cat text
);


ALTER TABLE public.tb_categoria OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16395)
-- Name: tb_categoria_id_cat_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tb_categoria_id_cat_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tb_categoria_id_cat_seq OWNER TO postgres;

--
-- TOC entry 4911 (class 0 OID 0)
-- Dependencies: 216
-- Name: tb_categoria_id_cat_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tb_categoria_id_cat_seq OWNED BY public.tb_categoria.id_cat;


--
-- TOC entry 224 (class 1259 OID 16476)
-- Name: tb_estadocivil; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tb_estadocivil (
                                       id_est integer NOT NULL,
                                       descripcion_est text
);


ALTER TABLE public.tb_estadocivil OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16475)
-- Name: tb_estadocivil_id_est_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tb_estadocivil_id_est_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tb_estadocivil_id_est_seq OWNER TO postgres;

--
-- TOC entry 4912 (class 0 OID 0)
-- Dependencies: 223
-- Name: tb_estadocivil_id_est_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tb_estadocivil_id_est_seq OWNED BY public.tb_estadocivil.id_est;


--
-- TOC entry 220 (class 1259 OID 16419)
-- Name: tb_pagina; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tb_pagina (
                                  id_pag integer NOT NULL,
                                  descripcion_pag text,
                                  path_pag text
);


ALTER TABLE public.tb_pagina OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16427)
-- Name: tb_parametros; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tb_parametros (
                                      id_par integer NOT NULL,
                                      descripcion_par text,
                                      valor_par text
);


ALTER TABLE public.tb_parametros OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16432)
-- Name: tb_perfil; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tb_perfil (
                                  id_per integer NOT NULL,
                                  descripcion_per text
);


ALTER TABLE public.tb_perfil OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16538)
-- Name: tb_perfilpagina; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tb_perfilpagina (
                                        id_perpag integer NOT NULL,
                                        id_per integer,
                                        id_pag integer
);


ALTER TABLE public.tb_perfilpagina OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16537)
-- Name: tb_perfilpagina_id_perpag_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tb_perfilpagina_id_perpag_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tb_perfilpagina_id_perpag_seq OWNER TO postgres;

--
-- TOC entry 4913 (class 0 OID 0)
-- Dependencies: 227
-- Name: tb_perfilpagina_id_perpag_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tb_perfilpagina_id_perpag_seq OWNED BY public.tb_perfilpagina.id_perpag;


--
-- TOC entry 219 (class 1259 OID 16405)
-- Name: tb_producto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tb_producto (
                                    id_pr integer NOT NULL,
                                    id_cat integer,
                                    nombre_pr text,
                                    cantidad_pr integer,
                                    precio_pr double precision,
                                    foto_pr bytea
);


ALTER TABLE public.tb_producto OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16404)
-- Name: tb_producto_id_pr_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tb_producto_id_pr_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tb_producto_id_pr_seq OWNER TO postgres;

--
-- TOC entry 4914 (class 0 OID 0)
-- Dependencies: 218
-- Name: tb_producto_id_pr_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tb_producto_id_pr_seq OWNED BY public.tb_producto.id_pr;


--
-- TOC entry 226 (class 1259 OID 16485)
-- Name: tb_usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tb_usuario (
                                   id_us integer NOT NULL,
                                   id_per integer,
                                   id_est integer,
                                   nombre_us text,
                                   cedula_us text,
                                   correo_us text,
                                   clave_us text
);


ALTER TABLE public.tb_usuario OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16484)
-- Name: tb_usuario_id_us_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tb_usuario_id_us_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tb_usuario_id_us_seq OWNER TO postgres;

--
-- TOC entry 4915 (class 0 OID 0)
-- Dependencies: 225
-- Name: tb_usuario_id_us_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tb_usuario_id_us_seq OWNED BY public.tb_usuario.id_us;


--
-- TOC entry 4732 (class 2604 OID 16739)
-- Name: tb_auditoria id_aud; Type: DEFAULT; Schema: auditoria; Owner: postgres
--

ALTER TABLE ONLY auditoria.tb_auditoria ALTER COLUMN id_aud SET DEFAULT nextval('auditoria.tb_auditoria_id_aud_seq'::regclass);


--
-- TOC entry 4727 (class 2604 OID 16399)
-- Name: tb_categoria id_cat; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_categoria ALTER COLUMN id_cat SET DEFAULT nextval('public.tb_categoria_id_cat_seq'::regclass);


--
-- TOC entry 4729 (class 2604 OID 16479)
-- Name: tb_estadocivil id_est; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_estadocivil ALTER COLUMN id_est SET DEFAULT nextval('public.tb_estadocivil_id_est_seq'::regclass);


--
-- TOC entry 4731 (class 2604 OID 16541)
-- Name: tb_perfilpagina id_perpag; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_perfilpagina ALTER COLUMN id_perpag SET DEFAULT nextval('public.tb_perfilpagina_id_perpag_seq'::regclass);


--
-- TOC entry 4728 (class 2604 OID 16408)
-- Name: tb_producto id_pr; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_producto ALTER COLUMN id_pr SET DEFAULT nextval('public.tb_producto_id_pr_seq'::regclass);


--
-- TOC entry 4730 (class 2604 OID 16488)
-- Name: tb_usuario id_us; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_usuario ALTER COLUMN id_us SET DEFAULT nextval('public.tb_usuario_id_us_seq'::regclass);


--
-- TOC entry 4753 (class 2606 OID 16743)
-- Name: tb_auditoria pk_tb_auditoria; Type: CONSTRAINT; Schema: auditoria; Owner: postgres
--

ALTER TABLE ONLY auditoria.tb_auditoria
    ADD CONSTRAINT pk_tb_auditoria PRIMARY KEY (id_aud);


--
-- TOC entry 4734 (class 2606 OID 16403)
-- Name: tb_categoria id_cat; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_categoria
    ADD CONSTRAINT id_cat PRIMARY KEY (id_cat);


--
-- TOC entry 4747 (class 2606 OID 16483)
-- Name: tb_estadocivil id_est; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_estadocivil
    ADD CONSTRAINT id_est PRIMARY KEY (id_est);


--
-- TOC entry 4751 (class 2606 OID 16543)
-- Name: tb_perfilpagina id_perpag; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_perfilpagina
    ADD CONSTRAINT id_perpag PRIMARY KEY (id_perpag);


--
-- TOC entry 4736 (class 2606 OID 16412)
-- Name: tb_producto id_pr; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_producto
    ADD CONSTRAINT id_pr PRIMARY KEY (id_pr);


--
-- TOC entry 4749 (class 2606 OID 16492)
-- Name: tb_usuario id_us; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_usuario
    ADD CONSTRAINT id_us PRIMARY KEY (id_us);


--
-- TOC entry 4738 (class 2606 OID 16443)
-- Name: tb_pagina pk_tb_pagina; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_pagina
    ADD CONSTRAINT pk_tb_pagina PRIMARY KEY (id_pag);


--
-- TOC entry 4741 (class 2606 OID 16447)
-- Name: tb_parametros pk_tb_parametros; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_parametros
    ADD CONSTRAINT pk_tb_parametros PRIMARY KEY (id_par);


--
-- TOC entry 4744 (class 2606 OID 16449)
-- Name: tb_perfil pk_tb_perfil; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_perfil
    ADD CONSTRAINT pk_tb_perfil PRIMARY KEY (id_per);


--
-- TOC entry 4754 (class 1259 OID 16744)
-- Name: tb_auditoria_pk; Type: INDEX; Schema: auditoria; Owner: postgres
--

CREATE UNIQUE INDEX tb_auditoria_pk ON auditoria.tb_auditoria USING btree (id_aud);


--
-- TOC entry 4739 (class 1259 OID 16455)
-- Name: tb_pagina_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX tb_pagina_pk ON public.tb_pagina USING btree (id_pag);


--
-- TOC entry 4742 (class 1259 OID 16457)
-- Name: tb_parametros_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX tb_parametros_pk ON public.tb_parametros USING btree (id_par);


--
-- TOC entry 4745 (class 1259 OID 16458)
-- Name: tb_perfil_pk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX tb_perfil_pk ON public.tb_perfil USING btree (id_per);


--
-- TOC entry 4760 (class 2620 OID 16746)
-- Name: tb_estadocivil tb_estadocivil_tg_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tb_estadocivil_tg_audit AFTER INSERT OR DELETE OR UPDATE ON public.tb_estadocivil FOR EACH ROW EXECUTE FUNCTION public.fn_log_audit();


--
-- TOC entry 4755 (class 2606 OID 16413)
-- Name: tb_producto id_cat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_producto
    ADD CONSTRAINT id_cat FOREIGN KEY (id_cat) REFERENCES public.tb_categoria(id_cat);


--
-- TOC entry 4756 (class 2606 OID 16508)
-- Name: tb_usuario id_est; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_usuario
    ADD CONSTRAINT id_est FOREIGN KEY (id_est) REFERENCES public.tb_estadocivil(id_est) NOT VALID;


--
-- TOC entry 4758 (class 2606 OID 16549)
-- Name: tb_perfilpagina id_pag; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_perfilpagina
    ADD CONSTRAINT id_pag FOREIGN KEY (id_pag) REFERENCES public.tb_pagina(id_pag) NOT VALID;


--
-- TOC entry 4757 (class 2606 OID 16503)
-- Name: tb_usuario id_per; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_usuario
    ADD CONSTRAINT id_per FOREIGN KEY (id_per) REFERENCES public.tb_perfil(id_per) NOT VALID;


--
-- TOC entry 4759 (class 2606 OID 16544)
-- Name: tb_perfilpagina id_per; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_perfilpagina
    ADD CONSTRAINT id_per FOREIGN KEY (id_per) REFERENCES public.tb_perfil(id_per);


--
-- TOC entry 4909 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2026-05-04 09:54:30

--
-- PostgreSQL database dump complete
--
--Ejecuta lo de arriba luego todo esto
INSERT INTO public.tb_perfil (id_per, descripcion_per) VALUES
                                                           (1, 'Administrador'),
                                                           (2, 'Empleado'),
                                                           (3, 'Cliente');

SELECT * FROM public.tb_perfil;

INSERT INTO public.tb_estadocivil (id_est, descripcion_est) VALUES
                                                                (1, 'Soltero/a'),
                                                                (2, 'Casado/a'),
                                                                (3, 'Divorciado/a'),
                                                                (4, 'Viudo/a');

-- 1. Agregar control de estado a los productos (por defecto activo)
ALTER TABLE public.tb_producto ADD COLUMN estado_pr BOOLEAN DEFAULT TRUE;

-- 2. Tabla Maestra de Compras (Quién compra, cuándo y con qué tarjeta)
CREATE TABLE public.tb_compra (
                                  id_com SERIAL PRIMARY KEY,
                                  id_us INT REFERENCES public.tb_usuario(id_us),
                                  fecha_com TIMESTAMP DEFAULT NOW(),
                                  total_com DOUBLE PRECISION NOT NULL,
                                  tarjeta_titular VARCHAR(100) NOT NULL,
                                  tarjeta_numero VARCHAR(16) NOT NULL
);

-- 3. Detalle de la Compra (Qué productos y a qué precio se compraron)
CREATE TABLE public.tb_detalle_compra (
                                          id_det SERIAL PRIMARY KEY,
                                          id_com INT REFERENCES public.tb_compra(id_com) ON DELETE CASCADE,
                                          id_pr INT REFERENCES public.tb_producto(id_pr),
                                          cantidad_det INT NOT NULL,
                                          precio_det DOUBLE PRECISION NOT NULL
);

-- Tabla para favoritos
CREATE TABLE IF NOT EXISTS public.tb_favorito (
    id_fav SERIAL PRIMARY KEY,
    id_us INTEGER NOT NULL,
    tmdb_id INTEGER NOT NULL,
    titulo TEXT,
    poster_path TEXT,
    release_year TEXT,
    creado_en TIMESTAMP DEFAULT NOW(),
    UNIQUE (id_us, tmdb_id)
);

INSERT INTO public.tb_usuario (id_per, id_est, nombre_us, cedula_us, correo_us, clave_us)
VALUES (
           1,                  -- id_per: 1 es el Rol de Administrador
           1,                  -- id_est: 1 corresponde a 'Soltero/a' (o cualquier estado inicial)
           'Administrador Principal', -- nombre_us
           '9999999999',       -- cedula_us (Dato quemado inicial)
           'admin@cinestore.com', -- correo_us (Este usarás para loguearte)
           'admin123'          -- clave_us (Contraseña inicial)
       );

SELECT * FROM public.tb_usuario;

UPDATE public.tb_usuario SET clave_us = TRIM(clave_us);

ALTER TABLE public.tb_usuario ADD COLUMN avatar_url TEXT;

