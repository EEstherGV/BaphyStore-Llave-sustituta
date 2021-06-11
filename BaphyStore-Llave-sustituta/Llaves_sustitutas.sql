create schema inicio;

create table inicio.authorithy (
    name varchar(50) not null ,
    primary key (name)
);

create table inicio.system_user(
    id int4 not null ,
    login varchar(50) not null constraint uk_login unique,
    password varchar(60) not null ,
    email varchar(254) not null constraint uk_email unique,
    ativated int4 null ,
    lang_key varchar(6) not null ,
    image_url varchar(256) null ,
    activation_key varchar(20) null ,
    reset_key varchar(20) null ,
    reset_date timestamp null ,
    primary key (id)
);

create table inicio.user_authority (
    name_rol varchar(50) not null ,
    id_system_user int4 not null ,
    primary key (name_rol, id_system_user),
    constraint fk_auth_usau foreign key (name_rol) references inicio.authorithy (name),
    constraint fk_syus_usau foreign key (id_system_user) references inicio.system_user (id)
);

create table inicio.cliente (
    id int4 not null ,
    id_tipo_documento int4 not null ,
    numero_documento varchar(50) not null  ,
    primer_nombre varchar(50) not null ,
    segundo_nombre varchar(50) null ,
    primer_apellido varchar(50) not null ,
    segundo_apellido varchar(50) null ,
    id_user int4 not null constraint uk_user unique ,
    primary key (id),
    constraint fk_user_clie foreign key (id_tipo_documento) references inicio.system_user (id),
    constraint uk_cliente unique (id_tipo_documento, numero_documento)
);

create table inicio.tipo_documento (
    id int4 not null ,
    sigla varchar(10) not null constraint uk_sigla unique ,
    nombre_documento varchar(100) not null constraint uk_nombre_documento unique ,
    estado varchar(40) not null ,
    primary key (id)
);

alter table inicio.cliente add constraint fk_tido_clie foreign key (id_tipo_documento) references inicio.tipo_documento;

create schema logs;

create table logs.log_errores(
  id int4 not null ,
  nivel varchar(400) not null,
  log_name varchar(400) not null ,
  mensaje varchar(400) not null ,
  fecha date not null ,
  id_cliete int4 not null ,
  primary key (id),
  constraint fk_clie_log_erro foreign key (id_cliete) references inicio.cliente (id)
);

create table logs.log_auditoria (
  id int4 not null ,
  nivel varchar(400) not null ,
  log_name varchar(400) not null ,
  mensaje varchar(400) not null ,
  fecha date not null ,
  id_cliente int4 not null ,
  primary key (id),
  constraint fk_clie_log_audi foreign key (id_cliente) references inicio.cliente (id)
);

create schema ficha;

create table ficha.estado_formacion(
  id int4 not null ,
  nombre_estado varchar(40) not null ,
  estado varchar(40) not null ,
  primary key (id),
  constraint uk_estado_nombre unique (nombre_estado)
);

create table ficha.estado_ficha(
    id int4 not null ,
    nombre_estado varchar(20) NOT NULL,
    estado int2 NOT NULL,
    primary key (id),
    constraint uk_nombre_estado unique (nombre_estado)
);

create table ficha.jornada(
    id int4 not null ,
    sigla_jornada varchar(20) not null ,
    nombre_jornada varchar(40) not null ,
    descripcion varchar(100) not null ,
    imagen_url varchar(1000) null ,
    estado varchar(40) not null ,
    primary key (id),
    constraint uk_sigla_jornada unique (sigla_jornada),
    constraint uk_nombre_sigla unique (nombre_jornada)
);

create table ficha.ficha(
    id int4 not null ,
    id_programa int4 not null ,
    numero_ficha varchar(100) not null constraint uk_ficha unique ,
    fecha_inicio date not null ,
    fecha_fin date not null ,
    ruta varchar(40) not null ,
    id_estado_ficha int4 not null ,
    id_jornada int4 not null ,
    primary key (id),
    constraint fk_exfi_fich foreign key (id_estado_ficha) references ficha.estado_ficha (id),
    constraint fk_jorn_fich foreign key (id_jornada) references ficha.jornada (id)
);

create table ficha.trimestre(
    id int4 not null ,
    nombre_trimestre int4 not null ,
    id_jornada int4 not null ,
    id_nivel_formacion int4 not null ,
    estado varchar(40) not null ,
    primary key (id),
    constraint uk_trimestre unique (nombre_trimestre, id_jornada, id_nivel_formacion),
    constraint fk_jorn_trim foreign key (id_jornada) references ficha.jornada (id)
);

create table ficha.aprendiz(
    id int4 not null ,
    id_cliente int4 not null ,
    id_ficha int4 not null ,
    id_estado_formacion int4 not null,
    primary key (id),
    constraint uk_aprendiz unique (id_cliente, id_ficha),
    constraint fk_clie_apre foreign key (id_cliente) references inicio.cliente (id),
    constraint fk_esta_apre foreign key (id_estado_formacion) references  ficha.estado_formacion (id),
    constraint fk_fich_apre foreign key (id_ficha) references ficha.ficha (id)
);

create table ficha.ficha_has_trimestre(
    id int4 not null ,
    id_ficha int4 not null ,
    id_trimestre int4 not null ,
    primary key (id),
    constraint uk_ficha_has_rimestre unique (id_ficha, id_trimestre),
    constraint fk_trim_fitr foreign key (id_trimestre) references ficha.trimestre (id),
    constraint fk_fich_fitr foreign key (id_ficha) references ficha.ficha (id)
);

create table ficha.ficha_planeacion(
    id int4 not null ,
    id_ficha int4 not null ,
    id_planeacion int4 not null ,
    primary key (id),
    constraint uk_ficha_planeacion unique (id_ficha, id_planeacion),
    constraint fk_fich_fipl foreign key (id_ficha) references ficha.ficha (id)
);

create table ficha.resultado_vistos(
    id int4 not null ,
    id_resultados_aprendiz int4 not null ,
    id_fichas_has_trimestre int4 not null ,
    id_planeacion int4 not null ,
    primary key (id),
    constraint uk_resultados_vistos unique (id_resultados_aprendiz, id_fichas_has_trimestre, id_planeacion),
    constraint fk_fitr_revi foreign key (id_fichas_has_trimestre) references ficha.ficha_has_trimestre (id)
);

create schema programa;

create table programa.planeacion (
   id int4 not null ,
   codigo varchar(40) not null constraint uk_codigo unique ,
   fecha date not null ,
   estado varchar(40) not null ,
   primary key (id)
);

alter table ficha.resultado_vistos add constraint fk_plan_revi foreign key (id_planeacion) references programa.planeacion (id);
alter table ficha.ficha_planeacion add constraint fk_plan_fipl foreign key (id_planeacion) references programa.planeacion (id);

create table programa.nivel_formacion (
   id int4 not null ,
   nivel varchar(40) not null constraint uk_nivel unique ,
   estado varchar(40) not null ,
   primary key (id)
);

alter table ficha.trimestre add constraint fk_nifo_trim foreign key (id_nivel_formacion) references programa.nivel_formacion (id);

create table programa.programa (
   id int4 not null ,
   codigo varchar(50) not null ,
   version varchar(40) not null ,
   nombre varchar(500) not null ,
   sigla varchar(40) not null ,
   estado varchar(40) not null ,
   id_nivel_formacion int4 not null,
   primary key (id),
   constraint uk_programa unique (codigo, version),
   constraint fk_nifo_prog foreign key (id_nivel_formacion) references programa.nivel_formacion (id)
);

alter table ficha.ficha add constraint fk_prog_fich foreign key (id_programa) references programa.programa (id);

create table programa.competencia (
    id int4 not null ,
    id_programa int4 not null ,
    codigo_competencia varchar(50) not null ,
    denominacion varchar(1000) not null ,
    primary key (id),
    constraint uk_competencia unique (id_programa, codigo_competencia),
    constraint fk_prog_comp foreign key (id_programa) references programa.programa (id)
);

create table programa.resultado_aprendiz(
   id int4 not null ,
   codigo_resultado varchar(40) not null ,
   id_competencia int4 not null ,
   denominacion varchar(1000) not null ,
   primary key (id),
   constraint uk_resultado_aprendizaje unique (codigo_resultado, id_competencia),
   constraint fk_comp_reap foreign key (id_competencia) references programa.competencia (id)
);

alter table ficha.resultado_vistos add constraint fk_reap_revi foreign key (id_resultados_aprendiz) references programa.resultado_aprendiz (id);

create table programa.programacion_trimestre(
   id int4 not null ,
   id_resultados_aprendizaje int4 not null ,
   id_trimestre int4 not null ,
   id_planeacion int4 not null ,
   primary key (id),
   constraint uk_programacion_trimestre unique (id_resultados_aprendizaje, id_trimestre, id_planeacion),
   constraint fk_reap_prtr foreign key (id_resultados_aprendizaje) references programa.resultado_aprendiz (id),
   constraint fk_trim_prtr foreign key (id_trimestre) references ficha.trimestre (id),
   constraint fk_plan_prtr foreign key (id_planeacion) references programa.planeacion (id)
);

create table programa.actividad_planeacion (
   id int4 not null ,
   id_actividad_proyecto int4 not null ,
   id_programacion_trimestre int4 not null ,
   primary key (id),
   constraint uk_actividad_planeacion unique (id_actividad_proyecto, id_programacion_trimestre),
   constraint fk_prtr_acpl foreign key (id_programacion_trimestre) references programa.programacion_trimestre (id)
);

create schema proyectos;

create table proyectos.proyecto(
    id int4 not null ,
    codigo varchar(40) not null constraint uk_codigo unique ,
    nombre varchar(500) not null ,
    estado varchar(40) not null ,
    id_programa int4 not null ,
    primary key (id),
    constraint fk_prog_proy foreign key (id_programa) references programa.programa(id)
);

create table proyectos.fase(
    id int4 not null ,
    id_proyecto int4 not null ,
    nombre varchar(40) not null ,
    estado varchar(40) not null ,
    primary key (id),
    constraint uk_fase unique (id_proyecto, nombre),
    constraint fk_proy_fase foreign key (id_proyecto) references proyectos.proyecto (id)
);

create table proyectos.actividad_proyecto (
    id int4 not null ,
    id_fase int4 not null ,
    numero_actividad int4 not null ,
    descripcion_actividad varchar(400) not null ,
    estado varchar(40) not null ,
    primary key (id),
    constraint uk_actividad_proyecto unique (id_fase, numero_actividad),
    constraint fk_fase_acpr foreign key (id_fase) references proyectos.fase (id)
);

alter table programa.actividad_planeacion add constraint fk_acti_acpl foreign key (id_actividad_proyecto) references proyectos.actividad_proyecto (id);

create schema sede;

create table sede.tipo_ambiente (
    id int4 not null ,
    tipo varchar(50) not null constraint uk_tio_ambiente unique ,
    descripcion varchar(100) not null ,
    estado varchar(40) not null ,
    primary key (id)
);

create table sede.sede (
    id int4 not null ,
    nombre_sede varchar(50) not null constraint uk_sede unique ,
    direccion varchar(400) not null ,
    estado varchar(40) not null ,
    primary key (id)
);

create table sede.ambiente (
    id int4 not null ,
    id_sede int4 not null ,
    numero_ambiente varchar(50) not null ,
    descripcion varchar(1000) not null ,
    estado varchar(40) not null ,
    limitacion varchar(40) not null ,
    id_tipo_ambiente int4 not null ,
    primary key (id),
    constraint uk_ambiente unique (id_sede, numero_ambiente),
    constraint fk_tiam_ambi foreign key (id_tipo_ambiente) references sede.tipo_ambiente (id),
    constraint fk_sede_ambi foreign key (id_sede) references sede.sede (id)
);

create table sede.limitacion_ambiente (
    id int4 not null ,
    id_resultado_aprendiz int4 not null ,
    id_ambiente int4 not null ,
    primary key (id),
    constraint uk_limitacion_ambiente unique (id_resultado_aprendiz, id_ambiente),
    constraint fk_ambi_liam foreign key (id_ambiente) references sede.ambiente (id),
    constraint fk_reap_liam foreign key (id_resultado_aprendiz) references programa.resultado_aprendiz (id)
);

create schema package;

create table package.grupo_proyecto(
   id int4 not null ,
   id_ficha int4 not null ,
   numero_grupo int4 not null ,
   nombre_proyecto varchar(300) not null ,
   estado_grupo_proyecto varchar(40) not null ,
   primary key (id),
   constraint uk_grupo_pryecto unique (id_ficha, numero_grupo),
   constraint fk_fich_grup_proy foreign key (id_ficha) references ficha.ficha (id)
);

create table package.lista_chequeo (
    id int4 not null ,
    id_programa int4 not null ,
    lista varchar(50) not null constraint uk_lista unique ,
    estado int4 not null ,
    primary key (id),
    constraint fk_prog_lich foreign key (id_programa) references programa.programa (id)
);

create table package.valoracion (
    id int4 not null ,
    tipo_valoracion varchar(50) not null constraint uk_valoracion unique ,
    estado varchar(40) not null ,
    primary key (id)
);

create table package.observacion_general (
    id int4 not null ,
    numero int4 not null ,
    id_grupo_proyecto int4 not null ,
    observacion varchar(500) not null ,
    jurado varchar(500) not null ,
    fecha timestamp not null ,
    id_cliente int4 not null ,
    primary key (id) ,
    constraint uk_observacion_general unique (numero, id_grupo_proyecto),
    constraint fk_grpr_obge foreign key (id_grupo_proyecto) references package.grupo_proyecto (id),
    constraint fk_clie_oge foreign key (id_cliente) references inicio.cliente (id)
);

create table package.integrantes_grupo (
    id int4 not null ,
    id_aprendiz int4 not null ,
    id_grupo_proyecto int4 not null ,
    primary key (id),
    constraint uk_integrantes_grupo unique (id_aprendiz, id_grupo_proyecto),
    constraint fk_grpr_ingr foreign key (id_grupo_proyecto) references package.grupo_proyecto (id),
    constraint fk_apre_ingr foreign key (id_aprendiz) references ficha.aprendiz (id)
);

create table package.lista_ficha (
    id int4 not null ,
    id_ficha int4 not null ,
    id_lista_chequeo int4 not null ,
    estado varchar(40) not null ,
    primary key (id),
    constraint uk_lista_chequeo unique (id_ficha, id_lista_chequeo),
    constraint fk_fich_lifi foreign key (id_ficha) references ficha.ficha (id),
    constraint fk_lich_lifi foreign key (id_lista_chequeo) references package.lista_chequeo (id)
);

create table package.item_lista (
    id int4 not null ,
    id_lista_chequeo int4 not null ,
    numero_item int4 not null ,
    pregunta varchar(1000) not null ,
    id_resultado_aprendiz int4 not null ,
    primary key (id),
    constraint uk_item_lista unique (id_lista_chequeo, numero_item),
    constraint fk_lich_itli foreign key (id_lista_chequeo) references package.lista_chequeo (id),
    constraint fk_reap_itli foreign key (id_resultado_aprendiz) references programa.resultado_aprendiz (id)
);

create table package.respuesta_grupo (
    id int4 not null ,
    id_item_lista int4 not null ,
    id_grupo_proyecto int4 not null ,
    id_valoracion int4 not null ,
    primary key (id),
    constraint uk_respuesta_grupo unique (id_item_lista, id_grupo_proyecto),
    constraint fk_grpr_regr foreign key (id_grupo_proyecto) references package.grupo_proyecto (id),
    constraint fk_valo_regr foreign key (id_valoracion) references package.valoracion (id),
    constraint fk_itli_regr foreign key (id_item_lista) references package.item_lista (id)
);

create table package.observacion_respuesta(
    id int4 not null ,
    numero_observacion int4 not null ,
    id_respuesta_proyecto int4 not null ,
    observacion varchar(400) not null ,
    jurado varchar(400) not null ,
    fecha timestamp not null ,
    id_cliente int4 not null ,
    primary key (id),
    constraint uk_observacion_respuesta unique (numero_observacion, id_respuesta_proyecto),
    constraint fk_clie_obre foreign key (id_cliente) references inicio.cliente (id),
    constraint fk_regr_obre foreign key (id_respuesta_proyecto) references package.respuesta_grupo (id)
);

create schema intructor;

create table intructor.year (
    id int4 not null ,
    number_year int4 not null constraint uk_year unique ,
    estado varchar(40) not null ,
    primary key (id)
);

create table intructor.area (
    id int4 not null ,
    nombre_area varchar(40) not null constraint uk_area unique ,
    estado varchar(40) not null ,
    url_logo varchar(1000) null ,
    primary key (id)
);

create table intructor.instructor (
    id int4 not null ,
    id_cliente int4 not null constraint uk_instructor unique ,
    estado varchar(40) not null ,
    primary key (id),
    constraint fk_clie_inst foreign key (id_cliente) references inicio.cliente (id)
);

create table intructor.vinculacion (
    id int4 not null ,
    tipo_vinculacion varchar(40) not null constraint uk_vinculacion unique ,
    hora int4 not null ,
    estado varchar(40) not null ,
    primary key (id)
);

create table intructor.jornada_instructor (
    id int4 not null ,
    nombre_jornada varchar(80) not null constraint uk_nombre_jornada unique ,
    descripcion varchar(200) not null ,
    estado varchar(40) not null ,
    primary key (id)
);

create table intructor.area_intructor (
    id int4 not null ,
    id_area int4 not null ,
    id_instructor int4 not null ,
    estado varchar(40) not null ,
    primary key (id),
    constraint uk_area_instructor unique (id_area, id_instructor),
    constraint fk_area_arin foreign key (id_area) references intructor.area (id),
    constraint fk_intr_arin foreign key (id_instructor) references intructor.instructor (id)
);

create table intructor.vinculacion_instructor (
    id int4 not null ,
    id_year int4 not null ,
    fecha_inicio date not null ,
    fecha_fin date not null ,
    id_vinculacion int4 not null ,
    id_instructor int4 not null ,
    primary key (id),
    constraint uk_vinculacion_instructor unique (id_year, fecha_inicio, fecha_fin, id_vinculacion, id_instructor),
    constraint fk_year_viin foreign key (id_year) references intructor.year (id),
    constraint fk_inst_viin foreign key (id_instructor) references intructor.instructor (id),
    constraint fk_vinc_viin foreign key (id_vinculacion) references intructor.vinculacion (id)
);

create table intructor.disponibilidad_horaria (
    id int4 not null ,
    id_jornada_instructor int4 not null ,
    id_vinculacion_intructor int4 not null ,
    primary key (id),
    constraint uk_disponibilidad_horaria unique (id_jornada_instructor, id_vinculacion_intructor),
    constraint fk_viis_disp foreign key (id_vinculacion_intructor) references intructor.vinculacion_instructor (id),
    constraint fk_jorn_disp foreign key (id_jornada_instructor) references intructor.jornada_instructor (id)
);

create table intructor.disponibilidad_competencias (
    id int4 not null ,
    id_competencia int4 not null ,
    id_vinculacion_instructor int4 not null ,
    primary key (id),
    constraint uk_disp_comp unique (id_competencia, id_vinculacion_instructor),
    constraint fk_viin_dico foreign key (id_vinculacion_instructor) references intructor.vinculacion_instructor (id),
    constraint fk foreign key (id_competencia) references programa.competencia (id)
);

create table intructor.dia_jornada (
    id int4 not null ,
    id_jornada_instructor int4 not null ,
    id_dia int4 not null ,
    hora_inicio int4 not null ,
    hora_fin int4 not null ,
    primary key (id),
    constraint uk_dia_jornada unique (id_jornada_instructor, id_dia, hora_inicio, hora_fin),
    constraint fk_jorn_inst foreign key (id_jornada_instructor) references intructor.jornada_instructor (id)
);

create schema horarios;

create table horarios.dia (
    id int4 not null ,
    nombre_dia varchar(40) not null constraint uk_dia unique ,
    estado varchar(40) not null ,
    primary key (id)
);

alter table intructor.dia_jornada add constraint fk_dia_jorn foreign key  (id_dia) references horarios.dia (id);

create table horarios.modalidad (
    id int4 not null ,
    nombre_modalidad varchar(40) not null constraint uk_modalidad unique ,
    color varchar(50) not null ,
    estado varchar(40) not null ,
    primary key (id)
);

create table horarios.trimestre_vigente (
    id int4 not null ,
    id_year int4 not null ,
    trimestre_programado int4 not null ,
    fecha_inicio date not null ,
    fecha_fin date not null ,
    estado varchar(40) ,
    primary key (id) ,
    constraint uk_trimestre_vigente unique (id_year, trimestre_programado),
    constraint fk_year_trim_vige foreign key (id_year) references intructor.year (id)
);

create table horarios.version_horario (
    id int4 not null ,
    numero_version varchar(40) not null ,
    id_trimestre_vigente int4 not null ,
    estado varchar(40) not null ,
    primary key (id),
    constraint uk_version_horario unique (numero_version, id_trimestre_vigente),
    constraint fk_trvi_veho foreign key (id_trimestre_vigente) references horarios.trimestre_vigente (id)
);

create table horarios.horario (
    id int4 not null ,
    hora_inicio time not null ,
    id_ficha_has_trimestre int4 not null ,
    id_instructor int4 not null ,
    id_dia int4 not null ,
    id_ambiente int4 not null ,
    id_version_horario int4 not null ,
    hora_fin time not null ,
    id_modalidad int4 not null ,
    primary key (id),
    constraint uk_horario unique (hora_inicio, id_ficha_has_trimestre, id_instructor, id_dia, id_ambiente, id_version_horario, hora_fin),
    constraint fk_ceho_hora foreign key (id_version_horario) references horarios.version_horario (id),
    constraint fk_inst_hora foreign key (id_instructor) references intructor.instructor (id),
    constraint fk_moda_hora foreign key (id_modalidad) references horarios.modalidad (id),
    constraint fk_ambi_hora foreign key (id_ambiente) references sede.ambiente (id),
    constraint fk_fitr_hora foreign key (id_ficha_has_trimestre) references ficha.ficha_has_trimestre (id),
    constraint fk_dia_hora foreign key (id_dia) references horarios.dia (id)
);
