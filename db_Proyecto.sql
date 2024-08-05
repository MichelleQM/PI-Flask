create database Guiatu2

use Guiatu2
-- use Guiatu


CREATE TABLE Usuarios (
    id_usuario int identity (1,1),
    nombre VARCHAR(150) ,
    apellido VARCHAR(150) ,
    correo VARCHAR(100) ,
    contraseña VARCHAR(225) ,
    fecha_registro DATE ,
	Primary key (id_usuario)
)


CREATE TABLE Login(
    id int identity(1,1),
    id_usuario int ,
    login_date datetime,
    PRIMARY KEY (id),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
)


CREATE TABLE Administradores (
    id_administrador int identity (1,1),
    id_usuario int,
    rol VARCHAR(50),
    fecha_inicio DATE ,
	FOREIGN KEY  (id_usuario) REFERENCES Usuarios (id_usuario),
	Primary key (id_administrador)
)

CREATE TABLE Destinos (
    id_destino int identity (1,1),
    nombre_destino VARCHAR(255) ,
    descripcion VARCHAR(600),
	Primary key (id_destino)
)

-- select*from Destinos

CREATE TABLE Atractivos_Turisticos (
    id_atractivo_turistico int identity (1,1),
    id_destino INT,
    nombre_atractivo VARCHAR(100) ,
    descripcion VARCHAR(600),
    horario_apertura TIME ,
    horario_cierre TIME,
	FOREIGN KEY (id_destino) REFERENCES Destinos (id_destino),
	Primary key (id_atractivo_turistico)
)


CREATE TABLE Historia_Eventos_Destinos (
    id_historia_evento int identity(1,1),
    id_destino INT,
    descripcion_fecha_evento varchar(600),
	FOREIGN KEY (id_destino) REFERENCES Destinos (id_destino),
	Primary key (id_historia_evento)
)


CREATE TABLE Hoteles (
    id_hotel int identity(1,1),
    nombre_hotel VARCHAR(100) ,
    descripcion VARCHAR(600),
	url_pagina VARCHAR(MAX),
	url_img VARCHAR(MAX),
	dato1 VARCHAR(50),
	dato2 VARCHAR(50),
	id_destino int,
	Primary key (id_hotel),
	FOREIGN KEY (id_destino) REFERENCES Destinos(id_destino)
)

--lot
--agregar fk de actividades


CREATE TABLE Actividades (
    id_actividad int identity (1,1),
    nombre_actividad varchar(100) ,
    descripcion varchar(600),
    duracion TIME,
	id_destino int,
	costos decimal (10,2),
	Primary key (id_actividad),
	FOREIGN KEY (id_destino) REFERENCES Destinos(id_destino)
)
-- select*from Actividades

CREATE TABLE Reservas (
    id_reserva int identity (1,1),
    id_usuario INT,
    id_hotel INT ,
    id_actividad INT ,
    fecha_reserva DATE,
    fecha_inicio DATE ,
    fecha_fin DATE ,
	FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_hotel) REFERENCES Hoteles(id_hotel),
    FOREIGN KEY  (id_actividad) REFERENCES Actividades(id_actividad),
	Primary key (id_reserva)
)


CREATE TABLE Sostenibilidad_Destinos (
    id_sostenibilidad int identity (1,1),
    id_destino INT,
	descripcion varchar (600),
	FOREIGN KEY (id_destino) REFERENCES Destinos(id_destino),
	Primary key (id_sostenibilidad)
)


CREATE TABLE Opiniones (
    id_opinion int identity(1,1),
    id_usuario INT,
    id_destino INT,
    id_atractivo_turistico INT,
    calificacion INT,
    comentario varchar(300),
    fecha_opinion DATE,
	FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY  (id_destino) REFERENCES Destinos(id_destino),
    FOREIGN KEY  (id_atractivo_turistico) REFERENCES Atractivos_Turisticos(id_atractivo_turistico),
	Primary key (id_opinion)
)

-- select*from Opiniones
-- select * from Destinos
-- select * from Hoteles

---- INSERTS

insert into Destinos (nombre_destino,descripcion)
Values
('Peña de Bernal','Escala o camina hasta la tercera formación monolítica más grande del mundo, ubicada en el Pueblo Mágico de Bernal. Desde la cima, disfrutarás de impresionantes vistas panorámicas'),
('Las Termas de San Joaquín','Relájate en las aguas termales de este balneario ubicado en el municipio de San Joaquín, rodeado de un entorno natural impresionante.'),
('Sierra Gorda','Explora la belleza natural de la Sierra Gorda, donde encontrarás cascadas, ríos, grutas y una diversidad de flora y fauna.'),
('La Cascada de Chuveje','Haz una caminata por la selva para llegar a esta impresionante cascada de más de 30 metros de altura, ubicada en la Sierra Gorda de Querétaro.')


---Peña de bernal
INSERT INTO Actividades (nombre_actividad, descripcion, duracion, id_destino, costos)
VALUES ('Senderismo y Escalada con Guías Locales',
        'Descubre la magia de la Peña de Bernal a través de emocionantes actividades al aire libre, como el senderismo y la escalada. Nuestros guías locales expertos te llevarán a explorar la belleza natural de este monolito, uno de los más grandes del mundo. La caminata hacia la cima ofrece vistas panorámicas espectaculares y una experiencia única. ¡No te lo pierdas!',
        '07:00:00',
        1,
        50.00);

INSERT INTO Actividades (nombre_actividad, descripcion, duracion, id_destino, costos)
VALUES ('Talleres de Artesanías Locales',
        'Asistir a talleres de fabricación de artesanías con materiales locales y sostenibles, promoviendo la cultura y las prácticas tradicionales',
        '09:00:00',
        1,
        0.00); -- Si el costo varía, puedes asignar 0.00 y manejarlo dinámicamente en la aplicación

INSERT INTO Actividades (nombre_actividad, descripcion, duracion, id_destino, costos)
VALUES ('Visitas a Viñedos Orgánicos',
        'Explorar viñedos que practican agricultura orgánica y sostenible, aprendiendo sobre técnicas de cultivo respetuosas con el medio ambiente.',
        '07:00:00',
        1,
        250.00); -- Asumiendo un costo promedio, puede ajustar según necesite


----termas san Joaquin
INSERT INTO Actividades (nombre_actividad, descripcion, duracion, id_destino, costos)
VALUES ('Baños Termales con Energía Sostenible',
        'Disfrutar de las aguas termales alimentadas por fuentes geotérmicas, mientras te informas sobre las prácticas de eficiencia energética en el manejo de las instalaciones.',
        '08:00:00',
        2,
        270.00);

INSERT INTO Actividades (nombre_actividad, descripcion, duracion, id_destino, costos)
VALUES ('Sendero de historias y luciérnagas',
        'El Sendero del Camino Real es una ruta de nueve kilómetros que comienza en el llamado Puerto de las Pilas, en la cabecera municipal de San Joaquín.',
        '07:00:00',
        2,
        0.00); -- Asumiendo que el costo varía y puede ser manejado dinámicamente en la aplicación

INSERT INTO Actividades (nombre_actividad, descripcion, duracion, id_destino, costos)
VALUES ('Jornadas de Reforestación',
        'Participa en actividades de reforestación y mantenimiento de áreas verdes en los alrededores, ayudando a restaurar el ecosistema local.',
        '06:00:00',
        2,
        0.00); -- Gratis


---sierra gorda----
INSERT INTO Actividades (nombre_actividad, descripcion, duracion, id_destino, costos)
VALUES ('Observación de Aves y Vida Silvestre',
        'Unirse a tours guiados para la observación de aves y otros animales, respetando las normas de protección de la vida silvestre y aprendiendo sobre especies en peligro de extinción.',
        '06:00:00',
        3,
        250.00); -- Asumiendo un costo promedio, puede ajustar según necesite

INSERT INTO Actividades (nombre_actividad, descripcion, duracion, id_destino, costos)
VALUES ('Visitas a Proyectos de Conservación',
        'Conocer proyectos de conservación y manejo de recursos naturales, como los programas de conservación de jaguares y otras especies.',
        '08:00:00',
        3,
        0.00); -- Gratis

INSERT INTO Actividades (nombre_actividad, descripcion, duracion, id_destino, costos)
VALUES ('Ecoturismo Comunitario',
        'Participar en experiencias organizadas por comunidades locales, promoviendo el turismo responsable y la preservación cultural.',
        '09:00:00',
        3,
        0.00); -- Asumiendo que el costo varía y puede ser manejado dinámicamente en la aplicación


-----cascada chueveje---
INSERT INTO Actividades (nombre_actividad, descripcion, duracion, id_destino, costos)
VALUES ('Senderismo y Limpieza de Senderos',
        'Realizar caminatas por los senderos hacia la cascada y participar en actividades de limpieza y mantenimiento de las rutas, contribuyendo a la conservación del entorno.',
        '05:00:00',
        4,
        0.00); -- Gratis

INSERT INTO Actividades (nombre_actividad, descripcion, duracion, id_destino, costos)
VALUES ('Pláticas Educativas sobre Conservación del Agua',
        'Asistir a charlas sobre la importancia de la conservación de recursos hídricos y las prácticas sostenibles para proteger las fuentes de agua.',
        '06:00:00',
        4,
        0.00); -- Gratis

INSERT INTO Actividades (nombre_actividad, descripcion, duracion, id_destino, costos)
VALUES ('Campamentos Ecológicos',
        'Participar en campamentos ecológicos que enseñan sobre la naturaleza local, la sostenibilidad y la importancia de preservar los ecosistemas acuáticos y terrestres.',
        '08:00:00',
        4,
        350.00); -- Asumiendo un costo promedio por casa de acampar, puede ajustar según necesite

INSERT INTO Hoteles (nombre_hotel,descripcion,url_pagina,url_img,dato1,dato2,id_destino)
VALUES
('Hotel de Piedra','El Hotel de Piedra se encuentra en Bernal y ofrece bar y restaurante. Este hotel de 4 estrellas cuenta con WiFi gratuita y recepción 24 horas. La Peña de Bernal está a 600 metros.','https://www.booking.com/hotel/mx/de-piedra.es-mx.html?aid=306396&label=bernal-mx-RY43pYGnFNOgfIBJEui0JQS392667752851%3Apl%3Ata%3Ap1%3Ap2%3Aac%3Aap%3Aneg%3Afi%3Atikwd-358868930840%3Alp9129474%3Ali%3Adec%3Adm%3Appccp%3DUmFuZG9tSVYkc2RlIyh9YdnZzv7u3SiOco5fpqS0M1M&sid=4a3f7eda614e207cc6ca2e46fb8cebac&all_sr_blocks=330473302_278772936_0_0_0;checkin=2024-08-11;checkout=2024-08-12;dest_id=-1652940;dest_type=city;dist=0;group_adults=2;group_children=0;hapos=1;highlighted_blocks=330473302_278772936_0_0_0;hpos=1;matching_block_id=330473302_278772936_0_0_0;no_rooms=1;req_adults=2;req_children=0;room1=A%2CA;sb_price_type=total;sr_order=popularity;sr_pri_blocks=330473302_278772936_0_0_0__285407;srepoch=1722819689;srpvid=63b10609fa49003f;type=total;ucfs=1&','https://cf.bstatic.com/xdata/images/hotel/square600/266637971.webp?k=cc9ed2d128fff1c895c560c7f31db7476ae848d33d8c98b19317d22594dc76f4&o=','Sustentable','Libre de humo',1),
('Suites Campestres Montebello','Suites Campestres Montebello se encuentra en Bernal, a 8,9 km de Peña de Bernal, y ofrece alojamiento con piscina al aire libre, parking privado gratis, jardín y terraza.','https://www.booking.com/hotel/mx/montebello-bernal.es.html?label=bernal-mx-RY43pYGnFNOgfIBJEui0JQS392667752851%3Apl%3Ata%3Ap1%3Ap2%3Aac%3Aap%3Aneg%3Afi%3Atikwd-358868930840%3Alp9129474%3Ali%3Adec%3Adm%3Appccp%3DUmFuZG9tSVYkc2RlIyh9YdnZzv7u3SiOco5fpqS0M1M&gclid=Cj0KCQjwzby1BhCQARIsAJ_0t5OOGVTmUzu37ofoW13LAvUPxguHcbn4LS0IEtf1XseHeBNm5GbMO3EaAn8cEALw_wcB&aid=306396','https://cf.bstatic.com/xdata/images/hotel/square600/254209480.webp?k=e6c6e9faae3a7b01cd61d3b8ff765b5e9caaf8fe9e43efe782f0e13ef5d4a5ab&o=https://cf.bstatic.com/xdata/images/hotel/square600/266637971.webp?k=cc9ed2d128fff1c895c560c7f31db7476ae848d33d8c98b19317d22594dc76f4&o=','Sustentable','Libre de humo',1),
('Hotel Boutique Rancho San Jose','Ofrece alojamiento con terraza y wifi gratis en todo el alojamiento, además de parking privado gratis. Este hotel de 4 estrellas ofrece mostrador de información turística.','https://www.booking.com/hotel/mx/boutique-rancho-san-jorge.es.html?label=bernal-mx-RY43pYGnFNOgfIBJEui0JQS392667752851%3Apl%3Ata%3Ap1%3Ap2%3Aac%3Aap%3Aneg%3Afi%3Atikwd-358868930840%3Alp9129474%3Ali%3Adec%3Adm%3Appccp%3DUmFuZG9tSVYkc2RlIyh9YdnZzv7u3SiOco5fpqS0M1M&gclid=Cj0KCQjwzby1BhCQARIsAJ_0t5OOGVTmUzu37ofoW13LAvUPxguHcbn4LS0IEtf1XseHeBNm5GbMO3EaAn8cEALw_wcB&aid=306396','https://cf.bstatic.com/xdata/images/hotel/square600/561182184.webp?k=406ffd999fc87a47552884999f02e2132c782c502007cdb81c61fc3911080bb8&o=','Sustentable','Libre de humo',1),
('Loft Casa-Octeria','Moderno loft tendencia brutalista en medio de la naturaleza y unas vistas increibles,ventanales para apreciar mejor las vistas y una arquitectura que se abraza con el entorno.','https://www.airbnb.mx/rooms/953167592985237480?adults=1&children=0&enable_m3_private_room=true&infants=0&pets=0&search_mode=regular_search&check_in=2024-08-11&check_out=2024-08-16&source_impression_id=p3_1722822503_P3Bw9tElOrvAhtjI&previous_page_section_name=1000&federated_search_id=2cf0acba-5083-4369-8a8a-090ac9d8514a','https://a0.muscache.com/im/pictures/b4b95d97-7bb1-41be-bbda-6fbbba0a594b.jpg?im_w=720','Sustentable','Libre de humo',2),
('Casa de descanso toluquillas','Casa de descanso con las mejores vistas a las montañas y con todas las comodidades que te harán una estancia inigualable.','https://www.airbnb.mx/rooms/597172300603051948?adults=1&children=0&enable_m3_private_room=true&infants=0&pets=0&search_mode=regular_search&check_in=2024-08-11&check_out=2024-08-16&source_impression_id=p3_1722823289_P3OO2e-Kcc9H4PWn&previous_page_section_name=1000&federated_search_id=59a754a8-8b8f-4ba7-859b-ebeb11141970','https://a0.muscache.com/im/pictures/f1f35137-58b6-4f43-8951-7260882ed69d.jpg?im_w=720','Sustentable','Libre de humo',2),
('Bosque de San Joaquín (Cabaña 1)','Muy bien amueblada y acogedora, ideal para relajarse y estar cerca de la naturaleza. Ideal para 4 personas. Muy cómoda y segura, con velador 24/7.','https://www.airbnb.mx/rooms/22925956?adults=1&children=0&enable_m3_private_room=true&infants=0&pets=0&search_mode=regular_search&check_in=2024-08-11&check_out=2024-08-16&source_impression_id=p3_1722823167_P3TqTl40-vvKDFiQ&previous_page_section_name=1000&federated_search_id=59a754a8-8b8f-4ba7-859b-ebeb11141970','https://a0.muscache.com/im/pictures/a5680240-6eee-4719-b9ec-065f41a34b29.jpg?im_w=720','Sustentable','Libre de humo',2),
('Mision Jalpan','Nuestro hotel en Querétaro cuenta con 38 habitaciones con servicios y amenidades de primera clase.','https://www.tripadvisor.com.mx/Hotel_Review-g1597259-d603333-Reviews-Mision_Jalpan-Jalpan_de_Serra_Central_Mexico_and_Gulf_Coast.html','https://media-cdn.tripadvisor.com/media/photo-s/0a/4e/bf/20/fuente-patio-central.jpg','Sustentable','Libre de humo',3),
('Hotel Carretas by Rotamundos','Servicios como terraza, cafetería y bar te esperan en Hotel Carretas by Rotamundos. Podrás conectarte al wifi gratis en las habitaciones y encontrarás diversos servicios, como restaurante.','https://www.expedia.mx/Jalpan-De-Serra-Hoteles-Hotel-Carretas-By-Rotamundos.h59358600.Informacion-Hotel?chkin=2024-08-18&chkout=2024-08-19&x_pwa=1&rfrr=HSR&pwa_ts=1722824250200&referrerUrl=aHR0cHM6Ly93d3cuZXhwZWRpYS5teC9Ib3RlbC1TZWFyY2g%3D&useRewards=false&rm1=a2&regionId=623288425094787072&destination=Franciscan%20Missions%20in%20the%20Sierra%20Gorda%20of%20Quer%C3%A9taro%2C%20Quer%C3%A9taro%2C%20Mexico&destType=MARKET&latLong=21.282654%2C-99.487281&sort=RECOMMENDED&top_dp=1577&top_cur=MXN&gclid=Cj0KCQjwzby1BhCQARIsAJ_0t5NmjSTtGYB4l4Pbu24j9tDi-VmLd6LAI4KNoXuzvQMVJKF4xfzDfNoaAjyzEALw_wcB&semcid=MX.UB.GOOGLE.DT-c-ES.HOTEL&semdtl=a112476355564.b1117227760863.g1kwd-6798948788.e1c.m1Cj0KCQjwzby1BhCQARIsAJ_0t5NmjSTtGYB4l4Pbu24j9tDi-VmLd6LAI4KNoXuzvQMVJKF4xfzDfNoaAjyzEALw_wcB.r1e0295d161cd4c79dd22423c1262a071f9ebf3786497d38ee384d27619d8bd5f9.c1.j19129474.k1.d1629102039268.h1b.i1.l1.n1.o1.p1.q1.s1.t1.x1.f1.u1.v1.w1&userIntent=&selectedRoomType=233465452&selectedRatePlan=388956690&searchId=161926db-06d6-4767-8d35-2209eb9a79c1&propertyName=Hotel%20Carretas%20by%20Rotamundos','https://images.trvl-media.com/lodging/60000000/59360000/59358600/59358600/eacafe0f.jpg?impolicy=resizecrop&rw=455&ra=fit','Sustentable','Libre de humo',3),
('Río Hotel y Glamping','Río HOTEL y glamping te ofrece una variedad de servicios, como jardín y muchos más. Podrás conectarte al wifi gratis en las habitaciones.','https://www.expedia.mx/Rio-HOTEL-Y-Glamping.h101512362.Informacion-Hotel?chkin=2024-08-18&chkout=2024-08-19&x_pwa=1&rfrr=HSR&pwa_ts=1722824249432&referrerUrl=aHR0cHM6Ly93d3cuZXhwZWRpYS5teC9Ib3RlbC1TZWFyY2g%3D&useRewards=false&rm1=a2&regionId=623288425094787072&destination=Franciscan%20Missions%20in%20the%20Sierra%20Gorda%20of%20Quer%C3%A9taro%2C%20Quer%C3%A9taro%2C%20Mexico&destType=MARKET&latLong=21.282654%2C-99.487281&sort=RECOMMENDED&top_dp=1254&top_cur=MXN&gclid=Cj0KCQjwzby1BhCQARIsAJ_0t5NmjSTtGYB4l4Pbu24j9tDi-VmLd6LAI4KNoXuzvQMVJKF4xfzDfNoaAjyzEALw_wcB&semcid=MX.UB.GOOGLE.DT-c-ES.HOTEL&semdtl=a112476355564.b1117227760863.g1kwd-6798948788.e1c.m1Cj0KCQjwzby1BhCQARIsAJ_0t5NmjSTtGYB4l4Pbu24j9tDi-VmLd6LAI4KNoXuzvQMVJKF4xfzDfNoaAjyzEALw_wcB.r1e0295d161cd4c79dd22423c1262a071f9ebf3786497d38ee384d27619d8bd5f9.c1.j19129474.k1.d1629102039268.h1b.i1.l1.n1.o1.p1.q1.s1.t1.x1.f1.u1.v1.w1&userIntent=&selectedRoomType=324050941&selectedRatePlan=393487177&searchId=161926db-06d6-4767-8d35-2209eb9a79c1&propertyName=R%C3%ADo%20HOTEL%20y%20glamping','https://images.trvl-media.com/lodging/102000000/101520000/101512400/101512362/e4fcec00.jpg?impolicy=resizecrop&rw=455&ra=fit','Sustentable','Libre de humo',3),
('Cabañas Terrazul','Cabañas Terrazul se ubica en un desarrollo turístico de Puerto del Rodezno en el Municipio de Pinal de Amoles, región serrana del Estado de Querétaro, apropiado para quienes les agrada disfrutar plenamente del contacto con la naturaleza.','https://www.cabanasterrazul.com/','https://static.wixstatic.com/media/5330a1_1be41e82de124cf69fa2ab6db3241822~mv2.jpg/v1/fill/w_390,h_292,al_c,q_80,usm_0.66_1.00_0.01/5330a1_1be41e82de124cf69fa2ab6db3241822~mv2.jpg&quot','Sustentable','Libre de humo',4),
('Puerto del Zopilote','En Puerto del Zopilote, vivirás una estancia inigualable, donde podrás relajarte y disfrutar de vistas espectaculares en un entorno natural incomparable.','https://www.puertodelzopilote.travel/','https://dynamic-media-cdn.tripadvisor.com/media/photo-o/28/b9/6b/4e/vista-aerea-de-la-cabana.jpg?w=300&h=-1&s=1','Sustentable','Libre de humo',4),
('La Casa De Los Cuatro Vientos','Ubicados en lo alto de la montaña, sobre bosques y arroyos, te ofrecemos dos alojamientos únicos: Casa de Piedra y Cabaña Palafito, ambas con todos los servicios y la seguridad que necesitas para entrar en contacto con la naturaleza.','https://www.casa4vientos.com/','https://static.wixstatic.com/media/d0d5dd_f4474de6118949bb81be973de8e39991~mv2.png/v1/fill/w_393,h_262,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/DSC00938_2%20reducida.png','Sustentable','Libre de humo',4);

-- VISTAS

CREATE VIEW Usuarios_Ultimos_Logins AS
SELECT
    u.id_usuario,
    u.nombre,
    u.apellido,
    u.correo,
    MAX(l.login_date) AS ultimo_login
FROM
    Usuarios u
LEFT JOIN
    Login l ON u.id_usuario = l.id_usuario
GROUP BY
    u.id_usuario, u.nombre, u.apellido, u.correo;


CREATE VIEW Reservas_Completas AS
SELECT
    r.id_reserva,
    u.nombre AS nombre_usuario,
    u.apellido AS apellido_usuario,
    h.nombre_hotel,
    a.nombre_actividad,
    r.fecha_reserva,
    r.fecha_inicio,
    r.fecha_fin
FROM
    Reservas r
JOIN
    Usuarios u ON r.id_usuario = u.id_usuario
JOIN
    Hoteles h ON r.id_hotel = h.id_hotel
JOIN
    Actividades a ON r.id_actividad = a.id_actividad;

CREATE VIEW Atractivos_Por_Destino AS
SELECT
    d.nombre_destino,
    a.nombre_atractivo,
    a.descripcion,
    a.horario_apertura,
    a.horario_cierre
FROM
    Atractivos_Turisticos a
JOIN
    Destinos d ON a.id_destino = d.id_destino;



CREATE VIEW Opiniones_Usuarios AS
SELECT
    o.id_opinion,
    u.nombre AS nombre_usuario,
    u.apellido AS apellido_usuario,
    d.nombre_destino,
    a.nombre_atractivo,
    o.calificacion,
    o.comentario,
    o.fecha_opinion
FROM
    Opiniones o
JOIN
    Usuarios u ON o.id_usuario = u.id_usuario
JOIN
    Destinos d ON o.id_destino = d.id_destino
JOIN
    Atractivos_Turisticos a ON o.id_atractivo_turistico = a.id_atractivo_turistico;


CREATE VIEW Sostenibilidad_Detalles AS
SELECT
    d.nombre_destino,
    s.descripcion
FROM
    Sostenibilidad_Destinos s
JOIN
    Destinos d ON s.id_destino = d.id_destino;

-- PROCESOS

CREATE PROCEDURE InsertarUsuario
    @nombre VARCHAR(150),
    @apellido VARCHAR(150),
    @correo VARCHAR(100),
    @contraseña VARCHAR(225),
    @fecha_registro DATE
AS
BEGIN
    INSERT INTO Usuarios (nombre, apellido, correo, contraseña, fecha_registro)
    VALUES (@nombre, @apellido, @correo, @contraseña, @fecha_registro);
END;

CREATE PROCEDURE ObtenerOpiniones
    @id_usuario INT,
    @id_destino INT
AS
BEGIN
    SELECT
        o.id_opinion,
        o.calificacion,
        o.comentario,
        o.fecha_opinion,
        a.nombre_atractivo
    FROM
        Opiniones o
    JOIN
        Atractivos_Turisticos a ON o.id_atractivo_turistico = a.id_atractivo_turistico
    WHERE
        o.id_usuario = @id_usuario AND o.id_destino = @id_destino;
END;

CREATE PROCEDURE ActualizarHotel
    @id_hotel INT,
    @nombre_hotel VARCHAR(100),
    @ciudad VARCHAR(100)
AS
BEGIN
    UPDATE Hoteles
    SET nombre_hotel = @nombre_hotel, descripcion = @descripcion
    WHERE id_hotel = @id_hotel;
END;

CREATE PROCEDURE EliminarActividad
    @id_actividad INT
AS
BEGIN
    DELETE FROM Actividades
    WHERE id_actividad = @id_actividad;
END;

CREATE PROCEDURE InsertarReserva
    @id_usuario INT,
    @id_hotel INT,
    @id_actividad INT,
    @fecha_reserva DATE,
    @fecha_inicio DATE,
    @fecha_fin DATE
AS
BEGIN
    INSERT INTO Reservas (id_usuario, id_hotel, id_actividad, fecha_reserva, fecha_inicio, fecha_fin)
    VALUES (@id_usuario, @id_hotel, @id_actividad, @fecha_reserva, @fecha_inicio, @fecha_fin);
END;

-- TRIGGERS

-- Tablas para los Triggers

CREATE TABLE Historial_Usuarios (
    id_historial int identity(1,1),
    id_usuario int,
    accion varchar(50),
    fecha datetime,
    PRIMARY KEY (id_historial)
);

CREATE TABLE Historial_Sitios_Turisticos (
    id_historial int identity(1,1),
    id_atractivo_turistico int,
    accion varchar(50),
    fecha datetime,
    PRIMARY KEY (id_historial)
);

CREATE TABLE Historial_Eliminaciones_Usuarios (
    id_historial int identity(1,1),
    id_usuario int,
    accion varchar(50),
    fecha datetime,
    PRIMARY KEY (id_historial)
);
CREATE TABLE Historial_Lugares_Ofertados (
    id_historial int identity(1,1),
    id_destino int,
    accion varchar(50),
    fecha datetime,
    PRIMARY KEY (id_historial)
);


-- Trigger que sirve para la ejecución del proceso de actualización de los datos de los usuarios en la base de datos.
CREATE TRIGGER ActualizarDatosUsuarios
ON Usuarios
AFTER UPDATE
AS
BEGIN
    INSERT INTO Historial_Usuarios (id_usuario, accion, fecha)
    SELECT id_usuario, 'Actualización', GETDATE()
    FROM inserted;
END;
GO


-- Trigger que sirve para la actualización de la información de los sitios turísticos.
CREATE TRIGGER ActualizarInformacionSitiosTuristicos
ON Atractivos_Turisticos
AFTER UPDATE
AS
BEGIN
    INSERT INTO Historial_Sitios_Turisticos (id_atractivo_turistico, accion, fecha)
    SELECT id_atractivo_turistico, 'Actualización', GETDATE()
    FROM inserted;
END;
GO


-- Trigger que sirve para la eliminación de usuarios de la base de datos
CREATE TRIGGER EliminarUsuarios
ON Usuarios
AFTER DELETE
AS
BEGIN
    INSERT INTO Historial_Eliminaciones_Usuarios (id_usuario, accion, fecha)
    SELECT id_usuario, 'Eliminación', GETDATE()
    FROM deleted;
END;
GO


-- Trigger que sirve para para la actualización de la información de los lugares ofertados
CREATE TRIGGER ActualizarInformacionLugaresOfertados
ON Destinos
AFTER UPDATE
AS
BEGIN
    INSERT INTO Historial_Lugares_Ofertados (id_destino, accion, fecha)
    SELECT id_destino, 'Actualización', GETDATE()
    FROM inserted;
END;
GO




-- Trigger que sirve para el registro de nuevos lugares que se vayan a ofertar
CREATE TRIGGER RegistroNuevosLugaresOfertados
ON Destinos
AFTER INSERT
AS
BEGIN
    INSERT INTO Historial_Lugares_Ofertados (id_destino, accion, fecha)
    SELECT id_destino, 'Nuevo Registro', GETDATE()
    FROM inserted;
END;
GO


select*from Opiniones


--Uso 1
UPDATE Usuarios
SET nombre = 'Aqui va el nuevo nombre', apellido = 'Aqui va el Nuevo Apellido'
WHERE id_usuario = 1;
--Uso 2
UPDATE Atractivos_Turisticos
SET nombre_atractivo = 'NuevoAtractivo', descripcion = 'NuevaDescripcion'
WHERE id_atractivo_turistico = 1;
--Uso 3
DELETE FROM Usuarios
WHERE id_usuario = 1;
-- Uso 4
UPDATE Destinos
SET nombre_destino = 'NuevoDestino', descripcion = 'NuevaDescripcion'
WHERE id_destino = 1;
--Uso 5
INSERT INTO Destinos (nombre_destino, descripcion)
VALUES ('NuevoDestino', 'DescripcionDelNuevoDestino');