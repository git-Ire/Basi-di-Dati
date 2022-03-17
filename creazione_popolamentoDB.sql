
DROP TABLE IF EXISTS Agenzia CASCADE; 
DROP TABLE IF EXISTS Alloggio CASCADE;
DROP TABLE IF EXISTS Cliente CASCADE;
DROP TABLE IF EXISTS Dati_Personali CASCADE;
DROP TABLE IF EXISTS Dipendente CASCADE;
DROP TABLE IF EXISTS Mezzo_Trasporto CASCADE;
DROP TABLE IF EXISTS Sistemazione CASCADE;
DROP TABLE IF EXISTS Trasporto CASCADE;
DROP TABLE IF EXISTS Vendita CASCADE;
DROP TABLE IF EXISTS Viaggio CASCADE;
DROP TYPE IF EXISTS Genere CASCADE;

--Agenzia
CREATE TABLE Agenzia(
Codice CHAR(4) NOT NULL,    
Tipologia VARCHAR NOT NULL,
Responsabile CHAR(4) NOT NULL, 
Telefono VARCHAR(15) NOT NULL,
Mail VARCHAR NOT NULL,
Stato VARCHAR NOT NULL,
Citta VARCHAR NOT NULL,
Via VARCHAR NOT NULL,
CAP CHAR(5) NOT NULL,
N_vendite INT DEFAULT 0 CHECK (N_vendite >=0),
PRIMARY KEY(Codice),
UNIQUE(Responsabile)
);

--Cliente
CREATE TABLE Cliente(
PI_CF VARCHAR(16) NOT NULL,
Nome_azienda VARCHAR,
Cognome VARCHAR NOT NULL, 
Nome VARCHAR NOT NULL, 
Mail VARCHAR NOT NULL, 
Telefono VARCHAR(15) NOT NULL, 
Stato VARCHAR NOT NULL, 
Citta VARCHAR NOT NULL, 
Via VARCHAR NOT NULL, 
CAP CHAR(5) NOT NULL, 
Anno_iscrizione NUMERIC(4),
Codice_agenzia CHAR(4) NOT NULL,
PRIMARY KEY(PI_CF)
);

--Dipendente
CREATE TABLE Dipendente(
Codice CHAR(4) NOT NULL, 
Mansione VARCHAR NOT NULL, 
Ruolo VARCHAR NOT NULL DEFAULT 'impiegato', 
Mail VARCHAR NOT NULL, 
Telefono VARCHAR(15) NOT NULL, 
Cognome VARCHAR NOT NULL, 
Nome VARCHAR NOT NULL, 
Sede CHAR(4) NOT NULL,
PRIMARY KEY(Codice)
);

CREATE TYPE Genere AS ENUM ('M', 'F');

--Dati_Personali
CREATE TABLE Dati_Personali(
CF CHAR(16) NOT NULL, 
Codice_dip VARCHAR(4) NOT NULL, 
Contratto VARCHAR NOT NULL, 
Stipendio FLOAT NOT NULL DEFAULT 0, 
Data_inizio DATE NOT NULL, 
Data_fine DATE DEFAULT '2999-12-31',
Stato VARCHAR NOT NULL, 
Citta VARCHAR NOT NULL, 
Via VARCHAR NOT NULL, 
CAP CHAR(5) NOT NULL, 
Sesso Genere NOT NULL, 
Data_nascita DATE NOT NULL,
PRIMARY KEY(CF),
UNIQUE(Codice_dip)
);

--Viaggio
CREATE TABLE Viaggio(
Codice CHAR(4) NOT NULL, 
Nome TEXT NOT NULL, 
Stato VARCHAR NOT NULL, 
Citta VARCHAR NOT NULL, 
Durata INT NOT NULL CHECK(Durata >0),  --in giorni
Costo INT NOT NULL CHECK(Costo >0), 
Link TEXT NOT NULL,
PRIMARY KEY(Codice)
);

--Mezzo_Trasporto
CREATE TABLE Mezzo_Trasporto(
Codice CHAR(4) NOT NULL, 
P_stato VARCHAR NOT NULL, 
P_citta VARCHAR NOT NULL, 
D_stato VARCHAR NOT NULL, 
D_citta VARCHAR NOT NULL, 
Mezzo VARCHAR NOT NULL, 
Durata INT NOT NULL CHECK(Durata >0), --in ore
Costo FLOAT NOT NULL CHECK(Costo>0.0), 
Link TEXT NOT NULL,
PRIMARY KEY(Codice)
);

--Trasporto
CREATE TABLE Trasporto(
Codice_viaggio CHAR(4) NOT NULL,
Codice_mezzo CHAR(4) NOT NULL,
PRIMARY KEY(Codice_viaggio, Codice_mezzo)
);

--Alloggio
CREATE TABLE Alloggio(
Codice CHAR(4) NOT NULL,
Tipologia VARCHAR NOT NULL, 
Categoria VARCHAR, 
Nome VARCHAR NOT NULL, 
Stato VARCHAR NOT NULL, 
Citta VARCHAR NOT NULL, 
Via VARCHAR NOT NULL, 
Mail VARCHAR NOT NULL, 
Telefono VARCHAR(15) NOT NULL, 
Link TEXT NOT NULL,
PRIMARY KEY(Codice)
);

--Sistemazione
CREATE TABLE Sistemazione(
Codice_viaggio CHAR(4) NOT NULL,
Codice_alloggio CHAR(4) NOT NULL,
PRIMARY KEY(Codice_viaggio, Codice_alloggio)
);

--Vendita
CREATE TABLE Vendita(
Cliente VARCHAR(16) NOT NULL, 
Data DATE NOT NULL, 
Codice_viaggio CHAR(4) NOT NULL,
Totale FLOAT NOT NULL CHECK(Totale>0), 
Codice_dip CHAR(4) NOT NULL, 
Codice_transfer1 CHAR(4), 
Codice_transfer2 CHAR(4),
Codice_alloggio CHAR(4) NOT NULL,
PRIMARY KEY(Cliente, Data, Codice_viaggio)
);

--VINCOLI INTEGRITA’ REFERENZIALE
ALTER TABLE Agenzia 
ADD FOREIGN KEY (Responsabile) 
REFERENCES Dipendente (Codice);

ALTER TABLE Cliente 
ADD FOREIGN KEY (Codice_agenzia) 
REFERENCES Agenzia (Codice);

ALTER TABLE Dipendente 
ADD FOREIGN KEY (Sede) 
REFERENCES Agenzia (Codice);

ALTER TABLE Dati_Personali
ADD FOREIGN KEY (Codice_dip) 
REFERENCES Dipendente(Codice);

ALTER TABLE Sistemazione 
ADD FOREIGN KEY (Codice_viaggio) 
REFERENCES Viaggio (Codice);

ALTER TABLE Sistemazione 
ADD FOREIGN KEY (Codice_alloggio) 
REFERENCES Alloggio (Codice);

ALTER TABLE Trasporto
ADD FOREIGN KEY (Codice_viaggio) 
REFERENCES Viaggio (Codice);

ALTER TABLE Trasporto
ADD FOREIGN KEY (Codice_mezzo) 
REFERENCES Mezzo_Trasporto(Codice);

ALTER TABLE Vendita 
ADD FOREIGN KEY (Cliente) 
REFERENCES Cliente (PI_CF);

ALTER TABLE Vendita 
ADD FOREIGN KEY (Codice_viaggio) 
REFERENCES Viaggio (Codice);

ALTER TABLE Vendita 
ADD FOREIGN KEY (Codice_dip) 
REFERENCES Dipendente (Codice);

ALTER TABLE Vendita 
ADD FOREIGN KEY (Codice_transfer1) 
REFERENCES Mezzo_Trasporto(Codice);

ALTER TABLE Vendita 
ADD FOREIGN KEY (Codice_transfer2) 
REFERENCES Mezzo_trasporto(Codice);

ALTER TABLE Vendita 
ADD FOREIGN KEY (Codice_alloggio) 
REFERENCES Alloggio(Codice);

--POPOLAMENTO
ALTER TABLE Agenzia DISABLE TRIGGER ALL;
ALTER TABLE Cliente DISABLE TRIGGER ALL;
ALTER TABLE Dipendente DISABLE TRIGGER ALL;
ALTER TABLE Dati_Personali DISABLE TRIGGER ALL;
ALTER TABLE Viaggio DISABLE TRIGGER ALL;
ALTER TABLE Alloggio DISABLE TRIGGER ALL;
ALTER TABLE Mezzo_Trasporto DISABLE TRIGGER ALL;
ALTER TABLE Vendita DISABLE TRIGGER ALL;
ALTER TABLE Sistemazione DISABLE TRIGGER ALL;
ALTER TABLE Trasporto DISABLE TRIGGER ALL;

INSERT INTO Agenzia(Codice,Tipologia,Responsabile,Telefono,Mail,Stato,Citta,Via,CAP,N_vendite) VALUES
('A001','Sede','D011','0168653462','Proin.vel@euismodacfermentum.org','Italia','Padova','Corso Milano 8','35100',34173),
('A002','Ufficio','D003','0145511008','nisl.Nulla.eu@eu.edu','Cook Islands','Brahmapur','Ap #191-131 Fringilla Road','21028',2969),
('A003','Ufficio','D014','0345941976','Proin.mi.Aliquam@lacus.edu','Congo','Eernegem','Ap #378-8148 Justo Avenue','18912',21864),
('A004','Ufficio','D009','0224737577','Aenean@blanditviverra.ca','Ecuador','Sachs Harbour','7289 Dapibus St.','17962',5799),
('A005','Infopoint','D013','0178999247','sapien.imperdiet.ornare@ipsumdolor.ca','Cook Islands','Perpignan','319-1424 Dui Road','64328',24957),
('A006','Ufficio','D022','0112935837','habitant.morbi.tristique@sempererat.org','Italia','Roma','P.O. Box 311, 1601 Aliquam Av.','06707',64147),
('A007','Infopoint','D027','0732852586','enim.diam@quamPellentesque.co.uk','Ecuador','Thane','9687 Egestas Street','14436',62656),
('A008','Ufficio','D028','0744846856','ipsum.cursus.vestibulum@sapienimperdiet.co.uk','Italia','Soledad',' strada Road','95917',32917),
('A009','Ufficio','D026','0725374846','rutrum@neque.org','Finland','Strijtem','2949 Id Av.','33629',2499),
('A010','Infopoint','D030','0784222644','Nulla.tempor.augue@nisimagnased.net','Congo','Oberhausen','386-2253 Suscipit, St.','88888',8461),
('A011','Ufficio','D025','0372092554','nulla.vulputate@cursusetmagna.net','Grecia','Cetara','4449 Lectus Street','95957',88637),
('A012','Infopoint','D010','0447672250','magna.nec@conubia.com','Papua New Guinea','Brechin','P.O. Box 697 3437 Aliquet Avenue','12875',64210),
('A013','Ufficio','D012','0873386764','Suspendisse.tristique.neque@auctorvitae.com','Finland','Kitscoty','P.O. Box 290 3690 Semper Av.','12099',2270),
('A014','Infopoint','D007','0292940606','pede.ultrices.a@duiFuscealiquam.co.uk','Brasile','Zeitz','209-2232 Nulla. Ave','85395',99444),
('A015','Ufficio','D006','0340927769','arcu.Aliquam.ultrices@pharetraNam.com','Italia','Bridgnorth','P.O. Box 935, 3212 Metus. Ave','19975',98797);

INSERT INTO Alloggio (Codice,Tipologia,Categoria,Nome,Stato,Citta,Via,Mail,Telefono,Link) VALUES
('S001','crociera','balcone','Kline','Mauritania','Pont-Saint-Martin','8474 Natoque Road','nisi.a.odio@loremut.co.uk','01 08 41 72 95','www.Aliquamornare\libero\at.ct'),
('S002','bungalow',' ','Sanford','Belize','Mira Bhayandar','P.O. Box 122, 2537 Eleifend Rd.','elit.Nulla@elitpretium.com','05 91 41 43 75','www.nisl\Maecenas\malesuada.est'),
('S003','crociera','interna','Penelope','Italia','Venezia','Porto Tronchetto 27','penatibus.et.magnis@aliquamenimnec.co.uk','09 71 94 29 43','www.amet\risus\Donecegestas.Ali'),
('S004','hotel','5','Harvey','Maldives','Veere','2278 Dis Rd.','porttitor@Nullamvitaediam.ca','09 47 48 53 01','www.liberonec\ligula\onsectetuer\rhoncus.de'),
('S005','B&B','5','Calderon','Mauritania','Pont-Saint-Martin','Ap #277-733 Egestas Ave','Maecenas.mi.felis@non.org','09 11 72 48 54','www.ac\eleifend\vitae.si'),
('S006','appartamento','2','Ortega','Mozambique','Haldia','P.O. Box 181, 7895 Orci. Rd.','velit.egestas.lacinia@diameudolor.org','03 86 71 98 10','www.cursus\hendrerit\consectetuer.ur'),
('S007','hotel','3','Kane','Qatar','Mellet','P.O. Box 995, 3833 Erat Avenue','nec@Fuscediam.edu','04 09 73 72 81','www.nec\ligula\rhoncus.Nu'),
('S008','B&B',' ','Alston','Croatia','Lede','220-2088 Mi Rd.','Mauris.non.dui@utnullaCras.com','08 85 54 73 15','www.rhoncusid\mollis\neccurs.us'),
('S009','hotel','3','Margaret','Macao','Baie-Comeau','679-9536 Eleifend. Avenue','In.scelerisque.scelerisque@turpis.net','03 86 63 61 33','www.cubiliaCurae\Phasellus\ornare.Fusce'),
('S010','bungalow','balcone','Owen','Croatia','Lede','P.O. Box 188, 8300 Eros Ave','magnis@vitaedolor.org','01 70 76 84 77','www.Fusce\mi\lorem\vehicula.et'),
('S011','appartamento',' ','Mozambique','Haldia','Pozzuolo del Friuli','4887 Nunc Ave','lacinia.mattis.Integer@purusin.net','02 28 97 91 01','www.purus\Duis_elementum.dui'),
('S012','hotel','5','Sharpe','Italia','Roma','Ap #496-6222 Integer Rd.','et.arcu@Donec.net','09 26 07 47 79','www.sollicitudin\orci.sem'),
('S013','appartamento',' ','Christian','Italia','Roma','3362 Magna. Rd.','erat@acturpisegestas.edu','08 63 03 29 44','www.arcu\iaculis\enimsit.am'),
('S014','crociera','oblò','Ulysses','British Indian Ocean Territory','Rutland','195-5595 Nec Rd.','dolor@Etiam.net','02 30 63 68 64','www.tellus\faucibus\leo.in') ,
('S015','B&B','4','Luna','Italia','Venezia','3386 Ac Ave','nec.quam.Curabitur@elit.edu','02 17 67 53 57','www.mauris\erat\eget\ipsum\Suspendisse.kj'),
('S016','hotel','5','Hyatt','Italia','Venezia','Calle San Vincenzo 18','lacus.Quisque@liberoettristique.co.uk','06 96 69 82 23','www.luctus\Curabitur\nunc.sed'),
('S017','appartamento',' ','Vincent','Saint Helena','Orosei','964-3734 Interdum. St.','eu.nulla.at@pedeblanditcongue.edu','04 84 38 71 30','www.mi\fringilla\lacinia\mattis'),
('S018','appartamento',' ','Declan','Cook Islands','Brahmapur','Ap #169-7499 Nunc Road','massa@Etiamgravidamolestie.ca','07 42 89 62 14','www.Sed\eget\lacus\Mauris\no'),
('S019','appartamento','','Curico','Libya','Curicó','Paper Road 25', 'paper.curico@libyaappartament.ly','02 35 56 23 77','www.Lybia\paper\porpora\curicà.ly'),
('S020','bungalow',' ','Manke','Cile','Manquemapu','Manke Road 30','manke.manque@cilecamping.cil','03 48 57 95 78','www.camping\cile\manque\manke.cil'),
('S021','appartamento',' ','Tundra','Canada','Repulse Buy','Road Naujat 13','tundraappartaments@repulse.canada.ca','01 02 04 05 79','www.canada\nunavut\tundra.ca');

INSERT INTO Cliente(PI_CF,Nome_azienda,Cognome,Nome,Mail,Telefono,Stato,Citta,Via,CAP,Anno_iscrizione,Codice_agenzia)VALUES
('39715065399','Pede Praesent Associates','Carney','Cain','ac@euismod.edu','03 16 67 20 35','Malaysia','San Maurizio Canavese','4561 Nisi St.','44305',1998,'A001'),
('60750718099','Vivamus Euismod PC','Decker','Nevada','eu@eleifendnondapibus.net','05 88 78 27 70','Iceland','Beert','753-7999 Felis, Avenue','38604',2015,'A013'),
('15958682599','Maecenas Incorporated','Horne','Kamal','bibendum.fermentum.metus@diam.edu','07 12 83 90 76','Virgin Islands, United States','Hartford','Ap #520-4190 Risus, Rd.','78320',1999,'A004'),
('76448889099',' ','Spencer','Clare','arcu@aliquet.co.uk','08 41 89 43 39','Italia','Cuba','Via Apollo Integer 37','Z3822',2020,'A003'),
('62466063299',' ','Pitts','Rylee','vitae.risus.Duis@sapiencursus.edu','06 20 85 88 21','Ethiopia','Minneapolis','740-7339 Suspendisse Road','94937',2012,'A014'),
('03232008799','Sodales Associates','Watkins','Plato','mollis.dui@necmollisvitae.ca','03 93 68 10 21','Ghana','Antibes','849 Adipiscing St.','11640',2000,'A001'),
('78919590999','Nunc Foundation','Massey','Willow','consequat.auctor.nunc@neque.edu','09 46 45 66 31','Netherlands','Amsterdam','9621 Phasellus Rd.','32267',2012,'A009'),
('58930107599',' ','Gardner','Griffin','Aenean@ac.org','09 35 28 82 81','Northern Mariana Islands','Açailândia','P.O. Box 560, 1638 Etiam Rd.','B5746',2004,'A010'),
('90766754599',' ','Morrow','Madonna','a@Etiamgravidamolestie.net','07 69 13 77 68','Mexico','Mielec','Ap #780-9335 Per Rd.','K4T1C',2005,'A006'),
('37236501799','Aliquam Associates','Schultz','Holly','sed.sapien.Nunc@Phasellusfermentum.ca','06 06 25 68 36','Gabon','Corbara','P.O. Box 219, 2156 Proin Rd.','19873',2019,'A015'),
('68326940799',' ','Cox','Martina','semper.et.lacinia@lacusEtiam.org','06 44 91 39 83','South Africa','Rignano Garganico','700-5468 Vitae Ave','14864',2009,'A003'),
('25610959899',' ','Moss','Geoffrey','laoreet.posuere@Sed.com','07 31 36 42 85','San Marino','Hines Creek','351-4911 Elit, Street','16090',2002,'A005'),
('86708057299','Ligula Enim Industries','Gilmore','Maxine','lacus@vulputatemauris.net','04 96 70 12 50','Martinique','Woking','505-2373 Posuere St.','16541',2006,'A013'),
('65712784599','','Casey','Bevis','et.netus.et@orci.ca','05 80 52 71 45','Reunion','Gaggio Montano','Ap #468-1311 Et Ave','97820',2012,'A013'),
('11336869299',' ','Compton','Raven','ac@dignissimpharetraNam.org','03 83 24 68 73','Korea, South','Shchyolkovo','9650 Odio. Ave','51030',2013,'A011'),
('68970069899','At Lacus Industries','Kemp','Adria','dolor@dictum.ca','05 54 53 43 72','Suriname','Merbes-Sainte-Marie','604-2907 Mauris. Ave','41422',2005,'A014'),
('03802205599','Egestas Aliquam Nec Company','Spencer','Ciara','mauris.erat.eget@etlacinia.org','07 99 98 41 74','Uzbekistan','Montegranaro','427-7569 Vivamus St.','64391',2016,'A015'),
('09747224799',' ','Sellers','Sigourney','ipsum.nunc@semperegestas.net','08 82 27 67 23','Norway','Yellowknife','691-2751 Phasellus St.','76945',2008,'A012'),
('94431040999','Vehicula Aliquet Limited','Fulton','Castor','Sed.congue@Donec.edu','08 19 71 13 85','Lesotho','Los Mochis','9776 Penatibus Road','87567',2006,'A010'),
('44660761499','Vitae Company','Juarez','Deanna','quis.massa@venenatislacus.ca','05 17 42 06 00','Malaysia','Ruza','Ap #183-8403 Augue St.','X4097',2017,'A005'),
('12813974499','Sem Semper Erat Institute','Tran','Brielle','amet@insodales.co.uk','04 94 35 01 28','Central African Republic','Malartic','Ap #908-3332 Fringilla St.','70254',2013,'A014'),
('19456665199','','Barker','Chastity','egestas.Aliquam.fringilla@PhasellusnullaInteger.org','01 49 08 11 84','Serbia','Zhukovka','3776 Iaculis, Road','19507',2008,'A004'),
('41725733099','','Wynn','Dorian','urna.Vivamus@ipsumdolor.ca','04 52 00 90 69','Czech Republic','Marchienne-au-Pont','P.O. Box 804, 9236 Elit Av.','84084',2018,'A014'),
('62379733599','','Fuller','Walker','ante.lectus@Nullamutnisi.ca','07 90 54 64 43','Angola','Traun','P.O. Box 493, 4168 Mauris St.','75394',2017,'A001'),
('87384600399','Phasellus Vitae Incorporated','Martin','Amy','suscipit.est.ac@semperrutrumFusce.co.uk','08 88 13 43 60','Portugal','Peumo','Ap #782-9206 Ac Rd.','40484',2005,'A015'),
('19645937999','Et Industries','Fulton','Jasper','tellus.imperdiet.non@litoratorquentper.ca','01 35 25 27 30','Mozambique','Gary','Ap #255-9491 Mauris St.','91388',2016,'A006'),
('06267212799','Amet Orci Institute','Kelley','Caryn','ullamcorper.Duis.at@tincidunt.edu','05 43 97 63 50','Greenland','Tulsa','8654 Enim. Rd.','30872',2011,'A014'),
('03683065099','','Conway','Jamalia','arcu.Sed.et@aliquetmolestie.ca','08 74 08 34 22','Bonaire','Baulers',' Z490-14 Morbi Avenue','74034',2018,'A006'),
('89368720399','Nec Limited','Townsend','Nadine','parturient.montes.nascetur@vel.com','02 12 41 04 81','Suriname','Riohacha','1216 Convallis St.','18236',2013,'A010');

INSERT INTO Dipendente(Codice,Mansione,Ruolo,Mail,Telefono,Cognome,Nome,Sede) VALUES
('D001','venditore','Direttore','risus.Quisque@euismod.net','06 84 57 43 96','Nolan','Raphael','A001'),
('D002','venditore','responsabile amministrativo','tempor.erat.neque@hymenaeos.edu','06 24 66 53 32','Charles','Arthur','A001'),
('D003','guida turistica','responsabile agenzia','non.arcu.Vivamus@sapien.ca','08 05 86 86 47','Barry','Indigo','A002'),
('D004','guida turistica','responsabile infopoint','volutpat.Nulla@Integervitae.co.uk','03 74 18 19 42','James','Reed','A003'),
('D005','guida turistica','impiegato','In@necmalesuadaut.co.uk','02 80 73 51 75','Martinez','Helen','A015'),
('D006','guida turistica','responsabile agenzia','libero.Proin@bibendumullamcorper.co.uk','07 64 68 71 85','Norton','Kieran','A015'),
('D007','venditore','responsabile infopoint','ultrices.Vivamus@Duismi.co.uk','08 06 57 56 59','Decker','Amena','A014'),
('D008','assistente','responsabile legale','in.tempus@erat.com','07 85 58 91 92','Sosa','Murphy','A001'),
('D009','venditore','responsabile agenzia','fringilla@arcu.edu','03 72 42 93 44','Perez','TaShya','A004'),
('D010','venditore','responsabile infopoint','velit@sedorcilobortis.com','05 60 20 57 33','Riley','Orlando','A012'),
('D011','venditore','responsabile agenzia','enim.mi@Donecatarcu.co.uk','05 10 18 84 72','Craig','Brody','A001'),
('D012','venditore','responsabile agenzia','neque.pellentesque.massa@estmollis.co.uk','07 28 90 05 01','Pierce','Rigel','A013'),
('D013','assistente','responsabile infopoint','Sed@facilisiSed.co.uk','08 24 14 74 72','Banks','Justin','A005'),
('D014','assistente','responsabile agenzia','Fusce.aliquet.magna@adipiscing.net','09 45 26 57 56','Hines','Hayden','A003'),
('D015','guida turistica','impiegato','augue.eu@ante.edu','02 55 01 29 15','Reynolds','Blair','A007'),
('D016','venditore','responsabile infopoint','cursus@Sedidrisus.net','07 81 00 60 60','Dixon','Petra','A009'),
('D017','assistente','impiegato','blandit.congue@massaVestibulum.co.uk','05 84 91 72 40','Flynn','Clark','A011'),
('D018','assistente','impiegato ','a.dui@Nunc.ca','01 74 43 18 91','Joyce','Lane','A009'),
('D019','venditore','responsabile agenzia','sit.amet@odioPhasellusat.org','06 89 32 92 13','Singleton','Hasad','A007'),
('D020','assistente','impiegato','quis@Phasellusfermentumconvallis.edu','01 44 68 90 67','Merrill','Samantha','A008'),
('D021','guida turistica','impiegato','vehicula@Pellentesquetincidunttempus.net','09 49 91 37 06','Kirkland','Petra','A004'),
('D022','venditore','responsabile agenzia','pellentesque.massa@ipsumDonecsollicitudin.org','04 19 73 61 30','Mckee','Price','A006'),
('D023','venditore','impiegato','fermentum@tinciduntnibhPhasellus.net','06 39 01 04 28','Sears','Gil','A006'),
('D024','venditore','impiegato','Praesent.eu.dui@Donecvitaeerat.ca','03 24 37 72 92','Moore','Fritz','A013'),
('D025','venditore','responsabile infopoint','Cras.sed.leo@nonduinec.net','09 04 98 08 86','Pruitt','Ruby','A011'),
('D026','guida turistica','responsabile agenzia','Aliquam.ornare@elitCurabitur.com','09 07 34 16 07','Peters','Kasimir','A009'),
('D027','venditore','impiegato','euismod.ac@Pellentesquehabitant.co.uk','09 71 79 70 00','Dodson','Lareina','A007'),
('D028','venditore','responsabile agenzia','vel.venenatis.vel@ligulaAeneaneuismod.edu','04 94 71 88 09','Warner','Elton','A008'),
('D029','assistente','impiegato','Sed.molestie@telluseuaugue.org','05 76 01 60 49','Christensen','Emi','A012'),
('D030','assistente','responsabile infopoint','bibendum.Donec@Donecporttitortellus.co.uk','07 95 65 53 05','Stevenson','Dalton','A010'),
('D031','guida turistica','impiegato','fermcur.kod@necmaadesuaut.uk','02 80 73 53 75','Mexico','Helen','A012');

INSERT INTO Dati_Personali(CF,Codice_dip,Contratto,Stipendio,Data_inizio,Data_fine,Stato,Citta,Via,CAP,Sesso,Data_nascita)VALUES
('166706248883','D008','indeterminato',6643.50,'1998-01-08','2999-12-31','Bangladesh','Fraser-Fort George','882-4135 Dapibus Av.','60627','F','1977-12-18'),
('160202265385','D001','indeterminato',2571,'1998-08-15','2999-12-31','Italia','Padova','Corso Uniti 33','06999','F','1980-07-15'),
('168008129002','D002','indeterminato',4411,'1998-11-25','2999-12-31','Saint Martin','Gangtok','P.O. Box 873, 9037 Felis Av.','93633','F','1985-02-20'),
('160207056888','D013','indeterminato',4790,'2999-12-31','2005-05-17','Virgin Islands, British','ThimZon','911 Lacus. Ave','28443','M','1975-04-17'),
('162411173699','D031','a chiamata',4069,'2006-12-22','2030-04-24','Finland','Hanau','4690 Eget, Street','30074','F','1957-04-28'),
('162108293388','D003','indeterminato',1347,'2006-07-01','2999-12-31','French Southern Territories','Wabamun','P.O. Box 498, 87115 Metus St.','70701','F','1992-12-15'),
('163208125397','D011','indeterminato',2359,'2011-01-06','2999-12-31','Peru','Vilvoorde','Ap #905-8003 Nisl. Ave','98135','M','1970-04-20'),
('163909144903','D005','indeterminato',7706,'2008-05-03','2999-12-31','Qatar','Ninhue','437-6248 Lectus St.','74210','M','1978-09-25'),
('160003162799','D021','stagista',5341,'1994-02-16','2029-12-31','Peru','Bhusawal','Ap #140-3116 Turpis Rd.','74073','M','1976-07-17'),
('160908284631','D016','indeterminato',4208,'2006-08-02','2999-12-31','Italy','Loupoigne','8219 Mollis Rd.','84339','F','1954-01-03'),
('167112177303','D024','indeterminato',8172,'2016-08-14','2999-12-31','Greenland','Comox','3228 Magna Rd.','97718','F','1970-05-03'),
('161607149141','D006','indeterminato',5942,'2004-08-14','2999-12-31','Suriname','Aurora','3231 Rhoncus Rd.','41352','F','1966-06-09'),
('162312137967','D030','indeterminato',8654,'2013-03-29','2999-12-31','South Africa','Lloydminster','919-7340 Adipiscing. Street','81954','F','1952-06-08'),
('168202226109','D020','a chiamata',4618,'2006-05-25','2025-08-26','Afghanistan','Neustrelitz','575-2220 Mollis. St.','59899','M','1996-02-24'),
('160210274494','D026','stagista',2947,'2019-03-09','2022-07-13','Puerto Rico','Valley East','P.O. Box 420, 3710 Blandit. St.','85729','F','1958-12-13'),
('163208075550','D009','indeterminato',3027,'2008-10-05','2999-12-31','Brazil','Kortrijk','P.O. Box 628, 6034 Turpis. Ave','76516','M','1948-10-18'),
('162010252464','D004','indeterminato',5935,'2999-12-31','2021-02-25','Djibouti','Gent','653-5081 Etiam Street','92434','F','1962-01-05'),
('162909068302','D010','indeterminato',7878,'2002-07-30','2999-12-31','Fiji','Khyber Agency','1495 Velit Rd.','66492','M','1953-04-11'),
('163204262202','D015','a chiamata',1203,'2016-08-13','2025-12-16','Cuba','Vandoeuvre-lès-Nancy','484-8662 Rutrum Street','AW8ZA','F','1953-05-10'),
('162204207068','D017','stagista',2912,'2006-06-22','2039-12-31','Cambodia','Stranraer','Ap #176-4342 Et St.','36447','F','1984-04-26'),
('165401039762','D023','indeterminato',991,'1994-07-01','2999-12-31','Turkmenistan','Memphis','730-8183 Et Avenue','30638','F','1987-03-24'),
('166506091252','D012','indeterminato',1547,'2015-03-12','2999-12-31','Pakistan','Guarulhos','3470 Condimentum Ave','26030','F','1994-11-25'),
('164604308827','D027','indeterminato',7344,'2019-11-13','2999-12-31','Christmas Island','Reutlingen','2115 Praesent Rd.','M38N5','M','1976-06-26'),
('169904196830','D022','indeterminato',2722,'2006-01-25','2999-12-31','Kyrgyzstan','Koolkerke','Ap #169-5794 Cras Avenue','65720','M','11-07-82'),
('162711101283','D025','indeterminato',5488,'2005-07-18','2999-12-31','Serbia','Swan Hill','6175 Tristique Avenue','84920','M','1951-07-30'),
('160807287339','D019','indeterminato',9859,'2018-06-15','2999-12-31','Pitcairn Islands','Grand-Manil','489-9857 Quis, Rd.','55917','F','1980-07-03'),
('167608295171','D028','indeterminato',5076,'2007-10-22','2999-12-31','Argentina','Rixensart','Ap #709-7152 Mauris Ave','Z2708','F','1969-10-01'),
('163007256450','D014','indeterminato',921,'2020-06-03','2999-12-31','Georgia','Adelaide','Ap #402-7936 Sed Av.','25499','F','1955-06-14'),
('162508089600','D029','a chiamata',2795,'2004-06-21','2022-10-19','Greece','Terragnolo','P.O. Box 721, 9925 Dolor St.','45521','M','1959-01-23'),
('169103115755','D032','a chiamata',6784,'2004-01-05','2021-05-10','Poland','Monte Vidon Corrado','Ap #159-9527 Quisque Ave','29322','M','1966-04-03'),
('164301215218','D033','indeterminato',4332,'1993-01-19','2999-12-31','Bosnia and Herzegovina','Rechnitz','483-9869 Aliquet, St.','78604','M','1957-10-04'),
('162601137579','D007','indeterminato',1101,'1996-03-12','2999-12-31','Niue','Saint-Georges','P.O. Box 911, 7277 Curabitur Rd.','74386','F','1975-05-02'),
('161009254713','D018','a chiamata',7545,'1995-10-31','2021-09-16','Guam','Callander','Ap #941-4120 Ultricies Road','59640','F','1972-08-06');

INSERT INTO Mezzo_Trasporto (Codice,P_Stato,P_Citta,D_Stato,D_Citta,Mezzo,Durata,Costo,Link) VALUES
('T001','Italia','Venezia','Crozia','Lede','treno',10,999,'www.inceptos\hymenaeos.Ma'),
('T002','Italia','Roma','Cook Islands','Brahmapur','aereo',15,1407,'www.ullamcorper\velit\aliquet.lo'),
('T003','Macao','Baie-Comeau','Cook Islands','Brahmapur','treno',17,771,'www.nec\tempus\scelerisque.ip'),
('T004','Mozambique','Haldia','Italia','Venezia','aereo',10,969,'www.massa\rutrum\agnacra.is'),
('T005','Qatar','Mellet','Saint Helena','Orosei','treno',3,59,'www.ultrices\posuere\Phasellus.bc'),
('T006','British Indian Ocean Territory','Rutland','Libya','Curicó','nave',16,2665,'www.elit\Nulla\facilisi.Sed'),
('T007','Libya','Curicó','Belize','Mira Bhayandar','aereo',17,1275,'www.rhoncus\Nullam\velit.dui'),
('T008','Mauritania','Pont-Saint-Martin','Libya','Curicó','nave',11,3154,'www.arcu\acorci.Ut'),
('T009','Italia','treno','Libya','Curicó','Roma',18,2073,'www.dolor\dapibus\gravida.Ali'),
('T010','Grenada','Tirunelveli','Italia','Venezia','aereo',18,1575,'www.arc\metus\urna.nv'),                                                                                                                                                                                                                                           
('T011','Belize','Mira Bhayandar','Libya','Curicó','aereo',5,338,'www.amet\consectetuer.ng'),
('T012','Cook Islands','Brahmapur','Libya','Curicó','treno',11,685,'www.Cra\dolor\tempus.nn'),
('T013','Grenada','Tirunelveli','Libya','Curicó','nave',7,802,'www.ante\blandit\viverra.Do'),
('T014','Libya','Curicó','Mauritania','Pont-Saint-Martin','aereo',10,3440,'www.Suspendisse\aliquet\sem.ut'),
('T015','Belize','Mira Bhayandar','Qatar','Mellet','aereo',3,1305,'www.habitant\morbi\tristique\senectus.et'),
('T016','Mozambique','Haldia','Macao','Baie-Comeau','treno',5,1522,'www.dignissim\magna\tortor.Nu'),
('T017','Italia','Roma','Croatia','Lede','treno',10,1771,'www.tellus\Suspendisse\sed\dolor.kl'),
('T018','Mauritania','Pont-Saint-Martin','Belize','Mira Bhayandar','aereo',6,778,'www.enim\condimentum\eget.vo'),
('T019','Macao','Baie-Comeau','Croatia','Lede','treno',17,2507,'www.dolor\sitamet\consectetuer.ad'),
('T020','Cook Islands','Brahmapur','Croatia','Lede','nave',18,2777,'www.diam\at\pretium\aliquet.met'),
('T021','Mozambique','Haldia','Macao','Baie-Comeau','aereo',17,183,'www.Curabitur\egestas\nuncsed.lib'),
('T022','Belize','Mira Bhayandar','Libya','Curicó','treno',16,157,'www.Donec\est.Nu'),
('T023','Mozambique','Haldia','Cook Islands','Brahmapur','aereo',1,673,'www.consectetuer\adipiscing elit.Aliquam'),
('T024','Qatar','Mellet','Macao','Baie-Comeau','treno',2,1838,'www.mole\tortor\nibh\sit.met'),
('T025','Italia','Venezia','Italia','Roma','treno',7,406,'www.massa\rutrum magna.Cra');

INSERT INTO Sistemazione(Codice_Viaggio,Codice_Alloggio	) VALUES
('V001','S018'),
('V002','S001'),
('V002','S005'),
('V003','S003'),
('V003','S015'),
('V003','S016'),
('V004','S006'),
('V004','S011'),
('V005','S007'),
('V006','S012'),
('V006','S013'),
('V007','S009'),
('V008','S019'),
('V009','S012'),
('V009','S013'),
('V010','S002'),
('V011','S014'),
('V012','S003'),
('V012','S015'),
('V013','S016'),
('V014','S017'),
('V015','S008'),
('V015','S010'),
('V016','S020'),
('V017','S021');


INSERT INTO Trasporto(Codice_viaggio,Codice_mezzo)VALUES
('V001','T002'),
('V001','T003'),
('V001','T012'),
('V001','T020'),
('V001','T023'),
('V002','T008'),
('V002','T014'),
('V002','T018'),
('V003','T001'),
('V003','T004'),
('V003','T010'),
('V003','T025'),
('V004','T004'),
('V004','T016'),
('V004','T021'),
('V004','T023'),
('V005','T005'),
('V005','T015'),
('V005','T024'),
('V006','T002'),
('V006','T009'),
('V006','T017'),
('V006','T025'),
('V007','T003'),
('V007','T016'),
('V007','T019'),
('V007','T021'),
('V007','T024'),
('V008','T006'),
('V008','T007'),
('V008','T008'),
('V008','T009'),
('V008','T011'),
('V008','T012'),
('V008','T013'),
('V008','T014'),
('V008','T022'),
('V009','T002'),
('V009','T009'),
('V009','T017'),
('V009','T025'),
('V010','T007'),
('V010','T011'),
('V010','T015'),
('V010','T018'),
('V010','T022'),
('V011','T006'),
('V012','T001'),
('V012','T004'),
('V012','T010'),
('V012','T025'),
('V013','T005'),
('V014','T010'),
('V014','T013'),
('V015','T001'),
('V015','T017'),
('V015','T019'),
('V015','T020');

INSERT INTO Vendita(Cliente,Data,Codice_viaggio,Totale,Codice_dip,Codice_transfer1,Codice_transfer2,Codice_alloggio) VALUES
('39715065399','1998-05-02','V001',9709,'D001','T001','T003' ,'S018'),
('39715065399','1998-08-31','V002',4056,'D002',' ',' ','S001'),
('60750718099','1999-06-03','V001',7102,'D002',' ',' ','S018'),
('39715065399','1999-07-15','V002',3381,'D001','T008',' ','S005'),
('03232008799','2000-12-06','V003',4428,'D002',' ','T004','S003'),
('15958682599','2001-02-07','V003',9042,'D001','T010','T010','S015'),
('25610959899','2002-02-02','V002',8677,'D001','T008','T014','S005'),
('15958682599','2002-03-20','V004',1126,'D002','T021','T016','S006'),
('58930107599','2004-01-22','V005',4502,'D007',' ',' ','S007'),
('87384600399','2005-06-02','V004',9755,'D007',' ','T021','S011'),
('86708057299','2006-03-15','V001',9134,'D009','T012',' ','S018'),
('94431040999','2006-07-06','V003',6960,'D007','T004',' ','S015'),
('09747224799','2008-04-28','V006',3813,'D010',' ',' ','S013'),
('19456665199','2008-09-26','V006',6040,'D009','T002','T009','S012'),
('68326940799','2009-09-21','V007',9272,'D010','T003','T024','S009'),
('06267212799','2011-08-21','V005',5867,'D007','T015',' ','S007'),
('62466063299','2012-04-07','V002',1339,'D009',' ',' ','S001'),
('65712784599','2012-07-05','V008',7816,'D010','T006','T007','S019'),
('78919590999','2012-09-14','V009',4224,'D011',' ','T009','S013'),
('11336869299','2013-07-04','V008',4660,'D012','T008','T022','S019'),
('12813974499','2013-10-08','V010',9324,'D016','T007','T018','S002'),
('89368720399','2013-11-26','V004',777,'D012',' ',' ','S011'),
('60750718099','2015-05-14','V003',5562,'D016','T010','T025','S016'),
('03802205599','2016-09-27','V011',4032,'D007','T006','T006','S014'),
('19645937999','2016-11-05','V012',9709,'D019','T001','T004','S016'),
('44660761499','2017-01-26','V013',2064,'D011',' ',' ','S016'),
('62379733599','2017-05-31','V007',6851,'D022','T021',' ','S009'),
('03683065099','2018-05-22','V012',5279,'D023',' ',' ','S016'),
('41725733099','2018-06-13','V014',8319,'D024','T010','T013','S017'),
('37236501799','2019-01-26','V003',8389,'D025','T025','T010','S016'),
('76448889099','2020-03-21','V015',6135,'D027','T017',' ','S010'),
('76448889099','2020-08-21','V005',2942,'D007','T015',' ','S007'),
('60750718099','2019-04-07','V002',1339,'D009',' ',' ','S001'),
('03802205599','2010-01-03','V008',4216,'D010','T006','T007','S019'),
('78919590999','2010-05-19','V009',3259,'D011',' ','T009','S013'),
('19645937999','2020-07-28','V008',3631,'D012','T008','T022','S019'),
('41725733099','2011-10-08','V010',9242,'D016','T007','T018','S002'),
('37236501799','2014-11-26','V004',8936,'D012',' ',' ','S011'),
('76448889099','2014-05-14','V003',2189,'D016','T010','T025','S015'),
('60750718099','2015-09-27','V011',869,'D007','T006','T006','S014'),
('89368720399','2016-12-05','V012',2444,'D019','T001','T004','S003'),
('12813974499','2020-01-26','V013',5369,'D011',' ',' ','S016'),
('11336869299','2020-05-31','V007',2450,'D022','T021',' ','S009'),
('78919590999','2019-05-22','V012',7060,'D023',' ',' ','S016'),
('65712784599','2019-06-13','V014',9792,'D024','T010','T013','S017'),
('37236501799','2018-01-26','V003',7899,'D025','T025','T010','S003'),
('62466063299','2003-03-21','V015',3765,'D027','T017',' ','S010'),
('60750718099','2020-12-12','V006',5648,'D028','T009','T002','S013'),
('60750718099','2020-11-01','V006',4880,'D025',' ','T009','S012'),
('89368720399','2020-09-10','V012',7890,'D024','T004',' ','S016'),
('68326940799','2018-05-02','V001',9709,'D001','T001','T003' ,'S018'),
('39715065399','2018-08-31','V002',4056,'D002',' ',' ','S001'),
('60750718099','2019-06-03','V001',7102,'D002',' ',' ','S018'),
('89368720399','2019-07-15','V002',3381,'D001','T008',' ','S005'),
('03232008799','2020-12-06','V003',4428,'D002',' ','T004','S003'),
('15958682599','2011-02-07','V003',9042,'D001','T010','T010','S015'),
('25610959899','2012-02-02','V002',8677,'D001','T008','T014','S005'),
('89368720399','2012-03-20','V004',1126,'D002','T021','T016','S006'),
('58930107599','2014-01-22','V005',4502,'D007',' ',' ','S007'),
('39715065399','2015-06-02','V004',9755,'D007',' ','T021','S011'),
('03232008799','2016-03-15','V001',9134,'D009','T012',' ','S018'),
('94431040999','2016-07-06','V003',6960,'D007',' ','T004','S015'),
('39715065399','2018-04-28','V006',3813,'D010','T002',' ','S012'),
('19456665199','2018-09-26','V006',6040,'D009','','T009','S013'),
('60750718099','2019-09-21','V007',9272,'D010',' ','T024','S009'),
('06267212799','2019-01-16','V001',9709,'D003','T001','T003' ,'S018'),
('68326940799','2019-01-23','V002',4056,'D005',' ',' ','S001'),
('19456665199','2019-01-28','V010',7102,'D016','T007',' ','S002'),
('09747224799','2020-01-28','V002',3381,'D010','T008',' ','S005'),
('94431040999','2020-01-29','V003',4428,'D013',' ','T004','S003'),
('62466063299','2019-01-31','V011',9042,'D007','T006','T006','S014'),
('65712784599','2019-02-20','V002',8677,'D010','T008','T014','S005'),
('78919590999','2019-02-26','V004',1126,'D009','T021','T016','S006'),
('11336869299','2019-03-15','V005',4502,'D007',' ',' ','S007'),
('12813974499','2020-03-17','V012',9755,'D019','T001','T004','S016'),
('89368720399','2019-03-20','V001',9134,'D009','T012',' ','S018'),
('86708057299','2019-03-31','V003',6960,'D007','T004',' ','S015'),
('90766754599','2020-04-13','V013',3813,'D011',' ',' ','S016'),
('87384600399','2020-04-15','V006',6040,'D009','T002','T009','S012'),
('68970069899','2019-04-23','V007',9272,'D010','T003','T024','S009'),
('58930107599','2019-04-22','V005',5867,'D007','T015',' ','S007'),
('25610959899','2020-04-23','V014',1339,'D024',' ',' ','S017'),
('60750718099','2019-04-27','V008',7816,'D010','T006','T007','S019'),
('03802205599','2019-05-17','V009',4224,'D011',' ','T009','S013'),
('19645937999','2019-05-23','V015',4660,'D027','T017',' ','S010'),
('12813974499','2019-06-24','V010',9324,'D016','T007','T018','S002'),
('89368720399','2020-06-28','V004',777,'D011',' ',' ','S011'),
('03232008799','2019-07-26','V011',4032,'D007','T006','T006','S014'),
('41725733099','2020-08-14','V012',9709,'D011','T001','T004','S016'),
('37236501799','2020-08-20','V013',2064,'D012',' ',' ','S016'),
('44660761499','2019-09-20','V007',6851,'D022','T021',' ','S009'),
('76448889099','2019-09-30','V014',8319,'D024','T010','T013','S017'),
('39715065399','2019-10-14','V003',8389,'D007','T025','T010','S016'),
('15958682599','2020-11-20','V015',6135,'D025','T017',' ','S010'),
('90766754599','2019-12-13','V002',1339,'D016',' ',' ','S001'),
('06267212799','2020-12-16','V008',4216,'D010','T006','T007','S019'),
('06267212799','2020-09-30','V014',8319,'D019','T010','T013','S017'),
('25610959899','2020-05-17','V009',4224,'D022',' ','T009','S013'),
('60750718099','2019-10-25','V016',5389,'D022',' ',' ','S020'),
('03683065099','2020-09-23','V017',5279,'D023',' ',' ','S021');

INSERT INTO Viaggio(Codice,Nome,Stato,Citta,Durata,Costo,Link) VALUES
('V001','Travel Cooking','Cook Islands','Brahmapur',5,9574,'www.commodo\auctor\velit\Aliquam.ni'),
('V002','Mauritania bridge','Mauritania','Pont-Saint-Martin',5,9006,'www.sed\hendrerit.arc'),
('V003','River Venice','Italia','Venezia',5,8348,'www.elit\pharetra.ut'),
('V004','Africa Volunteering','Mozambique','Haldia',16,3284,'www.est mauris, rhoncus id, mollis'),
('V005','Travel Qt','Qatar','Mellet',6,4789,'www.accumsan\neque\etnunc.Qui'),
('V006','Roma Christ','Italia','Roma',3,8888,'www.vulputate\mauris\sagittis\placerat.Cras'),
('V007','Cacao','Macao','Baie-Comeau',12,1941,'www.est\Mauris\eu\turpis.Null'),
('V008','Carta Porpora','Libya','Curicó',10,3285,'www.khwsae\mattis\velit\justo.hj'),
('V009','Alla scoperta di Roma','Italia','Roma',6,7288,'www.dui\lectusrutrum\urna.nec'),
('V010','Centre of America','Belize','Mira Bhayandar',5,5619,'www.cubilia\Curae\Phasellus\ornare.Fu'),
('V011','British ocean','British Indian Ocean Territory','Rutland',10,7367,'www.gravida\nunc\sedpede.Cum'),
('V012','Venice Islands','Italia','Venezia',4,9133,'www.semper\italy\cursusVenice.it'),
('V013','Orosei tour','Saint Helena','Orosei',12,7063,'www.justo.Praesentluctus.Cura'),
('V014','Grenada city','Grenada','Tirunelveli',6,7056,'www.venenatis\vel\faucibus.id'),
('V015','Balcani tour','Croatia','Lede',10,832,'www.vitae\dolor.Donec'),
('V016','Cile e natura', 'Cile', 'Manquemapu',4,2050,'www.travel\nature\nothing\cile.cil'),
('V017','Icy travel','Canada','Repulse Buy',3,4550,'www.canada\icy\nunavut.icy');

ALTER TABLE Agenzia ENABLE TRIGGER ALL;
ALTER TABLE Cliente ENABLE TRIGGER ALL;
ALTER TABLE Dipendente ENABLE TRIGGER ALL;
ALTER TABLE Dati_Personali ENABLE TRIGGER ALL;
ALTER TABLE Viaggio ENABLE TRIGGER ALL;
ALTER TABLE Alloggio ENABLE TRIGGER ALL;
ALTER TABLE Mezzo_Trasporto ENABLE TRIGGER ALL;
ALTER TABLE Vendita ENABLE TRIGGER ALL;
ALTER TABLE Sistemazione ENABLE TRIGGER ALL;
ALTER TABLE Trasporto ENABLE TRIGGER ALL;

CREATE INDEX IndexViaggi ON Viaggio(Stato);




