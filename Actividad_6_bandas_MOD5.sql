DROP TABLE IF EXISTS bandas;
CREATE TABLE bandas
(
    nombre character varying(50),
    pais character varying(50)
);

insert into esquemas_practica.bandas (nombre, pais) values ('Kraftwerk', 'Alemania');
insert into esquemas_practica.bandas (nombre, pais) values ('Los prisioneros', 'Chile');
insert into esquemas_practica.bandas (nombre, pais) values ('KMFDM', 'Alemania');
insert into esquemas_practica.bandas (nombre, pais) values ('Muse', 'UK');
insert into esquemas_practica.bandas (nombre, pais) values ('The Chemical Brothers', 'UK');
insert into esquemas_practica.bandas (nombre, pais) values ('TOOL', 'USA');
insert into esquemas_practica.bandas (nombre, pais) values ('The Beatles', 'UK');
insert into esquemas_practica.bandas (nombre, pais) values ('Modeselektor', 'Alemania');

DROP TABLE IF EXISTS bandas_discos;
CREATE TABLE bandas_discos
(
    nombre_disco character varying(50),
    nombre_banda character varying(50),
    anio_disco integer
);

insert into esquemas_practica.bandas_discos (nombre_banda, nombre_disco, anio_disco) values ('Kraftwerk', 'Computer World', 1981);
insert into esquemas_practica.bandas_discos (nombre_banda, nombre_disco, anio_disco) values ('Kraftwerk', 'The Man Machine', 1978);
insert into esquemas_practica.bandas_discos (nombre_banda, nombre_disco, anio_disco) values ('Los prisioneros', 'La cultura de la basura', 1987);
insert into esquemas_practica.bandas_discos (nombre_banda, nombre_disco, anio_disco) values ('Los prisioneros', 'Corazones', 1990);
insert into esquemas_practica.bandas_discos (nombre_banda, nombre_disco, anio_disco) values ('KMFDM', 'NIHIL', 1995);
insert into esquemas_practica.bandas_discos (nombre_banda, nombre_disco, anio_disco) values ('KMFDM', 'XTORT', 1996);
insert into esquemas_practica.bandas_discos (nombre_banda, nombre_disco, anio_disco) values ('KMFDM', 'ADIOS', 1999);
insert into esquemas_practica.bandas_discos (nombre_banda, nombre_disco, anio_disco) values ('Muse', 'Showbiz', 1999);
insert into esquemas_practica.bandas_discos (nombre_banda, nombre_disco, anio_disco) values ('Muse', 'Origin of symmetry', 2001);
insert into esquemas_practica.bandas_discos (nombre_banda, nombre_disco, anio_disco) values ('Muse', 'Black holes and Revelations', 2006);
insert into esquemas_practica.bandas_discos (nombre_banda, nombre_disco, anio_disco) values ('The Chemical Brothers', 'Surrender', 1999);
insert into esquemas_practica.bandas_discos (nombre_banda, nombre_disco, anio_disco) values ('The Chemical Brothers', 'Born in the echoes', 2015);
insert into esquemas_practica.bandas_discos (nombre_banda, nombre_disco, anio_disco) values ('The Chemical Brothers', 'No Geography', 2019);
insert into esquemas_practica.bandas_discos (nombre_banda, nombre_disco, anio_disco) values ('TOOL', 'Aenima', 1996);
insert into esquemas_practica.bandas_discos (nombre_banda, nombre_disco, anio_disco) values ('TOOL', 'Lateralus', 2001);
insert into esquemas_practica.bandas_discos (nombre_banda, nombre_disco, anio_disco) values ('TOOL', 'Fear Inoculum', 2019);
insert into esquemas_practica.bandas_discos (nombre_banda, nombre_disco, anio_disco) values ('The Beatles', 'Rubber Soul', 1965);
insert into esquemas_practica.bandas_discos (nombre_banda, nombre_disco, anio_disco) values ('The Beatles', 'Revolver', 1966);
insert into esquemas_practica.bandas_discos (nombre_banda, nombre_disco, anio_disco) values ('The Beatles', 'Abbey Road', 1969);
insert into esquemas_practica.bandas_discos (nombre_banda, nombre_disco, anio_disco) values ('Modeselektor', 'Hello Mom!', 2005);
insert into esquemas_practica.bandas_discos (nombre_banda, nombre_disco, anio_disco) values ('Modeselektor', 'Monkeytown', 2011);
insert into esquemas_practica.bandas_discos (nombre_banda, nombre_disco, anio_disco) values ('Modeselektor', 'Who Else', 2019);


1. Listar todos los discos de bandas NO alemanas que hayan sido
publicados desde el 2000 en adelante.
SELECT esquemas_practica.bandas_discos.nombre_disco
FROM esquemas_practica.bandas, esquemas_practica.bandas_discos
WHERE bandas.nombre = bandas_discos.nombre_banda 
AND bandas.pais NOT ILIKE 'Alemania'
AND bandas_discos.anio_disco >=2000

2. Listar el disco más reciente de las bandas inglesas que terminan en ‘s’.
SELECT esquemas_practica.bandas.nombre, esquemas_practica.bandas_discos.nombre_disco,esquemas_practica.bandas_discos.anio_disco
FROM esquemas_practica.bandas, esquemas_practica.bandas_discos
WHERE bandas.nombre = bandas_discos.nombre_banda 
	AND bandas.pais ILIKE 'UK'
	AND bandas.nombre ILIKE '%s'
	AND bandas_discos.anio_disco = (SELECT MAX(anio_disco) FROM esquemas_practica.bandas_discos
	WHERE nombre_banda = bandas.nombre);

3. Listar todas las bandas alemanas con al menos un letra K en su nombre
que tengan discos publicados en 1999 o superior.
SELECT esquemas_practica.bandas_discos.nombre_disco
FROM esquemas_practica.bandas, esquemas_practica.bandas_discos
WHERE bandas.nombre = bandas_discos.nombre_banda 
AND bandas.pais ILIKE 'Alemania'
AND bandas.nombre ILIKE '%k%'
AND bandas_discos.anio_disco >=1999

4. Listar todas las bandas y el número de discos registrados.
SELECT esquemas_practica.bandas.nombre, 
COUNT(bandas_discos.nombre_disco) AS discos
FROM esquemas_practica.bandas, esquemas_practica.bandas_discos
WHERE bandas.nombre = bandas_discos.nombre_banda
GROUP BY bandas.nombre;

5. Mostrar todos los años en que todas las bandas sacaron un disco.
Ordene la lista por año
SELECT bandas_discos.anio_disco, bandas_discos.nombre_banda, c.anio_disco
FROM esquemas_practica.bandas, esquemas_practica.bandas_discos
JOIN (SELECT anio_disco, COUNT(DISTINCT nombre_banda) 
FROM esquemas_practica.bandas_discos
GROUP BY anio_disco)c
ON bandas_discos.anio_disco = c.anio_disco
ORDER BY bandas_discos.anio_disco, bandas_discos.nombre_banda;

6. Listar todas las bandas que tienen un disco con nombre empezado en
A. Listar el nombre de la banda y del disco.
SELECT bandas.nombre, bandas_discos.nombre_disco, bandas_discos.anio_disco
FROM esquemas_practica.bandas, esquemas_practica.bandas_discos
WHERE bandas.nombre = bandas_discos.nombre_banda
AND bandas_discos.nombre_disco LIKE 'A%';

7. Listar todas las bandas que tengan discos con más de una palabra.
Listar el nombre de la banda y del disco.
SELECT bandas.nombre, bandas_discos.nombre_disco
FROM esquemas_practica.bandas, esquemas_practica.bandas_discos
WHERE bandas.nombre = bandas_discos.nombre_banda
AND bandas_discos.nombre_disco LIKE '% %';

8. Listar todas las bandas que tengan discos con más de una palabra.
Listar el nombre de la banda y la cantidad de discos.
SELECT bandas.nombre, COUNT(bandas_discos.nombre_disco) AS cantidad_discos
FROM esquemas_practica.bandas, esquemas_practica.bandas_discos
WHERE bandas.nombre = bandas_discos.nombre_banda
AND bandas_discos.nombre_disco LIKE '% %'
GROUP BY bandas.nombre;



